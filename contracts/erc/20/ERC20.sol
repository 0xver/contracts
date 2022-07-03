// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "./interface/IERC20.sol";

/**
 * @dev Implementation of ERC20
 */
contract ERC20 is IERC20 {
    // Mapping address to balance
    mapping(address => uint256) private _balances;

    // Mapping owner address to spender address allowance
    mapping(address => mapping(address => uint256)) private _allowances;

    // Total supply variable
    uint256 private _totalSupply;

    /**
     * @dev Default to 18 decimals
     */
    function decimals() public pure virtual override returns (uint8) {
        return 18;
    }

    /**
     * @dev Returns total supply
     */
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev Returns owner balance
     */
    function balanceOf(address _owner) public view override returns (uint256) {
        return _balances[_owner];
    }

    /**
     * @dev Transfers tokens with _transfer
     */
    function transfer(address _to, uint256 _value) public override returns (bool) {
        require(balanceOf(msg.sender) >= _value, "ERC20: value exceeds balance");

        _transfer(msg.sender, _to, _value);
        return true;
    }

    /**
     * @dev Transfers tokens from spender address with _transfer
     */
    function transferFrom(address _from, address _to, uint256 _value) public override returns (bool) {
        require(balanceOf(_from) >= _value, "ERC20: value exceeds balance");
        if (msg.sender != _from) {
            require(balanceOf(_from) >= allowance(_from, msg.sender), "ERC20: allowance exceeds balance");
            _allowances[_from][msg.sender] -= _value;
        }
        _transfer(_from, _to, _value);
        return true;
    }

    /**
     * @dev Approves address for spending tokens
     */
    function approve(address _spender, uint256 _value) public override returns (bool) {
        require(_spender != address(0), "ERC20: cannot approve the zero address");
        require(_spender != msg.sender, "ERC20: cannot approve the owner");
        _allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    /**
     * @dev Returns spender allowance
     */
    function allowance(address _owner, address _spender) public view override returns (uint256) {
        return _allowances[_owner][_spender];
    }

    /**
     * @dev Transfers tokens and emits event
     */
    function _transfer(address _from, address _to, uint256 _value) internal {
        require(_to != address(0), "ERC20: transfer to the zero address");
        _balances[_from] -= _value;
        _balances[_to] += _value;
        emit Transfer(_from, _to, _value);
    }

    /**
     * @dev Mints tokens and emits event
     */
    function _mint(address _to, uint256 _value) internal {
        require(_to != address(0), "ERC20: cannot mint to the zero address");
        _totalSupply += _value;
        _balances[_to] += _value;
        emit Transfer(address(0), _to, _value);
    }

    /**
     * @dev Burns tokens and emits event
     */
    function _burn(address _from, uint256 _value) internal {
        require(_from != address(0), "ERC20: burn cannot be from zero address");
        _balances[_from] -= _value;
        _totalSupply -= _value;
        emit Transfer(_from, address(0), _value);
    }
}
