// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../721/IERC721.sol";

/**
 * @dev Interface for ERC2981 as defined in EIP-2981
 */
interface IERC2981 is IERC721 {
    /**
     * @dev ERC2891 standard functions
     */
    function royaltyInfo(uint256 tokenId, uint256 salePrice) external view returns (address receiver, uint256 royaltyAmount);
}
