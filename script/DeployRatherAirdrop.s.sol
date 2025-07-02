//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {RatherAirdrop} from "../contracts/RatherAirdrop.sol";
import {RatherToken} from "../contracts/RatherToken.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DeployRatherAirdrop is Script {
    bytes32 private s_merkleRoot = 0x4e2a25cb48b3d980bbbf57eb9a597d4868ddced7e85801a19748c831a703c3cd;
    uint256 private s_amountToTransfer = 8* 25* 1e18;
    uint256 private initialSupply = 2000*1e18;

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