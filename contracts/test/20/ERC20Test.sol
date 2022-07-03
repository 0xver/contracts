// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "./ERC20Supports.sol";

/**
 * @title ERC20 Test
 */
contract ERC20Test is ERC20Supports {
    // Staking event
    event Stake(address staker, uint256 value, uint256 time);

    // Claim event
    event Claim(address staker, uint256 value);

    // Mapping address to timestamp
    mapping(address => uint256) private _timestamp;

    // Mapping address to amount staked
    mapping(address => uint256) private _staked;

    // Mint token supply to deployer address
    constructor() {
        _mint(msg.sender, 1000000000 * 10 ** decimals());
    }

    /**
     * @dev Stake tokens
     */
    function stake(uint256 _value) public gate {
        require(balanceOf(msg.sender) > 0, "ERC20Test: zero token balance");
        _timestamp[msg.sender] = block.timestamp;
        _staked[msg.sender] = _value;
        _transfer(msg.sender, address(this), _value);
        emit Stake(msg.sender, _value, 30 days);
    }

    /**
     * @dev Claim tokens
     */
    function claim() public gate {
        require(_staked[msg.sender] > 0, "ERC20Test: no tokens staked");
        require(_timestamp[msg.sender] + 30 days <= block.timestamp, "ERC20Test: lock time has not completed");
        uint256 staked = _staked[msg.sender];
        _transfer(address(this), msg.sender, staked);
        _timestamp[msg.sender] = 0;
        _staked[msg.sender] = 0;
        // Add claim reward logic below and adjust event accordingly
        emit Claim(msg.sender, staked);
    }
}
