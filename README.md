# AGB-ART • Accretive Art on EVM  
**Algebra → AGB Coin(token) + AGB-ART (NFT)**  
An enhanced, internally audited fork of the legendary ERC520 Accretive Token standard.

GitHub: https://github.com/ERC520/Accretive-Tokens (original)  
This repository: A living, community-governed fork created to power digital, media, and AI-generated art and creative initiatives.

> “Every burn makes every remaining holder richer — forever.”  
> That is the promise of the ERC520 accretive model.

### The Story of AGB-ART

In 2025, a group of artists, AI researchers, and crypto-native builders came together under the Morpheus umbrella to ask a simple but radical question:

> What if an NFT collection could become a self-funding, ever-appreciating treasury for its holders — without royalties, without middlemen, and without ever diluting?

They found the answer in ERC520 — the cleanest, most elegant deflationary mechanism ever written in Solidity.

They forked it, battle-tested it, and turned it into **AGB-ART**:  
- 2,100 Genesis NFTs (AGB-ART)  
- Paired with 21,000,000 AGB tokens (ERC-20)  
- Backed by a permanent, ever-growing liquidity reserve

As a thank-you to the original ERC520 creators and to seed the new ecosystem, the first 100 Morpheus contributors each received a whitelist for up to 21 free mints during the genesis phase with MOR token.

### How the ERC520 Accretive Model Works

| Phase          | What Happens                                                   | Effect on Holders                              |
|----------------|----------------------------------------------------------------|------------------------------------------------|
| Genesis Mint   | 2,100 NFTs minted at 0.25 units each                           | 100% of proceeds go to Creator                 |
| Trading        | NFTs trade freely (OpenSea, Blur, etc.)                        | Normal secondary market — no royalties         |
| Burn to Earn   | Any holder can burn their NFT after sell-out                   | Contract pays out AGB tokens instantly         |
| Accretive Loop | Each burn reduces supply by 1                                  | Every remaining NFT now backed by more AGB     |

→ Every burn permanently increases the AGB backing of all surviving NFTs.
**The contract holds AGB tokens forever. Every single burn permanently increases the AGB backing of every NFT that is still alive.**

### Detailed Mechanics (from the code)

```solidity
uint256 public constant LIQUIDIY_RESERVE = 1_000_000 * 1e18;    
uint256 public MAX_GENESIS_SUPPLY = 2_100;
uint256 public MAX_TOKEN_SUPPLY    = 21_000_000;
```

- 1,000,000 AGB are sent to the contract at deployment → to creator  → as liquidity on DEX
- When an NFT is burned:
  ```solidity
  uint256 claimAmount = contractAGBBalance / currentTotalSupply;
  95% → burner (holder)
   2.5% → original creator
   2.5% → ERC520.org platform
  ```
- The NFT is destroyed forever → totalSupply decreases by 1 → every remaining NFT now backed by more AGB

This creates the cleanest deflationary flywheel in NFT history.

### Advantages of the ERC520 / AGB-ART Model

| Feature                    | Traditional NFTs         | AGB-ART (ERC520)                         |
|----------------------------|--------------------------|------------------------------------------|
| Royalty enforcement        | Required (often bypassed)| Not needed — value accrues on burn        |
| Long-term holder reward    | Only from resale         | Guaranteed AGB increase on every burn    |
| Treasury sustainability    | Usually drains           | Grows forever with each burn             |
| Creator ↔ Holder alignment | Often misaligned         | Perfectly aligned                        |
| Exit liquidity             | Need a buyer             | Instant via burn                         |
| Supply                     | Often unlimited          | Hard 2,100 cap                           |
| Dilution risk              | High                     | Literally zero                           |

### Tiered Rarity (on-chain provable randomness)

10 tiers (0–9) determined by `prevrandao` + user nonce at mint time:

```solidity
uint16[10] memory thresholds = [3, 8, 18, 38, 78, 158, 288, 488, 788, 1000];
```

→ True on-chain rarity

### Credits & Appreciation

- Original ERC520 standard and reference implementation  
  → https://github.com/ERC520
- Internal audit & enhancements for AI/art use cases  
  → Morpheus community contributors (2025)
- First 100 Morpheus contributors received 21 mint spots each as a permanent thank-you

### Contract Addresses (will be added after deployment)

- AGB-ART NFT: `pending`
- AGB Token:   `pending` (created automatically on deploy)

### Final Thought

AGB-ART is not just another 2,100-supply PFP.

It is the first NFT collection that mathematically guarantees its long-term holders become richer every time someone else leaves the ecosystem.

Burning is not destruction.  
Burning is redistribution.

Welcome to accretive art.

— The Algebra, AGB Coin / AGB Art.
December 2025