// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev Imports contracts from the library
 */

import "./erc/165/IERC165.sol";
import "./erc/173/ERC173.sol";
import "./erc/721/ERC721.sol";
import "./erc/2981/ERC2981.sol";
import "./security/Guardian.sol";

/**
 * @title My ERC721 Token
 *
 * @dev Extends ERC721 non-fungible token standard
 */
contract MyERC721Token is ERC2981, ERC721, ERC173, IERC165, Guardian {
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
     * @dev Sets ERC721 and ERC173 constructor values
     */

    constructor() ERC721("My ERC721 Token", "TKN") ERC173(msg.sender) {
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
     *
     * Use Merckle tree instead to avoid gas costs and adjust other functions accordingly
     */

    function addToWhitelist(address _account) public ownership {
        require(_whitelist[_account] != 1, "MyERC721Token: account already in whitelist");

        _whitelist[_account] = 1;
    }

    /**
     * @dev Initiate public mint
     */

    function initiatePublicMint() public ownership {
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

    function withdraw(address _account) public ownership {
        uint256 balance = address(this).balance;
        (bool success, ) = payable(_account).call{value: address(this).balance}("");
        require(success, "MyERC721Token: ether transfer failed");

        emit Withdrawal(msg.sender, _account, balance);
    }

    /**
     * @dev ERC165 function
     */

    function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165) returns (bool) {
        return
            interfaceId == type(IERC165).interfaceId ||
            interfaceId == type(IERC173).interfaceId ||
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            interfaceId == type(IERC721Receiver).interfaceId ||
            interfaceId == type(IERC2981).interfaceId;
    }
}
