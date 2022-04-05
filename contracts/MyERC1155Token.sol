// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev Imports contracts from the library
 */

import "./erc/165/IERC165.sol";
import "./erc/173/ERC173.sol";
import "./erc/1155/ERC1155.sol";
import "./security/Guardian.sol";

/**
 * @title My ERC1155 Token
 *
 * @dev Extends ERC1155 non-fungible token standard
 */
contract MyERC1155Token is ERC1155, ERC173, IERC165, Guardian {
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

    constructor() ERC1155("My ERC1155 Token", "TKN") ERC173(msg.sender) {
    }

    /**
     * @dev Creates new token ID
     */

    function initTokenId(string memory _cid) public ownership {
        _initTokenId(_cid);
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
     * @dev ERC165 function
     */

    function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165) returns (bool) {
        return
            interfaceId == type(IERC165).interfaceId ||
            interfaceId == type(IERC173).interfaceId ||
            interfaceId == type(IERC1155).interfaceId ||
            interfaceId == type(IERC1155Metadata).interfaceId ||
            interfaceId == type(IERC1155Receiver).interfaceId;
    }
}
