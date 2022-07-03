// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "./ERC1155.sol";
import "./interface/IERC1155Metadata.sol";
import "../../library/utils.sol";

/**
 * @dev Implementation of ERC721Metadata
 */
contract ERC1155Metadata is ERC1155, IERC1155Metadata {
    mapping(uint256 => string) private _tokenCid;

    string private _name;
    string private _symbol;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev Name of contract
     */
    function name() public view returns (string memory) {
        return _name;
    }

    /**
     * @dev Symbol of contract
     */
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns URI of token ID
     */
    function uri(uint256 _id) public view override returns (string memory) {
        return string(abi.encodePacked(_ipfs(), _tokenCid[_id]));
    }

    /**
     * @dev _ipfs used in place of _baseURI
     */
    function _ipfs() internal pure returns (string memory) {
        return "ipfs://";
    }

    /**
     * @dev Sets the token CID
     */
    function _setTokenCID(uint256 _id, string memory _cid) internal {
        _tokenCid[_id] = _cid;
    }
}
