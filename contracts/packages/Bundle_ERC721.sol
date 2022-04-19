// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../erc/165/ERC165.sol";
import "./173/Package_ERC173.sol";
import "./721/Package_ERC721Metadata.sol";
import "./2981/Package_ERC2981.sol";
import "../security/Guardian.sol";

/**
 * @dev Supports interface bundle
 */
contract Bundle is Package_ERC721Metadata, Package_ERC2981, Package_ERC173, Guardian, ERC165 {
    constructor() Package_ERC721Metadata("My ERC721 Token", "TKN", "pr34v31/prereveal.json") Package_ERC173(msg.sender) {}

    function supportsInterface(bytes4 interfaceId) public pure override(ERC165) returns (bool) {
        return
            interfaceId == type(ERC165).interfaceId ||
            interfaceId == type(ERC173).interfaceId ||
            interfaceId == type(ERC721).interfaceId ||
            interfaceId == type(ERC721Metadata).interfaceId ||
            interfaceId == type(ERC721Receiver).interfaceId ||
            interfaceId == type(ERC2981).interfaceId;
    }
}
