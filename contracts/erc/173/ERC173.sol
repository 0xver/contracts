// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev ERC173 standard
 */
interface ERC173 {
    /**
     * @dev Events
     */

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Functions
     */

    function owner() view external returns (address);

    function transferOwnership(address _newOwner) external;
}