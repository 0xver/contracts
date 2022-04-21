// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./packages/Bundle_ERC721.sol";

/**
 * @title My ERC721 Token
 */
contract MyERC721Token is Bundle {
    receive() external payable {}
    fallback() external payable {}

    event Withdraw(address operator, address receiver, uint256 value);

    mapping(address => bool) private _whitelist;

    bool private _pauseMint;

    constructor() {
        // Bored Ape Yacht Club used as an example
        _setRevealURI("QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq", false);
        _pauseMint = true;
    }

    /**
     * @dev Unpause minting
     */
    function unpause() public ownership {
        _pauseMint = false;
    }

    /**
     * @dev Pause minting
     */
    function pause() public ownership {
        _pauseMint = true;
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
     * @dev Mint function for whitelist
     */
    function privateMint(uint256 _quantity, bytes32[] calldata _merkleProof) public merkleProof(msg.sender, _merkleProof) {
        require(_pauseMint == false, "MyERC721Token: minting is paused");
        _mint(msg.sender, _quantity);
    }

    /**
     * @dev Mint function for public
     */
    function publicMint(uint256 _quantity) public gate {
        require(_pauseMint == false, "MyERC721Token: minting is paused");
        _mint(msg.sender, _quantity);
    }

    /**
     * @dev Mint function for airdrop
     */
    function airdrop(address _to, uint256 _quantity) public ownership {
        require(_quantity + totalSupply() <= 4200, "TheHappyChemicalClub: maximum tokens minted");
        _mint(_to, _quantity);
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
}
