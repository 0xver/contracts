// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC1155Supports.sol";

/**
 * @title ERC1155 Test
 */
contract ERC1155Test is ERC1155Supports {
    /**
     * @dev Creates new token ID
     */
    function initTokenId(string memory _cid) public ownership {
        _initTokenId();
        _setTokenCID(_currentTokenId(), _cid);
    }

    /**
     * @dev Mints the current token ID
     */
    function mint(address _to, uint256 _quantity) public {
        _mint(_to, _currentTokenId(), _quantity);
    }
}
