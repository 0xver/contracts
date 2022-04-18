// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev Imports contracts from the library
 */

import "./erc/165/ERC165.sol";
import "./erc/173/Package_ERC173.sol";
import "./erc/721/Package_ERC721.sol";
import "./erc/721/extensions/Package_ERC721Metadata.sol";
import "./erc/2981/Package_ERC2981.sol";
import "./security/Package_Guardian.sol";

/**
 * @title My ERC721 Token
 *
 * @dev Extends ERC721 non-fungible token standard
 */
contract MyERC721Token is Package_ERC2981, Package_ERC721, Package_ERC721Metadata, Package_ERC173, ERC165, Package_Guardian {
    /**
     * @dev Handles ETH received by contract
     */

    receive() external payable {}
    fallback() external payable {}

    /**
     * @dev Events
     */

    event Withdraw(address operator, address receiver, uint256 value);

    /**
     * @dev MyERC721Token definitions
     */

    mapping(address => bool) private _whitelist;
    bool private _pauseMint = true;

    /**
     * @dev Set ERC721 and ERC173 constructor values
     */

    constructor() Package_ERC721Metadata("My ERC721 Token", "TKN", "pr34v31/prereveal.json") Package_ERC173(msg.sender) {
        // Bored Ape Yacht Club used as an example
        _setRevealURI("QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq", false);
    }

    /**
     * @dev Add accounts to on-chain whitelist
     */

    function addToWhitelist(address[] memory _accounts) public ownership {
        for (uint i = 0; i < _accounts.length; i++) {
            _whitelist[_accounts[i]] = true;
        }
    }

    /**
     * @dev Return `true` if account is whitelisted
     */

    function whitelisted(address _account) public view returns (bool) {
        return _whitelist[_account];
    }

    /**
     * @dev Initiate minting
     */

    function unpause(bool _status) public ownership {
        _pauseMint = _status;
    }

    /**
     * @dev Return `true` if minting is paused
     */

    function paused() public view returns (bool) {
        return _pauseMint;
    }

    /**
     * @dev Reveal token collection
     */

    function reveal() public ownership {
        _reveal();
    }

    /**
     * @dev Set Merkle root
     */
    
    function setMerkleRoot(bytes32 _merkleRoot) public ownership {
        _setMerkleRoot(_merkleRoot);
    }

    /**
     * @dev Mint function for off-chain whitelist
     */

    function merkleProofMint(address _account, bytes32[] calldata _merkleProof, uint256 _percent, uint256 _quantity) public gate {
        for (uint256 i=0; i < _quantity; i++) {
            _merkleProofMint(_account, _merkleProof);
            _setTokenRoyalty(_currentTokenId(), _account, _percent);
        }
    }

    /**
     * @dev Mint function for on-chain whitelist
     */

    function onChainWhitelistMint(address _account, uint256 _percent, uint256 _quantity) public gate {
        require(_pauseMint == false, "MyERC721Token: minting is paused");
        require(_whitelist[_account] == true, "MyERC721Token: account not on whitelist");
        _whitelist[_account] = false;
        for (uint256 i=0; i < _quantity; i++) {
            _mint(_account);
            _setTokenRoyalty(_currentTokenId(), _account, _percent);
        }
    }

    /**
     * @dev Withdraw ether from contract
     */

    function withdraw(address _account) public ownership {
        uint256 balance = address(this).balance;
        (bool success, ) = payable(_account).call{value: address(this).balance}("");
        require(success, "MyERC721Token: ether transfer failed");

        emit Withdraw(msg.sender, _account, balance);
    }

    /**
     * @dev Return `true` if supports interface
     */

    function supportsInterface(bytes4 interfaceId) public pure override(ERC165) returns (bool) {
        return
            interfaceId == type(ERC165).interfaceId ||
            interfaceId == type(ERC173).interfaceId ||
            interfaceId == type(ERC721).interfaceId ||
            interfaceId == type(ERC721Metadata).interfaceId ||
            interfaceId == type(ERC721Receiver).interfaceId ||
            interfaceId == type(ERC2981).interfaceId;
    }
}
