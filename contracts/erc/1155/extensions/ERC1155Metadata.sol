// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @title ERC1155Metadata standard
 */
interface ERC1155Metadata {
    /**
     * @dev Functions
     */
    function uri(uint256 _id) external view returns (string memory);
}