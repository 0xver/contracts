// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC721Metadata.sol";
import "../../../library/utils.sol";

/**
 * @dev Implementation of ERC721Metadata
 */
contract Package_ERC721Metadata is ERC721Metadata {
    mapping(uint256 => string) private _tokenCid;
    mapping(uint256 => bool) private _overrideCid;

    string private _metadata;
    string private _contractName;
    string private _contractSymbol;
    string private _fallbackCid;

    bool private _revealed;
    bool private _setURI;
    bool private _jsonExtension;

    constructor(string memory name_, string memory symbol_, string memory fallbackCid_) {
        _contractName = name_;
        _contractSymbol = symbol_;
        _fallbackCid = fallbackCid_;
        _revealed = false;
        _setURI = false;
    }

    function name() public view override returns (string memory) {
        return _contractName;
    }

    function symbol() public view override returns (string memory) {
        return _contractSymbol;
    }

    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        if (_overrideCid[_tokenId] == true) {
            return string(abi.encodePacked(_ipfs(), _tokenCid[_tokenId]));
        } else {
            if (_revealed == true) {
                if (_jsonExtension == true) {
                    return string(abi.encodePacked(_ipfs(), _metadata, "/", utils.toString(_tokenId), ".json"));
                } else {
                    return string(abi.encodePacked(_ipfs(), _metadata, "/", utils.toString(_tokenId)));
                }
            } else {
                return string(abi.encodePacked(_ipfs(), _fallbackCid));
            }
        }
    }

    function _ipfs() internal pure returns (string memory) {
        return "ipfs://";
    }

    function _overrideTokenURI(uint256 _tokenId, string memory _cid) internal {
        _tokenCid[_tokenId] = _cid;
        _overrideCid[_tokenId] = true;
    }

    function _setRevealURI(string memory _cid, bool _isExtension) internal {
        require(_revealed == false, "ERC721: reveal has already occured");
        _metadata = _cid;
        _jsonExtension = _isExtension;
        _setURI = true;
    }

    function _reveal() internal {
        require(_setURI == true, "ERC721: reveal URI not set");

        _revealed = true;
    }
}
