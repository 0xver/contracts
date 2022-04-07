// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev Imports contracts from the library
 */

import "./erc/20/Package_ERC20.sol";
import "./erc/173/Package_ERC173.sol";
import "./security/Package_Guardian.sol";

/**
 * @title My ERC20 Token
 *
 * @dev Extends ERC20 fungible token standard
 */
contract MyERC20Token is Package_ERC20, Package_ERC173, Package_Guardian {
    /**
     * @dev Handles ETH received by contract
     */

    receive() external payable {}
    fallback() external payable {}

    /**
     * @dev Events
     */

    event Stake(address staker, uint256 value, uint256 time);
    event Claim(address staker, uint256 value);
    event Withdraw(address operator, address receiver, uint256 value);

    /**
     * @dev MyFungibleToken definitions
     */

    mapping(address => uint256) private _timestamp;
    mapping(address => uint256) private _staked;

    /**
     * @dev Sets ERC20 constructor values and mints total token supply to deployer
     */

    constructor() Package_ERC20("My ERC20 Token", "TKN") Package_ERC173(msg.sender) {
        _mint(msg.sender, 1000000000 * 10 ** decimals());
    }

    /**
     * @dev Token staking function
     */

    function stake(uint256 _value) public gate {
        require(balanceOf(msg.sender) > 0, "MyERC20Token: zero token balance");

        _timestamp[msg.sender] = block.timestamp;
        _staked[msg.sender] = _value;

        _transfer(msg.sender, address(this), _value);

        emit Stake(msg.sender, _value, 30 days);
    }

    /**
     * @dev Token claim function
     */

    function claim() public gate {
        require(_staked[msg.sender] > 0, "MyERC20Token: no tokens staked");
        require(_timestamp[msg.sender] + 30 days <= block.timestamp, "MyERC20Token: lock time has not completed");

        uint256 staked = _staked[msg.sender];

        _transfer(address(this), msg.sender, staked);

        _timestamp[msg.sender] = 0;
        _staked[msg.sender] = 0;

        // Add claim reward logic below and adjust event accordingly

        emit Claim(msg.sender, staked);
    }

    /**
     * @dev Withdraw ether from contract
     */

    function withdraw(address _to) public ownership {
        uint256 balance = address(this).balance;
        (bool success, ) = payable(_to).call{value: address(this).balance}("");
        require(success, "MyERC20Token: ether transfer failed");

        emit Withdraw(msg.sender, _to, balance);
    }
}
