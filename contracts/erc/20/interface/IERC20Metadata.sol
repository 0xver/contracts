// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

/**
 * @title ERC20 metadata
 */
interface IERC20Metadata {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);
}
