// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../../erc/2981/ERC2981.sol";

/**
 * @dev Implementation of ERC2981
 */
contract Package_ERC2981 is ERC2981 {
    mapping(uint256 => RoyaltyInfo) internal _royalty;

    struct RoyaltyInfo {
        address receiver;
        uint256 percent;
    }

    function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view override returns (address, uint256) {
        RoyaltyInfo memory royalty = _royalty[_tokenId];
        uint256 royaltyAmount;
        if (royalty.percent == 0) {
            royaltyAmount = 0;
        } else {
            royaltyAmount = (_salePrice * royalty.percent) / 100;
        }
        return (royalty.receiver, royaltyAmount);
    }

    function _setTokenRoyalty(uint256 _tokenId, address _receiver, uint256 _percent) internal {
        require(_percent <= 100, "ERC2981: royalty fee will exceed sale price");
        require(_receiver != address(0), "ERC2981: royalty to the zero address");
        _royalty[_tokenId] = RoyaltyInfo(_receiver, _percent);
    }
}
