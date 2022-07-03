// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

/**
 * @title ERC2981 standard
 */
interface IERC2981 {
    function royaltyInfo(uint256 _tokenId, uint256 _salePrice) external view returns (address receiver, uint256 royaltyAmount);
}
