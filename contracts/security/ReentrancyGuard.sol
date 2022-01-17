// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev Contract for module that prevents reentrant calls
 */
abstract contract ReentrancyGuard {
    /**
     * @dev ReentrancyGuard definitions
     */

    // Sets `unlocked` variable to true
    bool private constant unlocked = true;

    // Sets `locked` variable to false
    bool private constant locked = false;

    // Status bool
    bool private _status;

    /**
     * @dev Sets the `_status` bool to `unlocked`
     */
    constructor() {
        _status = unlocked;
    }

    /**
     * @dev Prevents a contract from calling itself directly or indirectly
     */
    modifier gate() {
        require(_status != locked, "ReentrancyGuard: reentrancy denied");

        _status = locked;
        _;
        _status = unlocked;
    }
}
