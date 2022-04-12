// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../165/ERC165.sol";
import "./ERC721.sol";
import "./extensions/ERC721Metadata.sol";
import "./receiver/ERC721Receiver.sol";
import "../../library/utils.sol";

/**
 * @title ERC721 Contract
 *
 * @dev Implementation of the ERC721 standard
 */
contract Package_ERC721 is ERC721, ERC721Metadata {
    /**
     * @dev ERC721 definitions
     */

    mapping(uint256 => address) private _tokenOwner;
    mapping(address => uint256) private _ownerBalance;
    mapping(uint256 => address) private _tokenApproval;
    mapping(address => mapping(address => bool)) private _operatorApproval;

    string private _extendedBaseUri;

    uint256 private _currentId = 0;
    uint256 private _totalSupply = 0;

    string private _name;
    string private _symbol;

    /**
     * @dev ERC721Metadata functions
     */
    
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function name() public view override returns (string memory) {

        return _name;
    }

    function symbol() public view override returns (string memory) {

        return _symbol;
    }

    function tokenURI(uint256 _tokenId) public view override returns (string memory) {

        return string(abi.encodePacked(_ipfs(), _extendedBaseUri, "/", utils.toString(_tokenId)));
    }

    /**
     * @dev Minting functions
     */

    function _merkleProofMint(address _to, bytes32[] calldata _merkleProof, bytes32 _merkleRoot) internal {
        bytes32 leaf = keccak256(abi.encodePacked(_to));
        require(utils.verify(_merkleProof, _merkleRoot, leaf), "ERC721: invalid merkle proof.");
        
        _mint(_to);
    }

    function _mint(address _to) internal {
        require(_to != address(0), "ERC721: cannot mint to the zero address");

        _currentId += 1;
        _totalSupply += 1;
        _tokenOwner[_currentId] = _to;
        _ownerBalance[_to] += 1;

        emit Transfer(address(0), _to, _currentId);
    }

    function _currentTokenId() internal view returns (uint256) {

        return _currentId;
    }

    function _ipfs() internal pure returns (string memory) {

        return "ipfs://";
    }

    function _setExtendedBaseUri(string memory _extension) internal {
        _extendedBaseUri = _extension;
    }

    function totalSupply() public view returns (uint256) {

        return _totalSupply;
    }

    /**
     * @dev ERC721 functions
     */
    
    function balanceOf(address _owner) public view override returns (uint256) {

        return _ownerBalance[_owner];
    }

    function ownerOf(uint256 _tokenId) public view override returns (address) {

        return _tokenOwner[_tokenId];
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId) public override {
        safeTransferFrom(_from, _to, _tokenId, "");
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory _data) public override {
        _transfer(_from, _to, _tokenId);
    
        _onERC721Received(_from, _to, _tokenId, _data);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public override {
        _transfer(_from, _to, _tokenId);
    }

    function approve(address _approved, uint256 _tokenId) public override {
        require(_tokenOwner[_tokenId] == msg.sender);

        _tokenApproval[_tokenId] = _approved;

        emit Approval(msg.sender, _approved, _tokenId);
    }

    function setApprovalForAll(address _operator, bool _approved) public override {
        require(msg.sender != _operator, "ERC721: cannot approve the owner");
        _operatorApproval[msg.sender][_operator] = _approved;
    
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    function getApproved(uint256 _tokenId) public view override returns (address) {

        return _tokenApproval[_tokenId];
    }

    function isApprovedForAll(address _owner, address _operator) public view override returns (bool) {

        return _operatorApproval[_owner][_operator];
    }

    /**
     * @dev ERC721 internal transfer function
     */

    function _transfer(address _from, address _to, uint256 _tokenId) internal {
        require(ownerOf(_tokenId) == _from, "ERC721: from address is not owner of token");
        require(_tokenOwner[_tokenId] == msg.sender || _tokenApproval[_tokenId] == msg.sender || _operatorApproval[_from][msg.sender] == true, "ERC721: unauthorized transfer");
        require(_to != address(0), "ERC721: cannot transfer to the zero address");

        _ownerBalance[_from] -= 1;
        _tokenOwner[_tokenId] = _to;
        _tokenApproval[_tokenId] = address(0);
        _ownerBalance[_to] += 1;

        emit Transfer(_from, _to, _tokenId);
    }

    function _burn(address _from, uint256 _tokenId) internal {
        require(ownerOf(_tokenId) == _from, "ERC721: from address is not owner of token");
        require(_tokenOwner[_tokenId] == msg.sender || _tokenApproval[_tokenId] == msg.sender || _operatorApproval[_from][msg.sender] == true, "ERC721: unauthorized transfer");

        _ownerBalance[_from] -= 1;
        _tokenOwner[_tokenId] = address(0);
        _tokenApproval[_tokenId] = address(0);
        _totalSupply -= 1;

        emit Transfer(_from, address(0), _tokenId);
    }

    /**
     * @dev ERC721Received private function
     */

    function _onERC721Received(address _from, address _to, uint256 _tokenId, bytes memory _data) private {
        uint256 size;
        assembly {
            size := extcodesize(_to)
        }
        if (size > 0) {
            try ERC721Receiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data) returns (bytes4 response) {
                if (response != ERC721Receiver.onERC721Received.selector) {
                    revert("ERC721: ERC721Receiver rejected tokens");
                }
            } catch Error(string memory reason) {
                revert(reason);
            } catch {
                revert("ERC721: transfer to non ERC721Receiver implementer");
            }
        }
    }
}