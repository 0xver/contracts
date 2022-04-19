// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev Prevents reentrancy attack from occuring
 */
contract Guardian {
    bool private _locked;

    constructor() {
        _locked = false;
    }

    modifier gate() {
        require(_locked == false, "Guardian: reentrancy denied");

        _locked = true;
        _;
        _locked = false;
    }
}
