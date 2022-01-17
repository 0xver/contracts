// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../IERC721.sol";

/**
 * @dev Interface for ERC721Enumerable as defined in the EIP-721
 */
interface IERC721Enumerable is IERC721 {
    /**
     * @dev ERC721 token enumeration functions
     */
    function totalSupply() external view returns (uint256);

    function tokenByIndex(uint256 index) external view returns (uint256);

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
}
