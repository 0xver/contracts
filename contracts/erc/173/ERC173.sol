// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "./interface/IERC173.sol";

/**
 * @dev Implementation of the ERC173
 */
contract ERC173 is IERC173 {
    // Owner address of contract variable
    address private _owner;

    // Modifier for ownership access
    modifier ownership() {
        require(owner() == msg.sender, "ERC173: caller is not the owner");
        _;
    }

    // Constructor for ERC173
    constructor(address owner_) {
        _transferOwnership(owner_);
    }

    /**
     * @dev Returns owner of contract
     */
    function owner() public view override returns (address) {
        return _owner;
    }

    /**
     * @dev Transfers the ownership of contract interally
     */
    function transferOwnership(address _newOwner) public override ownership {
        _transferOwnership(_newOwner);
    }

    /**
     * @dev Transfers the ownership of contract and emits event
     */
    function _transferOwnership(address _newOwner) internal {
        address previousOwner = _owner;
        _owner = _newOwner;
        emit OwnershipTransferred(previousOwner, _newOwner);
    }
}
