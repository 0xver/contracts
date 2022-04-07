// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @title Guardian Contract
 *
 * @dev Prevents reentrancy attack from occuring
 */
contract Package_Guardian {
    /**
     * @dev Guardian definitions
     */

    bool private _locked;

    /**
     * @dev Sets the `_locked` bool to `false`
     */

    constructor() {
        _locked = false;
    }

    /**
     * @dev Prevents a contract from calling itself directly or indirectly
     */

    modifier gate() {
        require(_locked == false, "Guardian: reentrancy denied");

        _locked = true;
        _;
        _locked = false;
    }
}