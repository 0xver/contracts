// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "../../erc/165/interface/IERC165.sol";
import "../../erc/173/ERC173.sol";
import "../../erc/721/ERC721Metadata.sol";
import "../../security/Guardian.sol";

/**
 * @dev Supports interface and bundling
 */
contract ERC721Supports is ERC721Metadata, IERC165, ERC173, Guardian {
    receive() external payable {}
    fallback() external payable {}

    // Withdrawn event
    event Withdrawn(address operator, address receiver, uint256 value);

    // Constructs ERC721Metadata and ERC173
    constructor() ERC721Metadata("ERC721 Token", "ERC721", "cid/prereveal.json") ERC173(msg.sender) {}

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
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            interfaceId == type(IERC721Receiver).interfaceId;
    }
}
