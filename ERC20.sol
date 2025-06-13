// SPDX-License-Identifier: MIT
pragma solidity >0.8.0;

import "./IERC20.sol";

abstract contract ERC20 is IERC20 {
    string internal _name;
    string internal _symbol;
    uint8 internal _decimals;
    uint256 internal _totalSupply;
    mapping(address => uint256) internal _balanceOf;
    mapping(address => mapping(address => uint256)) internal _allowance;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
        _decimals = 18;
    }

    function _mint(address to, uint256 value) internal {
        _balanceOf[to] += value;
        _totalSupply += value;
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return _balanceOf[_owner];
    }

    function transfer(address _to, uint256 _value)
        public
        returns (bool success)
    {
        return _transfer(msg.sender, _to, _value);
    }

    /*
        wallet1 => balanceOf(Wallet1) = 100
        wallet2 => balanceOf(Wallet2) = 50
                transaccion
        wallet1 => balanceOf(Wallet1) = 90
        wallet2 => balanceOf(Wallet2) = 60
    */
    function _transfer(
        address from,
        address _to,
        uint256 _value
    ) internal returns (bool success) {
        _balanceOf[from] -= _value;
        _balanceOf[_to] += _value;
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool success) {
        //require(_allowance[_from][msg.sender] > 0, "InsuficientAllowance");
        // se verifica ademas que el allowance sea superior o igual al valor
        require(
            _allowance[_from][msg.sender] >= _value,
            "ERC20: transfer amount exceeds allowance"
        );

        _allowance[_from][msg.sender] -= _value;
        return _transfer(_from, _to, _value);
    }

    function allowance(address _owner, address _spender)
        public
        view
        returns (uint256 remaining)
    {
        return _allowance[_owner][_spender];
    }
    // El appove debe asegurarse de que se haya aprobado 0 antes del nuevo approve
    function approve(address _spender, uint256 _value)
        external
        returns (bool success)
    {
        // Este cambio es esencial a nivel de seguridad porque de no tenerlo
        // puede haber una race condition en la cual el spender puede 
        // transferir el allowance antes de que se mine un approve por un monto inferior
        // esa transaccion es permitida y el spender ya cuenta con los tokens
        // luego de que se mine el nuevo allowance el spender puede transferir de 
        // nuevo el importe permitido


        require(
            _value == 0 || _allowance[msg.sender][_spender] == 0,
            "Must set allowance to 0 before changing it to a new value (see ERC20 race condition warning)"
        );

        _allowance[msg.sender][_spender] = _value;
        return true;
    }
}
