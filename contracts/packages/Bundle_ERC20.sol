// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./20/Package_ERC20.sol";
import "./173/Package_ERC173.sol";
import "../security/Guardian.sol";

/**
 * @dev Supports interface bundle
 */
contract Bundle is Package_ERC20, Package_ERC173, Guardian {
    constructor() Package_ERC20("My ERC20 Token", "TKN") Package_ERC173(msg.sender) {}
}
