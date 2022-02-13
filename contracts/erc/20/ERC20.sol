// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IERC20.sol";

/**
 * @title ERC20 Contract
 *
 * @dev Implementation of the ERC20 standard
 */
contract ERC20 is IERC20 {
    /**
     * @dev ERC20 definitions
     */

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    string private _name;
    string private _symbol;
    uint256 private _totalSupply;

    /**
     * @dev Sets the token name and symbol
     */

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev ERC20 functions
     */

    function name() public view virtual override returns (string memory) {

        return _name;
    }

    function symbol() public view virtual override returns (string memory) {

        return _symbol;
    }

    function decimals() public view virtual override returns (uint8) {

        return 18;
    }

    function totalSupply() public view virtual override returns (uint256) {

        return _totalSupply;
    }

    function balanceOf(address _owner) public view virtual override returns (uint256) {

        return _balances[_owner];
    }

    function transfer(address _to, uint256 _value) public virtual override returns (bool) {
        require(balanceOf(msg.sender) >= _value, "ERC20: value exceeds balance");

        _transfer(msg.sender, _to, _value);

        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public virtual override returns (bool) {
        require(balanceOf(_from) >= _value, "ERC20: value exceeds balance");

        if (msg.sender != _from) {
            require(balanceOf(_from) >= allowance(_from, msg.sender), "ERC20: allowance exceeds balance");

            _allowances[_from][msg.sender] -= _value;
        }

        _transfer(_from, _to, _value);

        return true;
    }

    function approve(address _spender, uint256 _value) public virtual override returns (bool) {
        require(_spender != address(0), "ERC20: cannot approve the zero address");
        require(_spender != msg.sender, "ERC20: cannot approve caller");

        _allowances[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);

        return true;
    }

    function allowance(address _owner, address _spender) public view virtual override returns (uint256) {

        return _allowances[_owner][_spender];
    }

    /**
     * @dev ERC20 internal functions
     */

    function _transfer(address _from, address _to, uint256 _value) internal virtual {
        require(_to != address(0), "ERC20: transfer to the zero address");

        _balances[_from] -= _value;
        _balances[_to] += _value;

        emit Transfer(_from, _to, _value);
    }

    function _mint(address _to, uint256 _value) internal virtual {
        require(_to != address(0), "ERC20: cannot mint to the zero address");

        _totalSupply += _value;
        _balances[_to] += _value;

        emit Transfer(address(0), _to, _value);
    }

    function _burn(address _from, uint256 _value) internal virtual {
        require(_from == address(0), "ERC20: burn must be to the zero address");

        _balances[_from] -= _value;
        _totalSupply -= _value;

        emit Transfer(_from, address(0), _value);
    }
}
