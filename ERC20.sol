// SPDX-License-Identifier: MIT
pragma solidity >0.8.0;

import "./IERC20.sol";

abstract contract ERC20 is IERC20 {
    string internal _name;
    string internal _symbol;
    uint8 internal _decimals;
    uint256 internal _totalSupply;
    mapping (address=>uint256) internal _balanceOf;
    mapping (address => mapping (address => uint256)) public _allowance;
    uint256 public logAllowance;


    constructor(string memory name_,string memory symbol_) {
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

    function transfer(address _to, uint256 _value) public returns (bool success) {
        return _transfer(msg.sender,_to,_value);
    }

    /*
        wallet1 => balanceOf(Wallet1) = 100
        wallet2 => balanceOf(Wallet2) = 50
                transaccion
        wallet1 => balanceOf(Wallet1) = 90
        wallet2 => balanceOf(Wallet2) = 60
    */
    function _transfer(address from, address _to, uint256 _value) internal returns (bool success) {
        _balanceOf[from] -= _value;
        _balanceOf[_to] += _value;
        return true;
    }

    /*
        El p roblema de la clase pasada era en 
        require(_allowance[_from][msg.sender] > 0...)
        debido a que estabamos haciendo un approve al contrato pero como haciamos el sell con el mismo
        contrato, el msg.sender era mi EOA y no el contrato el cual habíamos aprobado y por lo tanto
        nos quedaba 0>0 y logicamente esto revertía. Solución, acá puede ser llamar directamente a
        _transfer(from, to, value) ya que es interno.

        Luego habían otrod dos errores.El require debía comparar:
        _allowance[_from][msg.sender] >= _value  y no contra 0 y

        _allowance[_from][msg.sender] -= _value; // para decrementarlo cada vez que alguien usa el allowance
    */
    function transferFrom(address _from, address _to, uint256 _value) public  returns (bool success) {
        require(_allowance[_from][msg.sender] >= _value, "InsuficientAllowance"); // modificado fuera de la clase
        _allowance[_from][msg.sender] -= _value; // agregado fuera de la clase
        return _transfer(_from, _to, _value);
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return _allowance[_owner][_spender];
    }

    function approve(address _spender, uint256 _value) external returns (bool success) {
        _allowance[msg.sender][_spender] = _value;
        return true;
    }

}