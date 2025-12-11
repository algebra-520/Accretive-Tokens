// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title AGB — Algebra Governance Token
 * @author Algebra Team
 * @notice 1 M genesis as dex liquidity + 20 M emitted over ~136 years → exact 21 M cap
 *         Pure time-based Bitcoin-style halving
 */
contract AGB is ERC20 {
    // =====================================================================
    // Constants
    // =====================================================================

    uint256 public constant INITIAL_SUPPLY   = 1_000_000 * 1e18;
    uint256 public constant TOTAL_EMISSION   = 20_000_000 * 1e18;   // total tokens ever emitted
    uint256 public constant MAX_SUPPLY       = INITIAL_SUPPLY + TOTAL_EMISSION;
    uint256 public constant HALVING_INTERVAL = 126_144_000;        // ~4 years exactly
    //uint256 public constant HALVING_INTERVAL = 3_600; // exactly 1 hour
    uint256 public constant FINAL_CYCLE      = 34;                 // emission stops forever

    // First cycle reward = 10 M (half of total emission)
    uint256 public constant CYCLE_0_REWARD   = TOTAL_EMISSION / 2; // 10 M * 1e18

    // =====================================================================
    // Immutable state
    // =====================================================================

    address public immutable treasury;
    uint256 public immutable genesisTime;
    uint256 public treasuryDebt;

    event TreasuryDebtIncreased(uint256 indexed newDebt, uint256 amount);

    constructor(
        string memory name,
        string memory symbol,
        address _treasury
    ) ERC20(name, symbol) {
        require(_treasury != address(0), "treasury zero");
        treasury = _treasury;
        genesisTime = block.timestamp;
        _mint(treasury, INITIAL_SUPPLY);
    }

    // =====================================================================
    // Virtual totalSupply — O(1), perfect accuracy
    // =====================================================================

    function totalSupply() public view override returns (uint256) {
        uint256 elapsed = block.timestamp - genesisTime;
        uint256 cycle = elapsed / HALVING_INTERVAL;

        if (cycle >= FINAL_CYCLE) {
            return MAX_SUPPLY;
        }

        // Emission from all completed cycles: 10M + 5M + 2.5M + ... = TOTAL_EMISSION × (1 - 1/2^n)
        uint256 emittedCompleted = TOTAL_EMISSION - (TOTAL_EMISSION >> cycle);

        // Pro-rata emission in current cycle
        uint256 currentCycleReward = CYCLE_0_REWARD >> cycle;                    // 10M → 5M → 2.5M ...
        uint256 progress = elapsed % HALVING_INTERVAL;
        uint256 proRataEmission = (currentCycleReward * progress) / HALVING_INTERVAL;

        return INITIAL_SUPPLY + emittedCompleted + proRataEmission;
    }

    // =====================================================================
    // Treasury credit line
    // =====================================================================

    function circulatingSupply() public view returns (uint256) {
        uint256 ts = totalSupply();
        return treasuryDebt <= ts ? ts - treasuryDebt : 0;
    }

    function balanceOf(address account) public view override returns (uint256) {
        if (account == treasury) {
            return totalSupply() - treasuryDebt;
        }
        return super.balanceOf(account);
    }

    function _update(address from, address to, uint256 amount) internal override {
        if (from == treasury) {
            treasuryDebt += amount;
            emit TreasuryDebtIncreased(treasuryDebt, amount);
        }
        super._update(from, to, amount);
    }

    // =====================================================================
    // View helpers — no shadowing!
    // =====================================================================

    function currentCycle() public view returns (uint256) {
        return (block.timestamp - genesisTime) / HALVING_INTERVAL;
    }

    function currentRewardRate() public view returns (uint256) {
        uint256 cycle = currentCycle();
        return cycle >= FINAL_CYCLE ? 0 : CYCLE_0_REWARD >> cycle;
    }

    function secondsToNextHalving() public view returns (uint256) {
        uint256 intoCycle = (block.timestamp - genesisTime) % HALVING_INTERVAL;
        return intoCycle == 0 ? 0 : HALVING_INTERVAL - intoCycle;
    }

    function yearsUntilCap() public view returns (uint256) {
        uint256 cyclesLeft = currentCycle() < FINAL_CYCLE ? FINAL_CYCLE - currentCycle() : 0;
        return cyclesLeft * 4;
    }

    // Treasury spend — allows ERC520 to distribute tokens on burn
    function spend(uint256 amount, address to) external {
        require(msg.sender == treasury, "Only treasury");
        require(to != address(0), "Zero address");
        require(totalSupply() >= treasuryDebt + amount, "Exceeds available supply");

        treasuryDebt += amount;
        _mint(to, amount);                    
    }
}