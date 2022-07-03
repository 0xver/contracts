// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "./ERC20.sol";
import "./interface/IERC20Metadata.sol";

/**
 * @dev Implementation of ERC20Metadata
 */
contract ERC20Metadata is ERC20, IERC20Metadata {
    // Name string variable
    string private _name;

    // Symbol string variable
    string private _symbol;

    // Constructs ERC20Metadata
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev Name of contract
     */
    function name() public view override returns (string memory) {
        return _name;
    }

    /**
     * @dev Symbol of contract
     */
    function symbol() public view override returns (string memory) {
        return _symbol;
    }
}
