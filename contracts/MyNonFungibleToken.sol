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
     * @dev Sets ERC721 constructor values
     */
    constructor() ERC721("My Non-Fungible Token", "MNFT") {
    }

    /**
     * @dev Example mint function that emits {Mint} event
     */
    function mint(address receiver, string memory cid) public gate() {
        _safeMint(receiver, _tokenIdCounter.current());
        uint256 tokenId = _tokenIdCounter.current();
        _setTokenCID(tokenId, cid);
        _tokenIdCounter.increment();

        _setTokenRoyalty(tokenId, receiver, 0);

        emit Mint(receiver, tokenId, cid);
    }

    /**
     * @dev Example mint with royalty function that emits {Mint} event
     */
    function mintWithRoyalty(address receiver, string memory cid, uint256 percent) public gate() {
        _safeMint(receiver, _tokenIdCounter.current());
        uint256 tokenId = _tokenIdCounter.current();
        _setTokenCID(tokenId, cid);
        _tokenIdCounter.increment();

        _setTokenRoyalty(tokenId, receiver, percent);

        emit Mint(receiver, tokenId, cid);
    }

    /**
     * @dev Example withdraw ether function that emits {Withdrawal} event
     */
    function withdraw(address receiver) public onlyOwner {
        (bool success, ) = payable(receiver).call{value: address(this).balance}("");
        require(success, "MyNonFungibleToken: ether transfer failed");

        emit Withdrawal(msg.sender, receiver, address(this).balance);
    }
}
