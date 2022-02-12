// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @title Ownable Contract
 *
 * @dev Implementation of contract ownership
 */
abstract contract Ownable {
    /**
     * @dev Ownable events
     */

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Ownable definitions
     */
    
    address private _owner;

    /**
     * @dev Prevents function called by non-owner from executing
     */

    modifier onlyOwner() {
        require(owner() == msg.sender, "Ownable: caller is not the owner");

        _;
    }

    /**
     * @dev Sets the deployer as the initial owner
     */

    constructor(address owner_) {
        _transferOwnership(owner_);
    }

    /**
     * @dev Ownable public functions
     */

    function owner() public view virtual returns (address) {

        return _owner;
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");

        _transferOwnership(newOwner);
    }

    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Ownable event emitting interal functions
     */

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
    
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}
