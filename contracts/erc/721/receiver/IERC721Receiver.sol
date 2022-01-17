// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev Interface for ERC721TokenReceiver as defined in EIP-721
 */
interface IERC721Receiver {
    /**
     * @dev ERC721TokenReceiver standard functions
     */
    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
}
