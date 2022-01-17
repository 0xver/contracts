// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IERC20.sol";

/**
 * @dev Implementation of the IERC20 interface
 */
contract ERC20 is IERC20 {
    /**
     * @dev ERC20 definitions
     */
    
    // Maps owner account to token balance
    mapping(address => uint256) private _balances;

    // Maps owner account to spender account and allowance amount
    mapping(address => mapping(address => uint256)) private _allowances;

    // Token name
    string private _name;

    // Token symbol
    string private _symbol;

    // Token supply
    uint256 private _totalSupply;

    /**
     * @dev Sets the token {name} and {symbol}
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev ERC20 public functions
     */

    // Returns the name of the token
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    // Returns the symbol of the token
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    // Returns the decimals of the token
    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    // Returns the total suppy of tokens
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    // Returns the token balance for `account`
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    // Transfers token `amount` to `to`
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(msg.sender, recipient, amount);

        return true;
    }

    // Transfers token `amount` from `sender` to `recipient` using the allowance mechanism
    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        uint256 currentAllowance = _allowances[sender][msg.sender];
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
            unchecked {_approve(sender, msg.sender, currentAllowance - amount);}
        }

        _transfer(sender, recipient, amount);

        return true;
    }

    // Sets `amount` as the allowance of `spender` over the caller tokens
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(msg.sender, spender, amount);

        return true;
    }

    // Returns the remaining number of tokens that `spender` will be allowed to spend on behalf of `owner` through `transferFrom`
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    // Atomically increases the allowance granted to `spender` by the caller
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);

        return true;
    }

    // Atomically decreases the allowance granted to `spender` by the caller
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        uint256 currentAllowance = _allowances[msg.sender][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {_approve(msg.sender, spender, currentAllowance - subtractedValue);}

        return true;
    }

    /**
     * @dev ERC20 event emitting interal functions
     */
    
    // Emits {Transfer} event and transfers tokens to `account`
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply += amount;
        _balances[account] += amount;

        emit Transfer(address(0), account, amount);
    }

    // Emits {Transfer} event and burns tokens
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {_balances[account] = accountBalance - amount;}
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);
    }

    // Emits {Transfer} event and adjusts balances
    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {_balances[sender] = senderBalance - amount;}
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);
    }

    // Emits {Approval} event and sets approved account
    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        
        emit Approval(owner, spender, amount);
    }
}
