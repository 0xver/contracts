// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @title ERC2981 standard
 */
interface ERC2981 {
    /**
     * @dev Functions
     */

    function royaltyInfo(uint256 _tokenId, uint256 _salePrice) external view returns (address receiver, uint256 royaltyAmount);
}