// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev Contract module for single ownership
 */
abstract contract Ownable {
    /**
     * @dev Ownable events
     */

    // Event for ownership transfer
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Ownable definitions
     */
    
    // Owner address
    address private _owner;

    /**
     * @dev Prevents function called by non-owner from executing
     */
    modifier onlyOwner() {
        require(owner() == msg.sender, "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Initializes the contract setting the deployer as the initial owner
     */
    constructor() {
        _transferOwnership(msg.sender);
    }

    /**
     * @dev Ownable public functions
     */
    
    // Returns the owner address of the contract
    function owner() public view virtual returns (address) {
        return _owner;
    }

    // Transfers ownership of the contract to `newOwner`
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    // Leaves the contract without an owner
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Ownable event emitting interal functions
     */

    // Emits {OwnershipTransferred} event and transfers ownership of the contract to `newOwner`
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}
