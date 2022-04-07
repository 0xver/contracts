// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC165.sol";

/**
 * @title ERC165 Contract
 *
 * @dev Implementation of the ERC165 standard
 */
contract Package_ERC165 is ERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by `interfaceId`
     */

    function supportsInterface(bytes4 interfaceId) public pure override returns (bool) {
        return interfaceId == type(ERC165).interfaceId;
    }
}