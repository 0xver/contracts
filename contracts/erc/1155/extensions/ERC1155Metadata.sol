// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @title ERC1155Metadata Interface
 *
 * @dev Interface for ERC1155Metadata
 */
interface ERC1155Metadata {
    /**
     * @dev ERC1155 token metadata functions
     */
    function uri(uint256 _id) external view returns (string memory);
}