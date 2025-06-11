// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import {Test} from "forge-std/Test.sol";
import {DeployRatherToken} from "../script/DeployRatherToken.s.sol";
import {RatherToken} from "../contracts/RatherToken.sol";
contract RatherTokenTest is Test {
    RatherToken public ratherToken;
    DeployRatherToken public deployer;

    // Test addresses
    //address owner = makeAddr("owner");
    address user1 = makeAddr("user1");
    address user2 = makeAddr("user2");
    address spender = makeAddr("spender");

    // Constants
    uint256 constant INITIAL_SUPPLY = 1000 ether;
    uint256 constant TRANSFER_AMOUNT = 100 ether;
    uint256 constant APPROVAL_AMOUNT = 300 ether;
    uint256 constant TEST_MINT_AMOUNT = 500 ether;    

    function setUp() public {
        //Deploy
        deployer = new DeployRatherToken();
        ratherToken = deployer.run(INITIAL_SUPPLY);

        //msg.sender is test contract
        //vm.startPrank(address(deployer));
        //ratherToken.transferOwnership(owner);
        //vm.stopPrank();

        //Fund test users from owner
        vm.prank(msg.sender);//mock
        ratherToken.transfer(user1,TRANSFER_AMOUNT);
    }

    // Deployment
    function testDeploymentInitialSupply() public view {
        assertEq(ratherToken.totalSupply(), INITIAL_SUPPLY);
        assertEq(ratherToken.balanceOf(msg.sender), INITIAL_SUPPLY-TRANSFER_AMOUNT);
        assertEq(ratherToken.balanceOf(user1), TRANSFER_AMOUNT);
    }

    function testDeploymentOwnerIsInitialOwner() public view {
        assertEq(ratherToken.owner(), msg.sender);
    }    


    // Transfer
    function testTransferSuccess() public {
        vm.prank(user1);
        ratherToken.transfer(user2, TRANSFER_AMOUNT / 2);
        
        assertEq(ratherToken.balanceOf(user1), TRANSFER_AMOUNT / 2);
        assertEq(ratherToken.balanceOf(user2), TRANSFER_AMOUNT / 2);
    }


    // Ownership 

}