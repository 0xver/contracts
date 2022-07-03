// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "./interface/IERC721.sol";
import "./interface/receiver/IERC721Receiver.sol";
import "../../library/utils.sol";

/**
 * @dev Implementation of ERC721
 */
contract ERC721 is IERC721 {
    mapping(uint256 => address) private _tokenOwner;
    mapping(address => uint256) private _ownerBalance;
    mapping(uint256 => address) private _tokenApproval;
    mapping(address => mapping(address => bool)) private _operatorApproval;

    uint256 private _burnCount = 0;
    uint256 private _currentId = 0;
    uint256 private _totalSupply = 0;

    bool private _supplyActive;

    bytes32 private root;

    function _setMerkleRoot(bytes32 _root) internal {
        root = _root;
    }
    
    function merkleRoot() internal view returns (bytes32) {
        return root;
    }

    modifier merkleProof(address _to, bytes32[] calldata _merkleProof) {
        bytes32 leaf = keccak256(abi.encodePacked(_to));
        require(utils.verify(_merkleProof, merkleRoot(), leaf), "ERC721: invalid merkle proof.");
        _;
    }

    modifier totalBalance(address _to, uint256 _quantity) {
        require(_to != address(0), "ERC721: cannot mint to the zero address");
        _ownerBalance[_to] += _quantity;
        _;
    }

    function _loop(address _to) internal {
        _currentId += 1;
        _tokenOwner[_currentId] = _to;
        emit Transfer(address(0), _to, _currentId);
    }

    function _mint(address _to, uint256 _quantity) internal totalBalance(_to, _quantity) {
        for (uint256 i=0; i < _quantity; i++) {
            _loop(msg.sender);
        }
    }

    function _burn(address _from, uint256 _tokenId) internal {
        require(ownerOf(_tokenId) == _from, "ERC721: from address is not owner of token");
        require(_tokenOwner[_tokenId] == msg.sender || _tokenApproval[_tokenId] == msg.sender || _operatorApproval[_from][msg.sender] == true, "ERC721: unauthorized transfer");
        _burnCount += 1;
        _ownerBalance[_from] -= 1;
        _tokenOwner[_tokenId] = address(0);
        _tokenApproval[_tokenId] = address(0);
        emit Transfer(_from, address(0), _tokenId);
    }

    function _currentTokenId() internal view returns (uint256) {
        return _currentId;
    }

    function totalSupply() public view returns (uint256) {
        return (_currentId - _burnCount);
    }

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

    function _onERC721Received(address _from, address _to, uint256 _tokenId, bytes memory _data) private {
        uint256 size;
        assembly {size := extcodesize(_to)}
        if (size > 0) {
            try IERC721Receiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data) returns (bytes4 response) {
                if (response != IERC721Receiver.onERC721Received.selector) {
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
