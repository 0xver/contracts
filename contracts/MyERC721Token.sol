// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev Imports contracts from the library
 */

import "./access/Ownable.sol";
import "./erc/721/royalty/ERC721Royalty.sol";
import "./security/ReentrancyGuard.sol";

/**
 * @title My ERC721 Token
 *
 * @dev Extends ERC721 non-fungible token standard
 */
contract MyERC721Token is ERC721Royalty, Ownable, ReentrancyGuard {
    /**
     * @dev Handles ETH received by contract
     */

    receive() external payable {}
    fallback() external payable {}

    /**
     * @dev Events
     */

    event Mint(address receiver, uint256 tokenId, string cid);
    event Withdrawal(address operator, address receiver, uint256 value);

    /**
     * @dev MyERC721Token definitions
     */

    mapping(address => uint256) private _whitelist;
    bool private _publicMintStatus = false;

    /**
     * @dev Sets ERC721 constructor values
     */

    constructor() ERC721("My ERC721 Token", "TKN") Ownable(msg.sender) {
        // Bored Ape Yacht Club used as an example
        _setExtendedBaseUri("QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/");
    }

    /**
     * @dev Internal mint routing
     */

    function _routeMint(address _to, uint256 _percent) internal {
        _mint(_to);
        _setTokenRoyalty(_currentTokenId(), _to, _percent);

        emit Mint(_to, _currentTokenId(), tokenURI(_currentTokenId()));
    }

    /**
     * @dev Adds account to whitelist
     */

    function addToWhitelist(address _account) public onlyOwner {
        require(_whitelist[_account] != 1, "MyERC721Token: account already in whitelist");

        _whitelist[_account] = 1;
    }

    /**
     * @dev Initiate public mint
     */

    function initiatePublicMint() public onlyOwner {
        _publicMintStatus = true;
    }

    /**
     * @dev Mint function with pre-mint for whitelist
     */

    function mint(address _account, uint256 _percent) public gate {
        if (_publicMintStatus == false) {
            require(_whitelist[_account] != 0, "MyERC721Token: account not in whitelist");

            _whitelist[_account] = 0;

            _routeMint(_account, _percent);
        } else {
            _routeMint(_account, _percent);
        }
    }

    /**
     * @dev Withdraw ether from contract
     */

    function withdraw(address _account) public onlyOwner {
        (bool success, ) = payable(_account).call{value: address(this).balance}("");
        require(success, "MyERC721Token: ether transfer failed");

        emit Withdrawal(msg.sender, _account, address(this).balance);
    }
}
