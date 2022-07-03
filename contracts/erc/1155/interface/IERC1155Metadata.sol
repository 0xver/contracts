// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

/**
 * @title ERC1155Metadata standard
 */
interface IERC1155Metadata {
    function uri(uint256 _id) external view returns (string memory);
}
