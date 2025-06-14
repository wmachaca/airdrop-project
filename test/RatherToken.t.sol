// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import {Test} from "forge-std/Test.sol";
import {DeployRatherToken} from "../script/DeployRatherToken.s.sol";
import {RatherToken} from "../contracts/RatherToken.sol";

contract RatherTokenTest is Test {
    RatherToken public ratherToken;
    DeployRatherToken public deployer;

    //Events like in IERC20.sol: only for testing
    event Transfer(address indexed from, address indexed to, uint256 value);

    //Error
    error ERC20InsufficientBalance(address sender, uint256 balance, uint256 needed);

    // Test addresses
    //address owner = makeAddr("owner");-> msg.sender
    address user1 = makeAddr("user1");
    address user2 = makeAddr("user2");
    address spender = makeAddr("spender");

    // Constants
    uint256 constant INITIAL_SUPPLY = 1000 ether;
    uint256 constant TRANSFER_AMOUNT = 100 ether;
    uint256 constant TRANSFER_AMOUNTE = 500 ether;
    uint256 constant APPROVAL_AMOUNT = 300 ether;
    uint256 constant TEST_MINT_AMOUNT = 500 ether;

    function setUp() public {
        //Deploy
        deployer = new DeployRatherToken();
        ratherToken = deployer.run(INITIAL_SUPPLY);

        //Fund test users from owner
        vm.prank(msg.sender); //mock
        ratherToken.transfer(user1, TRANSFER_AMOUNT);
    }

    // Deployment
    function testDeploymentInitialSupply() public view {
        assertEq(ratherToken.totalSupply(), INITIAL_SUPPLY);
        assertEq(ratherToken.balanceOf(msg.sender), INITIAL_SUPPLY - TRANSFER_AMOUNT);
        assertEq(ratherToken.balanceOf(user1), TRANSFER_AMOUNT);
    }

    function testDeploymentOwnerIsInitialOwner() public view {
        assertEq(ratherToken.owner(), msg.sender);
    }

    function testTokenMetadataCorrect() public view {
        assertEq(ratherToken.name(), "RatherToken");
        assertEq(ratherToken.symbol(), "RDT");
        assertEq(ratherToken.decimals(), 18);
    }

    // Transfer
    function testTransferSuccess() public {
        vm.prank(user1);
        ratherToken.transfer(user2, TRANSFER_AMOUNT / 2);

        assertEq(ratherToken.balanceOf(user1), TRANSFER_AMOUNT / 2);
        assertEq(ratherToken.balanceOf(user2), TRANSFER_AMOUNT / 2);
    }

    function testTransferEmitsEvent() public {
        vm.prank(msg.sender);
        vm.expectEmit(true, true, false, true);
        emit Transfer(msg.sender, user1, TRANSFER_AMOUNT);
        ratherToken.transfer(user1, TRANSFER_AMOUNT);
    }

    function testTransferFailsIfInsufficientBalance() public {
        vm.prank(user1);
        vm.expectRevert(abi.encodeWithSelector(ERC20InsufficientBalance.selector, user1, 100 ether, 500 ether));
        ratherToken.transfer(user2, TRANSFER_AMOUNTE);
    }

    function testTransferFromSuccess() public {
        // Owner approves spender
        vm.prank(msg.sender);
        ratherToken.approve(spender, APPROVAL_AMOUNT);

        // Spender transfers from owner to user1
        vm.prank(spender);
        ratherToken.transferFrom(msg.sender, user1, TRANSFER_AMOUNT);

        assertEq(ratherToken.balanceOf(msg.sender), INITIAL_SUPPLY - 2 * TRANSFER_AMOUNT);
        assertEq(ratherToken.balanceOf(user1), 2 * TRANSFER_AMOUNT);
        assertEq(ratherToken.allowance(msg.sender, spender), APPROVAL_AMOUNT - TRANSFER_AMOUNT);
    }

    // Approval
    function testApproveSuccess() public {
        vm.prank(msg.sender);
        ratherToken.approve(spender, APPROVAL_AMOUNT);

        assertEq(ratherToken.allowance(msg.sender, spender), APPROVAL_AMOUNT);
    }

    //Edge
    function testTransferZeroAmount() public {
        vm.prank(msg.sender);
        ratherToken.transfer(user1, 0);

        assertEq(ratherToken.balanceOf(msg.sender), INITIAL_SUPPLY - TRANSFER_AMOUNT);
        assertEq(ratherToken.balanceOf(user1), TRANSFER_AMOUNT);
    }

    // Ownership
}
