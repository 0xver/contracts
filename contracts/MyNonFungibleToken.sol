// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev Imports contracts from the library
 */

//import "./access/AccessControl.sol";
import "./access/Ownable.sol";
import "./erc/721/ERC721.sol";
import "./security/ReentrancyGuard.sol";
import "./utils/Counters.sol";

/**
 * @title My Non-Fungible Token
 *
 * @dev Extends ERC721 non-fungible token standard
 */
contract MyNonFungibleToken is ERC721, Ownable, ReentrancyGuard {
    receive() external payable {}
    fallback() external payable {}

    // Token ID counter
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    /**
     * @dev Example events
     */

    // Mint event
    event Mint(address receiver, uint256 tokenId, string cid);

    // Withdrawal event
    event Withdrawal(address caller, address receiver, uint256 amount);

    /**
     * @dev MyNonFungibleToken definitions
     */

    // Maps account to whitelist status
    mapping(address => uint256) private _whitelist;

    // Maps account to whitelist mint status
    mapping(address => uint256) private _whitelistMint;

    /**
     * @dev Sets ERC721 constructor values
     */
    constructor() ERC721("My Non-Fungible Token", "MNFT") {
    }

    /**
     * @dev Example withdraw ether function that emits {Withdrawal} event
     */
    function withdraw(address account) public onlyOwner {
        (bool success, ) = payable(account).call{value: address(this).balance}("");
        require(success, "MyNonFungibleToken: ether transfer failed");

        emit Withdrawal(msg.sender, account, address(this).balance);
    }

    /**
     * @dev Example internal event emitting mint function
     */
    function _minter(address account, string memory cid, uint256 percent) internal gate() {
        uint256 tokenId = _tokenIdCounter.current();
        _safeMint(account, tokenId);
        _setTokenCID(tokenId, cid);
        _tokenIdCounter.increment();
        if (percent != 0) {
            _setTokenRoyalty(tokenId, account, percent);
        } else {
            _setTokenRoyalty(tokenId, account, 0);
        }

        emit Mint(account, tokenId, cid);
    }

    /**
     * @dev Example check for whitelist modifier
     */
    modifier whitelist(address account) {
        require(_whitelist[msg.sender] != 0, "MyNonFungibleToken: account not in whitelist");
        _;
    }

    /**
     * @dev Example add account to whitelist function
     */
    function addToWhitelist(address account) public onlyOwner {
        require(_whitelist[account] != 1, "MyNonFungibleToken: account already in whitelist");
        _whitelist[account] = 1;
        _whitelistMint[account] = 1;
    }

    /**
     * @dev Example whitelist mint function
     */
    function whitelistMint(address account, string memory cid) public whitelist(account) {
        require(_whitelistMint[account] != 0, "MyNonFungibleToken: whitelist account already minted");
        _whitelistMint[account] = 0;
        _minter(account, cid, 0);
    }

    /**
     * @dev Example whitelist mint with royalty function
     */
    function whitelistMintWithRoyalty(address account, string memory cid, uint256 percent) public whitelist(account) {
        _minter(account, cid, percent);
    }

    /**
     * @dev Example public mint function
     */
    function publicMint(address account, string memory cid) public {
        _minter(account, cid, 0);
    }

    /**
     * @dev Example public mint with royalty function
     */
    function publicMintWithRoyalty(address account, string memory cid, uint256 percent) public {
        _minter(account, cid, percent);
    }
}
