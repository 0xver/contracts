// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC721Supports.sol";

/**
 * @title ERC721 Test
 */
contract ERC721Test is ERC721Supports {
    // Boolean for pausing mint
    bool private _pauseMint;

    // Construct contract with _setRevealURI ahead of time
    constructor() {
        // Azuki used as an example
        _setRevealCID("QmQFkLSQysj94s5GvTHPyzTxrawwtjgiiYS2TBLgrvw8CW", false);
        _pauseMint = true;
    }

    /**
     * @dev Pause minting with `true`
     */
    function pause(bool _bool) public ownership {
        if (_bool == true) {
            require(_pauseMint == false, "ERC721Test: mint paused");
            _pauseMint = true;
        } else if (_bool == false) {
            require(_pauseMint == true, "ERC721Test: mint in progress");
            _pauseMint = false;
        }
    }

    /**
     * @dev Return `true` if minting is paused
     */
    function paused() public view returns (bool) {
        return _pauseMint;
    }

    /**
     * @dev Check URI before reveal
     */
    function checkURI(uint256 _tokenId) public view returns (string memory) {
        return _checkURI(_tokenId);
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
        require(_pauseMint == false, "ERC721Test: minting is paused");
        require(_quantity + totalSupply() <= 10000 && _quantity <= 10, "ERC721Test: mint limit reached");
        _mint(msg.sender, _quantity);
    }

    /**
     * @dev Mint function for public
     */
    function publicMint(uint256 _quantity) public gate {
        require(_pauseMint == false, "ERC721Test: minting is paused");
        require(_quantity + totalSupply() <= 10000 && _quantity <= 10, "ERC721Test: mint limit reached");
        _mint(msg.sender, _quantity);
    }

    /**
     * @dev Mint function for airdrop
     */
    function airdrop(address _to, uint256 _quantity) public ownership {
        require(_quantity + totalSupply() <= 10000, "ERC721Test: mint limit reached");
        _mint(_to, _quantity);
    }
}
