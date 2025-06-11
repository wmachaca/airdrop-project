// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import {Script} from "forge-std/Script.sol";
import {RatherToken} from "../contracts/RatherToken.sol";

contract DeployRatherToken is Script {
    function run(uint256 initialSupply) external returns (RatherToken) {
        vm.startBroadcast();
        RatherToken rt = new RatherToken(initialSupply);
        vm.stopBroadcast();
        return rt;
    }
}
