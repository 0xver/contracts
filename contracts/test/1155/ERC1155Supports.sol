// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "../../erc/165/interface/IERC165.sol";
import "../../erc/173/ERC173.sol";
import "../../erc/1155/ERC1155Metadata.sol";
import "../../security/Guardian.sol";

/**
 * @dev Supports interface and bundling
 */
contract ERC1155Supports is ERC1155Metadata, IERC165, ERC173, Guardian {
    receive() external payable {}
    fallback() external payable {}

    // Withdrawn event
    event Withdrawn(address operator, address receiver, uint256 value);

    // Constructs ERC1155Metadata and ERC173
    constructor() ERC1155Metadata("ERC1155 Token", "ERC1155") ERC173(msg.sender) {}

    /**
     * @dev Withdraw ether from contract
     */
    function withdraw(address _to) public ownership {
        uint256 balance = address(this).balance;
        (bool success, ) = payable(_to).call{value: address(this).balance}("");
        require(success, "MyERC20Token: ether transfer failed");
        emit Withdrawn(msg.sender, _to, balance);
    }

    /**
     * @dev Supports interface
     */
    function supportsInterface(bytes4 interfaceId) public pure override(IERC165) returns (bool) {
        return
            interfaceId == type(IERC165).interfaceId ||
            interfaceId == type(IERC173).interfaceId ||
            interfaceId == type(IERC1155).interfaceId ||
            interfaceId == type(IERC1155Metadata).interfaceId ||
            interfaceId == type(IERC1155Receiver).interfaceId;
    }
}
