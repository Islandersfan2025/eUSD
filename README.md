# eUSD


# eUSD: The Confidential Stablecoin

**Electronic USD (eUSD)** is a next-generation, privacy-first stablecoin. It bridges the gap between the transparency required for decentralized trust and the confidentiality required for real-world commerce. By leveraging **Fully Homomorphic Encryption (FHE)** and the **ERC-7984** standard, eUSD keeps individual balances and transaction amounts hidden from the public while remaining 1:1 backed by audited stablecoin collateral.

---

## 1. Core Architecture

The eUSD ecosystem operates through a "Lock-and-Shield" mechanism, transforming public liquidity into private, programmable value.

* **Underlying Assets (ERC-20):** eUSD is backed by a basket of liquid stablecoins including **USDC**, **USDT**, and **USD.e**. These assets are held in a transparent, audited vault or Uniswap v4 Singleton.
* **Confidential Wrapper (ERC-7984):** This standard provides the interface for "Shielding" tokens. Unlike a standard ERC-20, which stores balances as public `uint256` values, ERC-7984 stores balances as **ciphertext handles**.
* **FHEVM Integration:** All mathematical operations (transfers, swaps, and yield calculations) are performed on encrypted data using **Fully Homomorphic Encryption**. This allows the blockchain to verify a transaction is valid (e.g., the sender has enough money) without the network ever "seeing" the actual amount.

---

## 2. Key Features

| Feature | Benefit |
| --- | --- |
| **Total Privacy** | On-chain explorers show "Encrypted Blobs" instead of transaction amounts or balances. |
| **1:1 Backing** | Every eUSD is minted only when a corresponding public stablecoin is locked. |
| **Composability** | eUSD can be used in DeFi protocols (like Uniswap v4) while maintaining user privacy. |
| **Selective Disclosure** | Users can generate "View Keys" to share their transaction history with auditors or tax authorities without making it public. |

---

## 3. The Uniswap v4 Gateway

eUSD utilizes **Uniswap v4 Hooks** to provide seamless, private liquidity. This integration serves as the primary "on-ramp" for privacy.

* **Shielded Swaps:** When a user swaps USDC for eUSD, a custom `afterSwap` hook automatically encrypts the resulting balance.
* **Flash Accounting:** By using v4's Singleton architecture, users can move eUSD between different pools internally without triggering external, privacy-leaking ERC-20 transfers.
* **Privacy-Preserving LP:** Liquidity providers can contribute to eUSD pools, earning fees while their individual share of the pool remains confidential.

---

## 4. Cross-Chain & Interoperability

eUSD is designed to be a "multichain native" asset using **Hyperlane** and **LI.FI**.

1. **Any-Asset-to-eUSD:** Through LI.FI, a user can swap any token (like ETH on Polygon) and have it arrive as eUSD on Arbitrum in a single transaction.
2. **Hyperlane Warp Routes:** eUSD can be moved between FHE-enabled chains without ever "un-shielding" the value, preserving privacy across the entire modular stack.

---

## 5. Use Cases

* **B2B Payments:** Companies can pay suppliers in stablecoins without revealing their margins or order volumes to competitors.
* **Private Remittances:** Individuals can send money to family globally without exposing their total net worth on a public ledger.
* **Confidential Payroll:** Organizations can run on-chain payroll where employees' salaries are hidden from their colleagues.

> **Note:** eUSD maintains a "Confidential Total Supply" visible to the public. This ensures that everyone can verify the system is solvent and fully backed, even while individual privacy is protected.


