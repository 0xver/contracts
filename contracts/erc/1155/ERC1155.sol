// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "./interface/IERC1155.sol";
import "./interface/IERC1155Metadata.sol";
import "./interface/receiver/IERC1155Receiver.sol";

/**
 * @dev Implementation of ERC1155
 */
contract ERC1155 is IERC1155 {
    // Mapping token ID to address and balance
    mapping(uint256 => mapping(address => uint256)) private _ownerBalance;

    // Mapping address to approved spender address for all tokens
    mapping(address => mapping(address => bool)) private _operatorApproval;

    // Mapping token ID to total supply of tokens
    mapping(uint256 => uint256) private _totalSupply;

    // Current token ID variable
    uint256 private _currentId = 0;

    /**
     * @dev Initialize new token ID
     */
    function _initTokenId() internal {
        _currentId += 1;
    }

    /**
     * @dev Mint quantity of tokens for initialized token ID
     */
    function _mint(address _to, uint256 _id, uint256 _value) internal {
        require(_to != address(0), "ERC1155: cannot mint to the zero address");
        require(_id != 0, "ERC1155: not a valid token");
        require(_id <= _currentTokenId(), "ERC1155: not a valid token");
        _totalSupply[_id] += _value;
        _ownerBalance[_id][_to] += _value;
        emit TransferSingle(msg.sender, address(0), _to, _id, _value);
    }

    /**
     * @dev Returns current token ID
     */
    function _currentTokenId() internal view returns (uint256) {
        return _currentId;
    }

    /**
     * @dev Returns total supply
     */
    function totalSupply(uint256 _id) public view returns (uint256) {
        return _totalSupply[_id];
    }

    /**
     * @dev Safe transfer from spender address and emit event
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

    /**
     * @dev Safe batch transfer from spender address and emit event
     */
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

    /**
     * @dev Returns owner balance
     */
    function balanceOf(address _owner, uint256 _id) public view override returns (uint256) {
        require(_owner != address(0), "ERC1155: cannot get balance for the zero address");
        return _ownerBalance[_id][_owner];
    }

    /**
     * @dev Returns batch of owner balances
     */
    function balanceOfBatch(address[] memory _owners, uint256[] memory _ids) public view override returns (uint256[] memory) {
        require(_owners.length == _ids.length, "ERC1155: accounts and ids length mismatch");
        uint256[] memory batchBalances = new uint256[](_owners.length);
        for (uint256 i = 0; i < _owners.length; ++i) {
            batchBalances[i] = balanceOf(_owners[i], _ids[i]);
        }
        return batchBalances;
    }

    /**
     * @dev Allows all tokens to be transferred by approved address
     */
    function setApprovalForAll(address _operator, bool _approved) public override {
        require(msg.sender != _operator, "ERC1155: cannot set approval for self");
        _operatorApproval[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    /**
     * @dev Returns `true` if operator is approved to spend owner tokens
     */
    function isApprovedForAll(address _owner, address _operator) public view override returns (bool) {
        return _operatorApproval[_owner][_operator];
    }

    /**
     * @dev Handles the receipt of single token transfers
     */
    function _safeTransferCheck(address _operator, address _from, address _to, uint256 _id, uint256 _value, bytes memory _data) private {
        uint256 size;
        assembly {size := extcodesize(_to)}
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

    /**
     * @dev Handles the receipt of batch token transfers
     */
    function _safeBatchTransferCheck(address _operator, address _from, address _to, uint256[] memory _ids, uint256[] memory _values, bytes memory _data) private {
        uint256 size;
        assembly {size := extcodesize(_to)}
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
