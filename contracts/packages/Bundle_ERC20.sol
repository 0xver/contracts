// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../erc/165/ERC165.sol";
import "./20/Package_ERC20.sol";
import "./173/Package_ERC173.sol";
import "../security/Guardian.sol";

/**
 * @dev Supports interface bundle
 */
contract Bundle is Package_ERC20, Package_ERC173, Guardian, ERC165 {
    constructor() Package_ERC20("My ERC20 Token", "TKN") Package_ERC173(msg.sender) {}

    function supportsInterface(bytes4 interfaceId) public pure override(ERC165) returns (bool) {
        return
            interfaceId == type(ERC165).interfaceId ||
            interfaceId == type(ERC173).interfaceId;
    }
}
