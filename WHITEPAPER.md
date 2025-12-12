![Algebra Cover](assets/cover.jpg)

# Algebra Whitepaper  
**AGB-ART • Experimental Accretive Backing for Creative Works**  
Version 1.0 — December 2025  
Open-source • Immutable • No team tokens • No promises

### 1. Abstract

Algebra is a pure on-chain experiment that asks one question:

> Can a fixed-supply token (AGB) paired with deflationary NFTs (AGB-ART) create a permanent, self-growing treasury that mathematically backs art and creative assets forever?

There is no company behind Algebra.  
There is no pre-sale, no VC round, no marketing budget, and no expectation of profit.  
Everything is deployed as immutable, audited Solidity on public EVM chains (Base recommended).

This document describes the mechanism. Nothing more.

### 2. The Economic Model

#### 2.1 Bitcoin-Style Tokenomics

| Parameter             | Value                  | Rationale                              |
|-----------------------|------------------------|----------------------------------------|
| Total supply          | 21 000 000 AGB         | Hard cap — same number as Bitcoin      |
| Emission schedule     | 4-year halving         | Predictable long-term scarcity         |
| Final token           | ~Year 2140             | Multi-generational experiment          |
| Treasury lock         | 1 000 000 AGB          | Permanently trapped in NFT contract    |

#### 2.2 Permanent Treasury & Burn Redistribution

At deployment, 1 000 000 AGB are sent to the AGB-ART contract and can never be withdrawn except through burning.

When any holder burns one AGB-ART NFT (only possible after genesis sell-out):
claimAmount = treasuryBalance ÷ remainingNFTs
→ 95 % → burner (holder)
→ 2.5 % → Creator treasury (art grants)
→ 2.5 % → ERC520.org 


Every burn permanently reduces NFT supply and permanently increases AGB backing of every surviving NFT.

![Accretive Flywheel](assets/flywheel.png)

#### 2.3 Optional Secondary Royalty (EIP-2981)

- Default 5 % on every trade (adjustable 0–10 % by Creator)  
- 100 % flows to the Creator treasury used exclusively for artist grants  
- Can be set to 0 % at any time

### 3. AGB as Neutral Backing Pair for Creative Assets

Artists and projects are free to:
- Launch collections paired against AGB on any DEX
- Use AGB liquidity pools as permanent backing
- Accept AGB for sales, commissions, or grants

AGB is designed to be the scarce, neutral reserve asset of the creative economy — like ETH is to DeFi.

### 4. Treasury Flow & Perpetual Patronage

All funds from genesis mint, secondary royalties, and burn fees flow to a single transparent Creator address (planned migration to 2-of-3 Gnosis Safe or DAO).

These funds are earmarked exclusively for:
- Art & AI creation grants
- Open-source creative tooling
- Residencies and community events

No salaries. No marketing. No profit withdrawals.

### 5. Technical Implementation

| Feature                    | Detail                                      |
|----------------------------|---------------------------------------------|
| NFT contract               | ERC-721 + Enumerable + URIStorage + EIP-2981|
| Token contract             | Custom AGB with 4-year halving              |
| Randomness                 | block.prevrandao + nonce (on-chain)         |
| Max genesis supply         | 2 100 NFTs                                  |
| Batch mint                 | Up to 21 per transaction                    |
| Burn logic                 | Pre-burn calculation, 95/2.5/2.5 split      |
| Governance                 | Creator role transferable (no renounce)     |

Full audited source code: https://github.com/YOUR_USERNAME/YOUR_REPO

### 6. Conclusion

Algebra is an experiment in perpetual patronage.

If the mechanism works:
- Long-term holders are rewarded every time someone exits
- Artists gain a backing asset that becomes scarcer over decades
- Creativity receives funding that never stops

If it fails, the code remains open for the next researcher.

No promises.  
Only mathematics.

### Important Notice

Algebra is an open-source experimental research project deployed on public blockchains.

- There is no company, no token sale, no team allocation, and no promise of value or profit  
- Interaction with the contracts (minting, trading, burning) is entirely at your own risk  
- AGB and AGB-ART tokens have no intrinsic value and may go to zero  
- This is not an investment, security, or financial product  
- You are solely responsible for your own compliance with applicable laws

No person associated with Algebra provides investment, legal, or tax advice.

— The Algebra Research Collective  
December 2025

**Deploy first on Base. Watch the experiment unfold.**