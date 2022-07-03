// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "./interface/IERC165.sol";

/**
 * @dev Implementation of ERC165
 */
contract ERC165 is IERC165 {
    /**
     * @dev Supports interface
     */
    function supportsInterface(bytes4 interfaceId) public pure override(IERC165) returns (bool) {
        return
            interfaceId == type(IERC165).interfaceId;
    }
}
