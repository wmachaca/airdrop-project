//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {RatherAirdrop} from "../contracts/RatherAirdrop.sol";
import {RatherToken} from "../contracts/RatherToken.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DeployRatherAirdrop is Script {
    bytes32 private s_merkleRoot = 0xa828cf1ba9a04d02a3c07c1c4e7e517fcc4b535b6b7c8e57abe51cb3f6384ef3;
    uint256 private s_amountToTransfer = 4* 25* 1e18;
    uint256 private initialSupply = 1000*1e18;

    //function deployRatherAirdrop(uint256 initialSupply) public returns (RatherAirdrop, RatherToken) {
    function deployRatherAirdrop() public returns (RatherAirdrop, RatherToken) {    
        vm.startBroadcast();
        RatherToken token = new RatherToken(initialSupply);
        RatherAirdrop airdrop = new RatherAirdrop(s_merkleRoot, IERC20(address(token)), s_amountToTransfer);
        //token.mint(token.owner(), s_amountToTransfer);
        token.transfer(address(airdrop), s_amountToTransfer);
        vm.stopBroadcast();
        return (airdrop,token);
    }

    //function run(uint256 initialSupply) external returns (RatherAirdrop, RatherToken) {
    function run() external returns (RatherAirdrop, RatherToken) {    
        return deployRatherAirdrop();
    }
}