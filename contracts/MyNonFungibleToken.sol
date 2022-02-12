// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev Imports contracts from the library
 */

import "./access/Ownable.sol";
import "./erc/2981/ERC2981.sol";
import "./security/ReentrancyGuard.sol";

/**
 * @title My Non-Fungible Token
 *
 * @dev Extends ERC721 non-fungible token standard
 */
contract MyNonFungibleToken is ERC2981, Ownable, ReentrancyGuard {
    /**
     * @dev Events
     */

    event Mint(address receiver, uint256 tokenId, string cid);
    event Withdrawal(address caller, address receiver, uint256 amount);

    /**
     * @dev MyNonFungibleToken definitions
     */

    mapping(address => uint256) private _whitelist;

    /**
     * @dev Sets ERC721 constructor values
     */

    constructor() ERC721("My Non-Fungible Token", "MNFT") Ownable(msg.sender) {
    }

    /**
     * @dev Internal mint routing
     */

    function _routeMint(address _to, string memory _cid, uint256 _percent) internal {
        _mint(_to, _cid);
        _setTokenRoyalty(currentTokenId(), _to, _percent);

        emit Mint(_to, currentTokenId(), _cid);
    }

    /**
     * @dev Checks if account is whitelisted
     */

    modifier whitelist(address account) {
        require(_whitelist[account] != 0, "MyNonFungibleToken: account not in whitelist");

        _;
    }

    /**
     * @dev Adds account to whitelist
     */

    function addToWhitelist(address account) public onlyOwner {
        require(_whitelist[account] != 1, "MyNonFungibleToken: account already in whitelist");

        _whitelist[account] = 1;
    }

    /**
     * @dev Whitelist mint function
     */

    function whitelistMint(address account, string memory cid) public whitelist(account) {
        require(_whitelist[account] != 0, "MyNonFungibleToken: whitelist account already minted");

        _whitelist[account] = 0;
        _routeMint(account, cid, 0);
    }

    /**
     * @dev Whitelist mint with royalty function
     */

    function whitelistMintWithRoyalty(address account, string memory cid, uint256 percent) public whitelist(account) {
        require(_whitelist[account] != 0, "MyNonFungibleToken: whitelist account already minted");

        _whitelist[account] = 0;
        _routeMint(account, cid, percent);
    }

    /**
     * @dev Public mint function
     */
    function publicMint(address account, string memory cid) public gate() {
        _routeMint(account, cid, 0);
    }

    /**
     * @dev Public mint with royalty function
     */
    function publicMintWithRoyalty(address account, string memory cid, uint256 percent) public gate() {
        _routeMint(account, cid, percent);
    }

    /**
     * @dev Withdraw ether from contract
     */

    function withdraw(address account) public onlyOwner {
        (bool success, ) = payable(account).call{value: address(this).balance}("");
        require(success, "MyNonFungibleToken: ether transfer failed");

        emit Withdrawal(msg.sender, account, address(this).balance);
    }
}
