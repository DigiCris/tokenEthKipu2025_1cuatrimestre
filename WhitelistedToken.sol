// SPDX-License-Identifier: MIT
pragma solidity >0.8.0;

import "./ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract USDC is ERC20, Ownable {
    mapping (address =>bool) public whitelist;

    constructor() ERC20("Circle","USDC") Ownable(msg.sender) {}

    function setWhitelist(address _who,bool _whitelist) external onlyOwner {
        whitelist[_who] = _whitelist;
    }


    function _transfer(address _from, address _to, uint256 _value) internal override returns (bool success) {
        if (!whitelist[_to]) revert();
        return super._transfer(_from, _to, _value);
    }
}