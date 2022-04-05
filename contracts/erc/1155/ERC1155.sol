// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IERC1155.sol";
import "./extensions/IERC1155Metadata.sol";
import "./receiver/IERC1155Receiver.sol";

/**
 * @title ERC1155 Contract
 *
 * @dev Implementation of the ERC1155 standard
 */
contract ERC1155 is IERC1155, IERC1155Metadata {
    /**
     * @dev ERC1155 definitions
     */

    mapping(uint256 => mapping(address => uint256)) private _ownerBalance;
    mapping(address => mapping(address => bool)) private _operatorApproval;
    mapping(uint256 => string) private _tokenCid;

    mapping(uint256 => uint256) private _totalSupply;
    uint256 private _currentId = 0;

    string private _name;
    string private _symbol;

    /**
     * @dev Contract name and symbol
     */

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev Minting functions
     */

    function _initTokenId(string memory _cid) internal {
        _currentId += 1;
        _tokenCid[_currentId] = _cid;
    }

    function _mint(address _to, uint256 _id, uint256 _value) internal {
        require(_to != address(0), "ERC1155: cannot mint to the zero address");
        require(_id != 0, "ERC1155: not a valid token");
        require(_id <= _currentTokenId(), "ERC1155: not a valid token");

        _totalSupply[_id] += _value;
        _ownerBalance[_id][_to] += _value;

        emit TransferSingle(msg.sender, address(0), _to, _id, _value);
    }

    function _currentTokenId() internal view returns (uint256) {

        return _currentId;
    }

    function _baseUri() internal pure returns (string memory) {

        return "ipfs://";
    }

    function totalSupply(uint256 _id) public view returns (uint256) {

        return _totalSupply[_id];
    }

    /**
     * @dev ERC1155Metadata functions
     */

    function uri(uint256 _id) public view override returns (string memory) {
        string memory tokenCid = _tokenCid[_id];

        return string(abi.encodePacked(_baseUri(), tokenCid));
    }

    /**
     * @dev ERC1155 functions
     */

    function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes memory _data) public override {
        require(_from == msg.sender || isApprovedForAll(_from, msg.sender), "ERC1155: unauthorized transfer");
        require(_ownerBalance[_id][_from] >= _value, "ERC1155: value exceeds balance");
        require(_to != address(0), "ERC1155: cannot transfer to the zero address");

        _ownerBalance[_id][_from] -= _value;
        _ownerBalance[_id][_to] += _value;

        emit TransferSingle(msg.sender, _from, _to, _id, _value);

        _safeTransferCheck(msg.sender, _from, _to, _id, _value, _data);
    }

    function safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _values, bytes memory _data) public override {
        require(_from == msg.sender || isApprovedForAll(_from, msg.sender), "ERC1155: unauthorized transfer");
        require(_ids.length == _values.length, "ERC1155: ids and amounts length mismatch");
        require(_to != address(0), "ERC1155: cannot transfer to the zero address");

        for (uint256 i = 0; i < _ids.length; ++i) {
            uint256 id = _ids[i];
            uint256 value = _values[i];
            require(_ownerBalance[id][_from] >= value, "ERC1155: insufficient balance for transfer");

            _ownerBalance[id][_from] -= value;
            _ownerBalance[id][_to] += value;
        }

        emit TransferBatch(msg.sender, _from, _to, _ids, _values);

        _safeBatchTransferCheck(msg.sender, _from, _to, _ids, _values, _data);
    }
    
    function balanceOf(address _owner, uint256 _id) public view override returns (uint256) {
        require(_owner != address(0), "ERC1155: cannot get balance for the zero address");

        return _ownerBalance[_id][_owner];
    }

    function balanceOfBatch(address[] memory _owners, uint256[] memory _ids) public view override returns (uint256[] memory) {
        require(_owners.length == _ids.length, "ERC1155: accounts and ids length mismatch");

        uint256[] memory batchBalances = new uint256[](_owners.length);

        for (uint256 i = 0; i < _owners.length; ++i) {
            batchBalances[i] = balanceOf(_owners[i], _ids[i]);
        }

        return batchBalances;
    }

    function setApprovalForAll(address _operator, bool _approved) public override {
        require(msg.sender != _operator, "ERC1155: cannot set approval for self");

        _operatorApproval[msg.sender][_operator] = _approved;

        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    function isApprovedForAll(address _owner, address _operator) public view override returns (bool) {

        return _operatorApproval[_owner][_operator];
    }

    /**
     * @dev ERC1155Receiver functions
     */
    
    function _safeTransferCheck(address _operator, address _from, address _to, uint256 _id, uint256 _value, bytes memory _data) private {
        uint256 size;
        assembly {
            size := extcodesize(_to)
        }
        if (size > 0) {
            try IERC1155Receiver(_to).onERC1155Received(_operator, _from, _id, _value, _data) returns (bytes4 response) {
                if (response != IERC1155Receiver.onERC1155Received.selector) {
                    revert("ERC1155: ERC1155Receiver rejected tokens");
                }
            } catch Error(string memory reason) {
                revert(reason);
            } catch {
                revert("ERC1155: transfer to non ERC1155Receiver implementer");
            }
        }
    }

    function _safeBatchTransferCheck(address _operator, address _from, address _to, uint256[] memory _ids, uint256[] memory _values, bytes memory _data) private {
        uint256 size;
        assembly {
            size := extcodesize(_to)
        }
        if (size > 0) {
            try IERC1155Receiver(_to).onERC1155BatchReceived(_operator, _from, _ids, _values, _data) returns (bytes4 response) {
                if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
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
