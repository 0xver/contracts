// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @title ERC1155TokenReceiver standard
 */
interface ERC1155Receiver {
    function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _value, bytes calldata _data) external returns(bytes4);

    function onERC1155BatchReceived(address _operator, address _from, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external returns(bytes4);
}