// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IERC721.sol";
import "./extensions/IERC721Metadata.sol";
import "./receiver/IERC721Receiver.sol";

/**
 * @title ERC721 Contract
 *
 * @dev Implementation of the ERC721 standard
 */
contract ERC721 is IERC721, IERC721Metadata {
    /**
     * @dev ERC721 definitions
     */

    mapping(uint256 => address) private _tokenOwner;
    mapping(address => uint256) private _ownerBalance;
    mapping(uint256 => address) private _tokenApproval;
    mapping(uint256 => string) private _tokenCid;
    mapping(address => mapping(address => bool)) private _operatorApproval;

    uint256 private _currentId = 0;
    uint256 private _totalSupply = 0;

    string private _name;
    string private _symbol;

    /**
     * @dev Minting related functions
     */

    function _mint(address _to, string memory _cid) internal virtual {
        _mintSingleToken(_to, _cid);
    }

    function _mintSingleToken(address _to, string memory _cid) internal virtual {
        require(_to != address(0), "ERC721: cannot mint to the zero address");

        _currentId += 1;
        _totalSupply += 1;
        _tokenOwner[_currentId] = _to;
        _tokenCid[_currentId] = _cid;
        _ownerBalance[_to] += 1;

        emit Transfer(address(0), _to, _currentId);
    }

    function currentTokenId() internal virtual returns (uint256) {

        return _currentId;
    }

    function totalSupply() public virtual returns (uint256) {

        return _totalSupply;
    }

    /**
     * @dev ERC721Metadata functions
     */
    
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function name() public view virtual override returns (string memory) {

        return "EscapePlan";
    }

    function symbol() public view virtual override returns (string memory) {

        return "ESC";
    }

    function baseURI() internal view virtual returns (string memory) {

        return "ipfs://";
    }

    function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
        string memory tokenCID = _tokenCid[_tokenId];

        return string(abi.encodePacked(baseURI(), tokenCID));
    }

    /**
     * @dev ERC165 function
     */

    function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165) returns (bool) {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            interfaceId == type(IERC721Receiver).interfaceId;
    }

    /**
     * @dev ERC721 functions
     */
    
    function balanceOf(address _owner) public view virtual override returns (uint256) {

        return _ownerBalance[_owner];
    }

    function ownerOf(uint256 _tokenId) public view virtual override returns (address) {

        return _tokenOwner[_tokenId];
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId) public virtual override {
        safeTransferFrom(_from, _to, _tokenId, "");
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory _data)  public virtual override {
        _transfer(_from, _to, _tokenId);
    
        _onERC721Received(_from, _to, _tokenId, _data);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public virtual override {
        _transfer(_from, _to, _tokenId);
    }

    function approve(address _approved, uint256 _tokenId) public virtual override {
        require(_tokenOwner[_tokenId] == msg.sender);

        _tokenApproval[_tokenId] = _approved;

        emit Approval(msg.sender, _approved, _tokenId);
    }

    function setApprovalForAll(address _operator, bool _approved) public virtual override {
        require(msg.sender != _operator, "ERC721: approve to caller");
        _operatorApproval[msg.sender][_operator] = _approved;
    
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    function getApproved(uint256 _tokenId) public view override returns (address) {

        return _tokenApproval[_tokenId];
    }

    function isApprovedForAll(address _owner, address _operator) public view virtual override returns (bool) {

        return _operatorApproval[_owner][_operator];
    }

    /**
     * @dev ERC721 internal transfer function
     */

    function _transfer(address _from, address _to, uint256 _tokenId) internal virtual {
        require(ERC721.ownerOf(_tokenId) == _from, "ERC721: from address is not owner of token");
        require(_tokenOwner[_tokenId] == msg.sender || _tokenApproval[_tokenId] == msg.sender || _operatorApproval[_from][msg.sender] == true, "ERC721: unauthorized transfer");
        require(_to != address(0), "ERC721: cannot transfer to the zero address");

        _ownerBalance[_from] -= 1;
        _tokenOwner[_tokenId] = _to;
        _tokenApproval[_tokenId] = address(0);
        _ownerBalance[_to] += 1;

        emit Transfer(_from, _to, _tokenId);
    }

    function _burn(address _from, address _to, uint256 _tokenId) internal virtual {
        require(ERC721.ownerOf(_tokenId) == _from, "ERC721: from address is not owner of token");
        require(_tokenOwner[_tokenId] == msg.sender || _tokenApproval[_tokenId] == msg.sender || _operatorApproval[_from][msg.sender] == true, "ERC721: unauthorized transfer");

        _ownerBalance[_from] -= 1;
        _tokenOwner[_tokenId] = _to;
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
            try IERC721Receiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data) returns (bytes4 response) {
                if (response != IERC721Receiver.onERC721Received.selector) {
                    revert("ERC1155: ERC1155Receiver rejected tokens");
                }
            } catch Error(string memory reason) {
                revert(reason);
            } catch {
                revert("ERC1155: transfer to non ERC1155Receiver implementer");
            }
        }
    }
}
