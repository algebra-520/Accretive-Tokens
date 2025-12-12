# AGB-ART • Accretive Art on EVM  
**Algebra → AGB Coin (ERC-20) + AGB-ART (ERC-721)**  
An enhanced, internally audited fork of the legendary ERC520 standard — now with full EIP-2981 royalties and permanent funding for creativity.

GitHub (original): https://github.com/ERC520/Accretive-Tokens  
This repo: A living, community-governed evolution built to power digital, media, and AI-generated art initiatives forever.

> “Every burn makes every remaining holder richer — forever.”  
> That is the unbreakable promise of the ERC520 accretive model.

### The Story & Mission of AGB-ART

In 2025, artists, AI researchers, and crypto builders under the Morpheus umbrella asked a simple yet revolutionary question:

> What if an NFT collection could become a self-sustaining, ever-growing treasury that funds real-world creative projects — without endless royalties, without middlemen, and without ever diluting?

The answer was ERC520.  
They forked it, battle-tested it, added EIP-2981 royalties, and created **AGB-ART**:

- 2,100 Genesis NFTs (AGB-ART)  
- Paired with exactly 21,000,000 AGB tokens (Bitcoin-style hard cap)  
- Backed by a permanent 1,000,000 AGB treasury that grows with every burn  
- 5% secondary royalty (adjustable 0–10%) + 2.5% burn fee → all dedicated to supporting artists and creative projects

As a permanent thank-you, the first 100 Morpheus contributors each received a whitelist for up to 21 mints during genesis.

### How the Accretive Model Works

| Phase              | What Happens                                                    | Who Benefits & How                                      |
|--------------------|------------------------------------------------------------------|----------------------------------------------------------|
| Genesis Mint       | 2,100 NFTs at 0.25 units (MOR/USDC/etc.)                        | 100% of proceeds → Creator treasury                      |
| Secondary Trading  | Normal sales on OpenSea, Blur, Zora, Magic Eden                 | 5% EIP-2981 royalty → Creator (for art grants)           |
| Burn to Earn       | Holder burns NFT after sell-out                                 | 95% of treasury share → burner<br>2.5% → Creator treasury<br>2.5% → ERC520.org |
| Accretive Flywheel | Each burn reduces supply by 1                                   | Remaining NFTs now backed by more AGB — forever          |

→ The contract holds AGB tokens permanently. Every burn mathematically increases the backing of every surviving NFT.

### Tokenomics — Bitcoin Scarcity + Accretive Superpower

| Feature               | AGB Coin                          | Bitcoin                          |
|-----------------------|-----------------------------------|----------------------------------|
| Max Supply            | 21,000,000 (hard-coded)           | 21,000,000                       |
| Halving               | Every 4 years (in AGB token)      | Every 4 years                    |
| Final token           | ~Year 2140                        | ~Year 2140                       |
| Deflation mechanism   | Halving + NFT burns               | Halving only                     |
| Real backing per NFT  | Permanent treasury growth         | None                             |

AGB = Bitcoin-level scarcity, supercharged.

### Full 2025 Marketplace & DEX Compatibility

| Feature                        | Status    | Details                                                                 |
|--------------------------------|-----------|-------------------------------------------------------------------------|
| ERC-721 + Enumerable + URIStorage | Implemented | Works everywhere                                                        |
| EIP-2981 Royalties             | Implemented | 5% default (adjustable 0–10% via `setRoyaltyInfo`) — paid on every trade |
| Royalty Flexibility            | Implemented | Creator (or future multisig) can change % anytime                        |
| Batch Mint (up to 21)          | Implemented | Gas-efficient sequential minting                                        |
| On-chain Provable Rarity       | Implemented | 10 tiers via `prevrandao` — no reveal, no trust needed                   |
| Sudoswap / NFTX Pools          | Implemented | Works out-of-the-box                                                    |
| OpenSea, Blur, Zora, Magic Eden | Implemented | Royalties auto-detected and paid                                         |

### Tiered Rarity (Fully On-Chain)

```solidity
uint16[10] thresholds = [3, 8, 18, 38, 78, 158, 288, 488, 788, 1000];
→ Tier 0 (rarest) to Tier 9 (common)
```

Metadata assigned at mint time — transparent and immutable.

### Funding Creativity Forever

All secondary royalties (5%) and burn fees (2.5%) flow to the **Creator treasury**, which is dedicated to:

- Art & AI creation grants  
- Open-source tooling for generative art  
- Community events and residencies  
- Support for underrepresented digital artists

This isn’t speculation. This is patronage engineered into the protocol.

### Security & Governance

- Creator role can be transferred to a 2-of-3 Gnosis Safe (recommended)  
- No pause, no extra minting, no hidden functions  
- Internally audited by Morpheus contributors (2025)  
- Supply, price, and reserves are immutable constants

### Contract Addresses (to be updated after deployment)

- AGB-ART NFT: `pending`  
- AGB Coin:  `pending` (auto-created on deploy)

### Credits & Eternal Gratitude

- Original ERC520 standard → https://github.com/ERC520  
- Enhancements, audit & art focus → Morpheus community contributors (2025)  
- First 100 Morpheus contributors received 21 mint whitelist spots each — forever appreciated

### Final Thought

AGB-ART is not just another 2,100-supply collection.

It is the first NFT project that mathematically guarantees:
1. Long-term holders get richer with every burn  
2. Real-world creativity gets funded forever  
3. Bitcoin-style scarcity meets NFT utility  
4. Works perfectly on every major marketplace

We are not launching art.  
We are launching a perpetual patronage engine.

Welcome to accretive art.

— The Algebra Team  
December 2025

