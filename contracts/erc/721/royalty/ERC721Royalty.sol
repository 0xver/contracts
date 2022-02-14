// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../ERC721.sol";
import "../../2981/IERC2981.sol";

/**
 * @title ERC2981 Contract
 *
 * @dev Implementation of the ERC2981 standard
 */
abstract contract ERC721Royalty is ERC721, IERC2981 {
    struct RoyaltyInfo {
        address receiver;
        uint256 percent;
    }

    mapping(uint256 => RoyaltyInfo) internal _royalty;

    /**
     * @dev ERC2981 function
     */

    function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
        RoyaltyInfo memory royalty = _royalty[_tokenId];
        uint256 royaltyAmount;

        if (royalty.percent == 0) {
            royaltyAmount = 0;
        } else {
            royaltyAmount = (_salePrice * royalty.percent) / 100;
        }

        return (royalty.receiver, royaltyAmount);
    }

    /**
     * @dev ERC2981 internal function
     */

    function _setTokenRoyalty(uint256 _tokenId, address _receiver, uint256 _percent) internal virtual {
        require(_percent <= 100, "ERC2981: royalty fee will exceed sale price");
        require(_receiver != address(0), "ERC2981: royalty to the zero address");

        _royalty[_tokenId] = RoyaltyInfo(_receiver, _percent);
    }

    /**
     * @dev ERC165 support function
     */

    function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
        return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
    }
}
