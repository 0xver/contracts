// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./packages/Bundle_ERC1155.sol";

/**
 * @title My ERC1155 Token
 */
contract MyERC1155Token is Bundle {
    receive() external payable {}
    fallback() external payable {}

    event Withdraw(address operator, address receiver, uint256 value);

    mapping(address => uint256) private _whitelist;

    constructor() {}

    /**
     * @dev Creates new token ID
     */

    function initTokenId(string memory _cid) public ownership {
        _initTokenId();
        _setTokenURI(_currentTokenId(), _cid);
    }

    /**
     * @dev Mints the current token ID
     */

    function mint(address _to, uint256 _quantity) public {
        _mint(_to, _currentTokenId(), _quantity);
    }

    /**
     * @dev Withdraw ether from contract
     */

    function withdraw(address account) public ownership {
        uint256 balance = address(this).balance;
        (bool success, ) = payable(account).call{value: address(this).balance}("");
        require(success, "MyERC721Token: ether transfer failed");

        emit Withdraw(msg.sender, account, balance);
    }
}
