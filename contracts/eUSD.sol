// SPDX-License-Identifier: BSD-3-Clause-Clear
pragma solidity ^0.8.24;

import {FHE, euint32, inEuint32} from "@fhenixprotocol/contracts/FHE.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title eUSD - Encrypted Stablecoin
 * @notice Implements ERC-20 for public state and ERC-7984 logic for encrypted state.
 */
contract eUSD is ERC20, Ownable {
    // Mapping for encrypted balances (ERC-7984 style)
    mapping(address => euint32) internal _encBalances;
    
    // Total supply that is currently encrypted
    euint32 private _totalEncryptedSupply;

    event Shielded(address indexed from, uint32 amount);
    event Unshielded(address indexed to, uint32 amount);

    constructor() ERC20("Encrypted USD", "eUSD") Ownable(msg.sender) {
        _totalEncryptedSupply = FHE.asEuint32(0);
    }

    /**
     * @notice Transfer encrypted tokens to another address.
     * @param to The recipient.
     * @param encryptedAmount The encrypted amount provided as a ciphertext handle.
     */
    function transferEncrypted(address to, inEuint32 calldata encryptedAmount) public {
        euint32 amount = FHE.asEuint32(encryptedAmount);
        
        // FHE logic: Check if sender has enough balance without revealing it
        FHE.req(amount.lte(_encBalances[msg.sender]));

        _encBalances[msg.sender] = _encBalances[msg.sender] - amount;
        _encBalances[to] = _encBalances[to] + amount;
    }

    /**
     * @notice View your own encrypted balance. 
     * @dev Requires a signed public key from the user's wallet (Fhenix logic).
     */
    function balanceOfEncrypted(address account, bytes32 publicKey) public view returns (bytes memory) {
        // Only the owner of the account can see their own balance
        return _encBalances[account].seal(publicKey);
    }

    /**
     * @notice Move public ERC-20 tokens into the encrypted state.
     */
    function shield(uint32 amount) public {
        _burn(msg.sender, amount); // Remove from public supply
        
        euint32 encAmount = FHE.asEuint32(amount);
        _encBalances[msg.sender] = _encBalances[msg.sender] + encAmount;
        _totalEncryptedSupply = _totalEncryptedSupply + encAmount;

        emit Shielded(msg.sender, amount);
    }

    /**
     * @notice Move encrypted tokens back to public ERC-20 state.
     * @param encryptedAmount The amount to unshield.
     */
    function unshield(inEuint32 calldata encryptedAmount) public {
        euint32 amount = FHE.asEuint32(encryptedAmount);
        
        // Verify user has balance before unshielding
        FHE.req(amount.lte(_encBalances[msg.sender]));

        _encBalances[msg.sender] = _encBalances[msg.sender] - amount;
        _totalEncryptedSupply = _totalEncryptedSupply - amount;

        // Decrypt only the amount intended to be made public
        uint32 decryptedAmount = FHE.decrypt(amount);
        _mint(msg.sender, decryptedAmount);

        emit Unshielded(msg.sender, decryptedAmount);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}