// SPDX-License-Identifier: MIT
pragma solidity >0.8.0;

import "./ERC20.sol";

contract Token is ERC20 {

    address public owner;

    modifier onlyOwner(){
        require(owner==msg.sender,"not the owner");
        _;
    }

    constructor(string memory symbol_) ERC20("ETH KIP Token", symbol_) {
        _mint(msg.sender, 1_000_000 * (10**decimals()));
        owner = msg.sender;
    }

    function mint(address to, uint256 value)  public onlyOwner {
        _mint(to, value);
    }
}