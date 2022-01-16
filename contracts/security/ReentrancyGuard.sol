// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev Contract module that prevents reentrant calls to a function
 */
abstract contract ReentrancyGuard {
    bool private constant unlocked = true;
    bool private constant locked = false;

    bool private _status;

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
