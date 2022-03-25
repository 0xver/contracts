// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev Imports contracts from the library
 */

import "./erc/173/ERC173.sol";
import "./erc/20/ERC20.sol";
import "./security/Guardian.sol";

/**
 * @title My ERC20 Token
 *
 * @dev Extends ERC20 fungible token standard
 */
contract MyERC20Token is ERC20, ERC173, Guardian {
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
    event Withdrawal(address operator, address receiver, uint256 value);

    /**
     * @dev MyFungibleToken definitions
     */

    mapping(address => uint256) private _timestamp;
    mapping(address => uint256) private _staked;

    /**
     * @dev Sets ERC20 constructor values and mints total token supply to deployer
     */

    constructor() ERC20("My ERC20 Token", "TKN") ERC173(msg.sender) {
        _mint(msg.sender, 1000000000 * 10 ** decimals());
    }

    /**
     * @dev Token staking function
     */

    function stake(uint256 _value) public gate {
        require(balanceOf(msg.sender) > 0, "MyFungibleToken: zero token balance");

        _timestamp[msg.sender] = block.timestamp;
        _staked[msg.sender] = _value;

        _transfer(msg.sender, address(this), _value);

        emit Stake(msg.sender, _value, 30 days);
    }

    /**
     * @dev Token claim function
     */

    function claim() public gate {
        require(_staked[msg.sender] > 0, "MyFungibleToken: no tokens staked");
        require(_timestamp[msg.sender] + 30 days <= block.timestamp, "MyFungibleToken: lock time has not completed");

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
        require(success, "MyContract: ether transfer failed");

        emit Withdrawal(msg.sender, _to, balance);
    }
}
