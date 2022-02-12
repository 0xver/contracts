// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IERC165.sol";

/**
 * @dev Implementation of the IERC165 interface
 */
abstract contract ERC165 is IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by `interfaceId`
     */

    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}
