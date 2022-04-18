// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev Imports contracts from the library
 */

import "./erc/165/ERC165.sol";
import "./erc/173/Package_ERC173.sol";
import "./erc/1155/Package_ERC1155.sol";
import "./erc/1155/extensions/Package_ERC1155Metadata.sol";
import "./security/Package_Guardian.sol";

/**
 * @title My ERC1155 Token
 *
 * @dev Extends ERC1155 semi-fungible token standard
 */
contract MyERC1155Token is Package_ERC1155, Package_ERC1155Metadata, Package_ERC173, ERC165, Package_Guardian {
    /**
     * @dev Handles ETH received by contract
     */

    receive() external payable {}
    fallback() external payable {}

    /**
     * @dev Events
     */

    event Withdraw(address operator, address receiver, uint256 value);

    /**
     * @dev MyNonFungibleToken definitions
     */

    mapping(address => uint256) private _whitelist;

    /**
     * @dev Sets ERC1155 constructor values
     */

    constructor() Package_ERC1155Metadata("My ERC1155 Token", "TKN") Package_ERC173(msg.sender) {
    }

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

    /**
     * @dev Return `true` if supports interface
     */

    function supportsInterface(bytes4 interfaceId) public pure override(ERC165) returns (bool) {
        return
            interfaceId == type(ERC165).interfaceId ||
            interfaceId == type(ERC173).interfaceId ||
            interfaceId == type(ERC1155).interfaceId ||
            interfaceId == type(ERC1155Metadata).interfaceId ||
            interfaceId == type(ERC1155Receiver).interfaceId;
    }
}
