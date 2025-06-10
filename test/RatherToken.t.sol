// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import {Test} from "forge-std/Test.sol";
import {DeployRatherToken} from "../script/DeployRatherToken.s.sol";
import {RatherToken} from "../contracts/RatherToken.sol";
contract RatherTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken public deployer;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        vm.prank(msg.sender);//what is this?
        ourToken.transfer(bob,STARTING_BALANCE);
    }

    function testBobBalance() public {
        assertEq(STARTING_BALANCE, ourToken.balanceOf(bob));
    }
    function testAllowanceWorks() public {
        uint256 initialAllowance = 1000;
        //Bob approves Alice to spend tokens on her behalf
        vm.prank(bob);//like msg.sender is bob (mock)
        ourToken.approve(alice, initialAllowance);

        uint256 transferAmount = 500;

        vm.prank(alice);
        ourToken.transferFrom(bob,alice, transferAmount);

        assertEq(ourToken.balanceOf(alice), transferAmount);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE-transferAmount);
    }    
}