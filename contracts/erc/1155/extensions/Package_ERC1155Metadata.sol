// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../Package_ERC1155.sol";
import "./ERC1155Metadata.sol";
import "../../../library/utils.sol";

/**
 * @dev Implementation of ERC721Metadata
 */
contract Package_ERC1155Metadata is Package_ERC1155, ERC1155Metadata {
    mapping(uint256 => string) private _tokenCid;

    string private _contractName;
    string private _contractSymbol;

    constructor(string memory name_, string memory symbol_) {
        _contractName = name_;
        _contractSymbol = symbol_;
    }

    function name() public view returns (string memory) {
        return _contractName;
    }

    function symbol() public view returns (string memory) {
        return _contractSymbol;
    }

    function uri(uint256 _id) public view override returns (string memory) {
        return string(abi.encodePacked(_ipfs(), _tokenCid[_id]));
    }

    function _ipfs() internal pure returns (string memory) {
        return "ipfs://";
    }

    function _setTokenURI(uint256 _id, string memory _cid) internal {
        _tokenCid[_id] = _cid;
    }
}
