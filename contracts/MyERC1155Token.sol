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

    event Mint(address receiver, uint256 tokenId, string cid, uint256 value);
    event Withdrawal(address operator, address receiver, uint256 value);

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

    function initialMint(address _to, string memory _cid, uint256 _value) public ownership {
        _initialMint(_to, _cid, _value);

        emit Mint(_to, _currentTokenId(), _cid, _value);
    }

    /**
     * @dev Mints tokens
     */

    function mint(address _to, uint256 _value) public ownership {
        _mint(_to, _value);

        emit Mint(_to, _currentTokenId(), uri(_currentTokenId()), _value);
    }

    /**
     * @dev Manual mint
     */

    function manualMint(address _to, uint256 _id, uint256 _value) public ownership {
        _manualMint(_to, _id, _value);

        emit Mint(_to, _id, uri(_id), _value);
    }

    /**
     * @dev Withdraw ether from contract
     */

    function withdraw(address account) public ownership {
        (bool success, ) = payable(account).call{value: address(this).balance}("");
        require(success, "MyERC721Token: ether transfer failed");

        emit Withdrawal(msg.sender, account, address(this).balance);
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
