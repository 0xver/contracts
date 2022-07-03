// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "../library/utils.sol";

/**
 * @dev Merkle tree
 */
contract Merkle {
    // Merkle root variable
    bytes32 private root;

    /**
     * @dev Sets merkle root
     */
    function _setMerkleRoot(bytes32 _root) internal {
        root = _root;
    }

    /**
     * @dev Returns merkle root
     */
    function merkleRoot() internal view returns (bytes32) {
        return root;
    }

    /**
     * @dev Merkle proof modifier
     */
    modifier merkleProof(address _to, bytes32[] calldata _merkleProof) {
        bytes32 leaf = keccak256(abi.encodePacked(_to));
        require(utils.verify(_merkleProof, merkleRoot(), leaf), "Merkle: invalid merkle proof.");
        _;
    }
}
