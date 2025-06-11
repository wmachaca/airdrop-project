// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract RatherToken is ERC20, Ownable {
    constructor(uint256 initialSupply) ERC20("RatherToken", "RDT") Ownable(msg.sender) {
        _mint(msg.sender, initialSupply);
    }
}
