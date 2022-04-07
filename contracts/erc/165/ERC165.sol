// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @title ERC165 Interface
 *
 * @dev Interface of the ERC165 standard
 */
interface ERC165 {
    /**
     * @dev ERC165 standard functions
     */

    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}