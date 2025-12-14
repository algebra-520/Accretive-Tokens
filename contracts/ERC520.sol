// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "./accretiveToken.sol";

contract ERC520 is ERC721, ReentrancyGuard, ERC721Enumerable, ERC721URIStorage {

    // Connect with ERC520.org and get featured 
    // ERC520.org 0xEc134D437173FdaE507E05c69F249a42352Efe62;
    address public immutable PLATFORM;  

    uint256 public constant LIQUIDIY_RESERVE = 1_000_000 * 1e18; 
    uint256 public MAX_GENESIS_SUPPLY = 2_100;
    uint256 public MAX_TOKEN_SUPPLY = 21_000_000;
    
    address private royaltyReceiver;
    uint96 private royaltyBps = 500;

    // Mint payment token (e.g. AGB)
    IERC20 public immutable mintingToken;

    // 0.25 units 
    uint256 public constant MINT_PRICE = 0.25 ether; 
    
    address public Creator;
    uint256 public lastID = 0;
    uint256 public startBlock;

    uint256 public treasuryDebt;

    address public accretiveTokenAddress;
    string[] public metadata;

    IERC20 public token;
    
    mapping(address => bool) public owners;
    mapping(uint256 => string) private _tokenURIs;
    mapping(uint256 => uint256) public _tokenIP;
    mapping(address => uint256) private nonces;


    event TokenCreated(address tokenAddress);
    event liquidated(address indexed owner, uint256 indexed tokenId, uint256 liquidatedValue);
    event CreatorRewardClaimed(address indexed claimer, uint256 amount, uint256 blockNumber);
    event Minted(address indexed to, uint256 indexed tokenId, uint256 tier);

    constructor(
        string memory _nftName, 
        string memory _nftTicker, 
        string memory _tokenName, 
        string memory _tokenTicker, 
        string[] memory metadataURL,
        address _platformAddress,
        address _mintingTokenAddress
    ) ERC721(_nftName, string(abi.encodePacked(_nftTicker))) {

        require(_mintingTokenAddress != address(0), "Invalid minting token");

        Creator = msg.sender;
        owners[msg.sender] = true;
        startBlock = block.number;
        PLATFORM = _platformAddress;
        mintingToken = IERC20(_mintingTokenAddress);
        royaltyReceiver = msg.sender;

        accretiveTokenAddress = address(new AGB(_tokenName, _tokenTicker, address(this)));
        token = IERC20(accretiveTokenAddress);

        emit TokenCreated(accretiveTokenAddress);
        
        setMetadata(metadataURL);

        token.transfer(msg.sender, LIQUIDIY_RESERVE);
    }

    function setMetadata(string[] memory metadataURL) internal {
        uint256 length = metadataURL.length; 
        for (uint256 i = 0; i < length; i++) {
            metadata.push(metadataURL[i]);
        }
    }


    // SINGLE MINT – 1 NFT to msg.sender
    function mint() external nonReentrant returns (uint256) {
        require(lastID < MAX_GENESIS_SUPPLY, "Sold out");

        require(
            mintingToken.transferFrom(msg.sender,Creator,MINT_PRICE), 
            "Approve 0.25 mintingToken first"
        );

        uint256[] memory ids = _mintNFTs(msg.sender, 1);
        return ids[0]; // return the single tokenId
    }

    // BATCH MINT – up to 21 NFTs to msg.sender
    function batchMint(uint256 amount) external nonReentrant returns (uint256[] memory tokenIds) {
        require(amount > 0 && amount <= 21, "Amount 1-21");
        require(lastID + amount <= MAX_GENESIS_SUPPLY, "Sold out");

        uint256 totalPrice = amount * MINT_PRICE;

        require(
            mintingToken.transferFrom(msg.sender,Creator, totalPrice),
            "Approve exact amount first"
        );

        return _mintNFTs(msg.sender, amount);
    }


    // Internal: shared minting + randomness logic
    function _mintNFTs(address to, uint256 amount) internal returns (uint256[] memory tokenIds) {
        tokenIds = new uint256[](amount);

        for (uint256 i = 0; i < amount; ) {
            uint256 nonce = nonces[msg.sender]++;

            bytes32 hash = keccak256(abi.encodePacked(
                block.prevrandao,
                msg.sender,
                nonce,
                i
            ));
            uint256 random = uint256(hash) % 1000;

            uint16[10] memory thresholds = [3, 8, 18, 38, 78, 158, 288, 488, 788, 1000];
            uint8 tier = 9;
            for (uint8 j = 0; j < 10; ) {
                if (random < thresholds[j]) {
                    tier = j;
                    break;
                }
                unchecked { j++; }
            }

            lastID++;
            uint256 tokenId = lastID;

            _safeMint(to, tokenId);
            _setTokenURI(tokenId, metadata[tier]);
            _setTokenIP(tokenId, tier);

            tokenIds[i] = tokenId;
            emit Minted(to, tokenId, tier);

            unchecked { i++; }
        }
    }



    
    function totalMetadata ()external view returns  (uint256) {
        return metadata.length;
    }

    function burn(uint256 _tokenId) external nonReentrant {
        // 1. Block burn until all genesis NFTs are minted
        require(lastID >= MAX_GENESIS_SUPPLY, "Minting not finished yet");

        // 2. Verify ownership
        require(ownerOf(_tokenId) == msg.sender, "NFT not owned by sender");

        // 3. Compute reward using PRE-BURN supply
        uint256 supplyBefore = totalSupply();
        require(supplyBefore > 0, "No supply left");  // prevents division by zero

        uint256 accreativBalance = appreciation();

        uint256 claimAmount = accreativBalance / supplyBefore;

        // 4. Reward distribution
        uint256 holderAllocation = (claimAmount * 95) / 100;     // 95%
        uint256 remaining = claimAmount - holderAllocation;      // 5% leftover
        uint256 royalty = remaining / 2;                         // 2.5% + 2.5%

        // 5. Payout BEFORE burning
        AGB(accretiveTokenAddress).spend(holderAllocation, msg.sender);
        AGB(accretiveTokenAddress).spend(royalty, Creator);
        AGB(accretiveTokenAddress).spend(royalty, PLATFORM);

        // 6. Burn the NFT
        _burn(_tokenId);
    }



    function appreciation() public view returns (uint256) {
        uint256 accretiveValue = token.balanceOf(address(this));
        return accretiveValue;
    }



    function _setTokenURI(uint256 tokenId, string memory uri) internal override {
        _tokenURIs[tokenId] = uri;
    }

    function _setTokenIP(uint256 tokenId, uint256 _IP) internal {
        _tokenIP [tokenId] = _IP;
    }


    function getTokenIP(uint256 tokenId) external view returns (uint256, string memory) {
        return (_tokenIP[tokenId], _tokenURIs[tokenId]);
    }

    


    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        string memory uri = _tokenURIs[tokenId];
        return bytes(uri).length > 0 ? uri : super.tokenURI(tokenId);
    }


    function ownedNFT(address owner) external view returns (uint256[] memory ids, uint256[] memory tiers) {
        uint256 bal = balanceOf(owner);
        ids = new uint256[](bal);
        tiers = new uint256[](bal);
        for (uint256 i = 0; i < bal; i++) {
            uint256 id = tokenOfOwnerByIndex(owner, i);
            ids[i] = id;
            tiers[i] = _tokenIP[id];
        }
        return (ids, tiers);
    }



    function balanceOfERC520 (address _user) public view returns (uint256, uint256){
        // balance of ERC721 and ERC20
        return (balanceOf(_user), token.balanceOf(_user));
    }

    function getAllMetadata() external view returns (string[] memory) {
        return metadata;
    }

    function getERC520() external view returns (
        string memory, string memory, address, address, uint256, uint256, uint256){
        return (
            name(),
            symbol(),
            Creator, 
            accretiveTokenAddress,
            totalSupply(),
            lastID,
            MAX_GENESIS_SUPPLY
            );
    }

    function _increaseBalance(address account, uint128 value)
        internal
        virtual
        override(ERC721, ERC721Enumerable)
    {
        super._increaseBalance(account, value);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable, ERC721URIStorage) returns (bool) {
        return (
            interfaceId == 0x2a55205a ||
            ERC721.supportsInterface(interfaceId) ||
            ERC721Enumerable.supportsInterface(interfaceId) ||
            ERC721URIStorage.supportsInterface(interfaceId)
        );
    }

    function _update(
        address to,
        uint256 tokenId,
        address auth
    ) internal virtual override(ERC721, ERC721Enumerable) returns (address) {
        return super._update(to, tokenId, auth);
    }

    // EIP-2981 standard function
    function royaltyInfo(uint256 /*tokenId*/, uint256 salePrice)
        external
        view
        returns (address receiver, uint256 royaltyAmount)
    {
        return (royaltyReceiver, (salePrice * royaltyBps) / 10_000);
    }

    // Optional: let creator change it later (very useful)
    function setRoyaltyInfo(address newReceiver, uint96 newBps) external {
        require(msg.sender == Creator, "Only Creator");
        require(newBps <= 1000, "Max 10%"); //  // 1000 bps = 10%
        royaltyReceiver = newReceiver;
        royaltyBps = newBps;
    }

}