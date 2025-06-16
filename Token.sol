// SPDX-License-Identifier: MIT
pragma solidity >0.8.0;

import "./ERC20.sol";

contract Token is ERC20 {

    address public owner;

    modifier onlyOwner(){
        require(owner==msg.sender,"not the owner");
        _;
    }

    constructor() ERC20("ETH KIP Token", "EKT") {
        _mint(msg.sender, 1_000_000 * (10**decimals()));
        owner = msg.sender;
    }

    function mint(address to, uint256 value)  public onlyOwner {
        _mint(to, value);
    }

    function buy() public payable {
        _mint(msg.sender, msg.value);
    }

    /*
        usa _transfer porque es una transferencia interna, por lo que
        no tiene sentido darle un approve. Esto si es necesario cuando
        el contrato es externo como en el caso de:
        https://github.com/DigiCris/alephSolidity/tree/main/ICO/Contracts

        La clase pasada fallaba porque le estabamos dando permiso al contrato
        del token para movernos los tokens, pero el que lo estaba moviendo
        era quien llamaba la función (el msg.sender) y por eso no pasaba
        el require de la funcion transferFrom del ERC20
    */
    function sell(uint256 amount) public payable {
        _transfer(msg.sender, address(this), amount);
        payable(msg.sender).transfer(amount);
    }

}