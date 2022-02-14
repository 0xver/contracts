// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../IERC1155.sol";

/**
 * @dev Interface for ERC1155Metadata as defined in the EIP
 */
interface IERC1155Metadata is IERC1155 {
    /**
     * @dev ERC1155 token metadata functions
     */
    function uri(uint256 _id) external view returns (string memory);
}
