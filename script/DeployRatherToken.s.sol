// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import {Script} from "forge-std/Script.sol";
import {RatherToken} from "../contracts/RatherToken.sol";

contract DeployRatherToken is Script {
    uint256 public constant INITIAL_SUPPLY = 100 ether;
    function run() external returns(RatherToken) {
        vm.startBroadcast();
        RatherToken rt = new RatherToken(INITIAL_SUPPLY);
        vm.stopBroadcast();
        return rt; 
    }
}