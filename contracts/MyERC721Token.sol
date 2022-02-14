// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev Imports contracts from the library
 */

import "./access/Ownable.sol";
import "./erc/721/royalty/ERC721Royalty.sol";
import "./security/ReentrancyGuard.sol";

/**
 * @title My ERC721 Token
 *
 * @dev Extends ERC721 non-fungible token standard
 */
contract MyERC721Token is ERC721Royalty, Ownable, ReentrancyGuard {
    /**
     * @dev Events
     */

    event Mint(address receiver, uint256 tokenId, string cid);
    event Withdrawal(address operator, address receiver, uint256 value);

    /**
     * @dev MyNonFungibleToken definitions
     */

    mapping(address => uint256) private _whitelist;

    /**
     * @dev Sets ERC721 constructor values
     */

    constructor() ERC721("My ERC721 Token", "TKN") Ownable(msg.sender) {
    }

    /**
     * @dev Internal mint routing
     */

    function _routeMint(address _to, string memory _cid, uint256 _percent) internal {
        _mint(_to, _cid);
        _setTokenRoyalty(_currentTokenId(), _to, _percent);

        emit Mint(_to, _currentTokenId(), _cid);
    }

    /**
     * @dev Checks if account is whitelisted
     */

    modifier whitelist(address _account) {
        require(_whitelist[_account] != 0, "MyERC721Token: account not in whitelist");

        _;
    }

    /**
     * @dev Adds account to whitelist
     */

    function addToWhitelist(address _account) public onlyOwner {
        require(_whitelist[_account] != 1, "MyERC721Token: account already in whitelist");

        _whitelist[_account] = 1;
    }

    /**
     * @dev Whitelist mint function
     */

    function whitelistMint(address _account, string memory cid) public whitelist(_account) {
        require(_whitelist[_account] != 0, "MyERC721Token: whitelist account already minted");

        _whitelist[_account] = 0;
        _routeMint(_account, cid, 0);
    }

    /**
     * @dev Whitelist mint with royalty function
     */

    function whitelistMintWithRoyalty(address _account, string memory cid, uint256 percent) public whitelist(_account) {
        require(_whitelist[_account] != 0, "MyERC721Token: whitelist account already minted");

        _whitelist[_account] = 0;
        _routeMint(_account, cid, percent);
    }

    /**
     * @dev Public mint function
     */
    function publicMint(address _account, string memory cid) public gate() {
        _routeMint(_account, cid, 0);
    }

    /**
     * @dev Public mint with royalty function
     */
    function publicMintWithRoyalty(address _account, string memory cid, uint256 percent) public gate() {
        _routeMint(_account, cid, percent);
    }

    /**
     * @dev Withdraw ether from contract
     */

    function withdraw(address _account) public onlyOwner {
        (bool success, ) = payable(_account).call{value: address(this).balance}("");
        require(success, "MyERC721Token: ether transfer failed");

        emit Withdrawal(msg.sender, _account, address(this).balance);
    }
}
