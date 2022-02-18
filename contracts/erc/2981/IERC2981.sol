// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @title ERC2981 Interface
 *
 * @dev Interface of the ERC2981 standard according to the EIP
 */
interface IERC2981 {
    /**
     * @dev ERC2891 standard functions
     */

    function royaltyInfo(uint256 _tokenId, uint256 _salePrice) external view returns (address receiver, uint256 royaltyAmount);
}
