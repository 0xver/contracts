// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../erc/165/ERC165.sol";
import "./173/Package_ERC173.sol";
import "./1155/Package_ERC1155Metadata.sol";
import "../security/Guardian.sol";

/**
 * @dev Supports interface bundle
 */
contract Bundle is Package_ERC1155Metadata, Package_ERC173, Guardian, ERC165 {
    constructor() Package_ERC1155Metadata("My ERC1155 Token", "TKN") Package_ERC173(msg.sender) {}

    function supportsInterface(bytes4 interfaceId) public pure override(ERC165) returns (bool) {
        return
            interfaceId == type(ERC165).interfaceId ||
            interfaceId == type(ERC173).interfaceId ||
            interfaceId == type(ERC1155).interfaceId ||
            interfaceId == type(ERC1155Metadata).interfaceId ||
            interfaceId == type(ERC1155Receiver).interfaceId;
    }
}
