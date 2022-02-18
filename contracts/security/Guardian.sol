// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @title Guardian Contract
 *
 * @dev Prevents reentrancy attack from occuring
 */
contract Guardian {
    /**
     * @dev Guardian definitions
     */

    bool private constant unlocked = true;
    bool private constant locked = false;

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
        require(_status != locked, "Guardian: reentrancy denied");

        _status = locked;
        _;
        _status = unlocked;
    }
}
