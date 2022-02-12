// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev Imports contracts from the library
 */

import "./access/Ownable.sol";
import "./erc/20/ERC20.sol";
import "./security/ReentrancyGuard.sol";

/**
 * @title My Fungible Token
 *
 * @dev Extends ERC20 fungible token standard
 */
contract MyFungibleToken is ERC20, Ownable, ReentrancyGuard {
    /**
     * @dev Events
     */

    event Stake(address staker, uint256 amount, uint256 time);
    event Claim(address staker, uint256 amount);
    event Withdrawal(address owner, address receiver, uint256 amount);

    /**
     * @dev MyFungibleToken definitions
     */

    mapping(address => uint256) private _timestamp;
    mapping(address => uint256) private _staked;

    /**
     * @dev Sets ERC20 constructor values and mints total token supply to deployer
     */

    constructor() ERC20("My Fungible Token", "MFT") Ownable(msg.sender) {
        _mint(msg.sender, 1000000000 * 10 ** decimals());
    }

    /**
     * @dev Token staking function
     */

    function stake(uint256 amount) public gate() {
        require(balanceOf(msg.sender) > 0, "MyFungibleToken: zero token balance");

        _timestamp[msg.sender] = block.timestamp;
        _staked[msg.sender] = amount;

        _transfer(msg.sender, address(this), amount);

        emit Stake(msg.sender, amount, 30 days);
    }

    /**
     * @dev Token claim function
     */

    function claim() public gate() {
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

    function withdraw(address receiver) public onlyOwner {
        (bool success, ) = payable(receiver).call{value: address(this).balance}("");
        require(success, "MyContract: ether transfer failed");

        emit Withdrawal(msg.sender, receiver, address(this).balance);
    }
}
