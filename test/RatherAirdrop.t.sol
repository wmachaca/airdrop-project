//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {RatherAirdrop} from "../contracts/RatherAirdrop.sol";
import {RatherToken} from "../contracts/RatherToken.sol";

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract RatherAirdropTest is Test {
    RatherAirdrop public ratherAirdrop;
    RatherToken public ratherToken;

    bytes32 public ROOT =
        0xa828cf1ba9a04d02a3c07c1c4e7e517fcc4b535b6b7c8e57abe51cb3f6384ef3;
    uint256 public INITIAL_SUPPLY = 1000 * 1e18;
    uint256 public TOTAL_CLAIM = 25 * 1e18;
    uint256 public AMOUNT_TO_SEND = 4 * TOTAL_CLAIM;
    bytes32 proofOne =
        0x22ac0728a4a2a6192b0cefcd609bba7a10eaf6ad3df112db08bdd37e5b2ffd87;
    bytes32 proofTwo =
        0xe5ebd1e1b5a5478a944ecab36a9a954ac3b6b8216875f6524caa7a1d87096576;
    bytes32[] public PROOF = [proofOne, proofTwo];

    //address user = 0x6CA6d1e2D5347Bfab1d91e883F1915560e09129D;
    //address user;
    address user=0x99E97638276C46883e7730bF37091F807Ed08215; // test1 metamask
    //uint256 userPrivKey;

    function setUp() public {
        ratherToken = new RatherToken(INITIAL_SUPPLY); //owner has the token
        ratherAirdrop = new RatherAirdrop(ROOT, ratherToken, AMOUNT_TO_SEND);
        ratherToken.transfer(address(ratherAirdrop), AMOUNT_TO_SEND);//the airdrop has the token
        //(user, userPrivKey) = makeAddrAndKey("user"); // generate address and userPrivKey for output
        //user2 = makeAddr("user2");
    }

    function pauseAirdrop() internal {
        vm.prank(ratherAirdrop.owner());
        ratherAirdrop.pauseAirdrop();
    }

    function unpauseAirdrop() internal {
        vm.prank(ratherAirdrop.owner());
        ratherAirdrop.unpauseAirdrop();
    }

    function testClaimAllAtOnce() public {
        console.log("user address:", user);
        //console.log("user address privkey:", vm.toString(userPrivKey));
        uint256 startingBalance = ratherToken.balanceOf(user);

        vm.prank(user);
        ratherAirdrop.claim(user, TOTAL_CLAIM, TOTAL_CLAIM, PROOF);

        uint256 endingBalance = ratherToken.balanceOf(user);

        console.log("Ending balance:", endingBalance);
        assertEq(endingBalance - startingBalance, TOTAL_CLAIM);
    }

    function testClaimInTwoParts() public {
        uint256 half = TOTAL_CLAIM / 2;

        vm.prank(user);
        ratherAirdrop.claim(user, TOTAL_CLAIM, half, PROOF);
        console.log("Half balance:", ratherToken.balanceOf(user));
        assertEq(ratherToken.balanceOf(user), half);

        vm.prank(user);
        ratherAirdrop.claim(user, TOTAL_CLAIM, half, PROOF);
        assertEq(ratherToken.balanceOf(user), TOTAL_CLAIM);
    }

    function testCannotClaimMoreThanAllowed() public {
        vm.prank(user);
        ratherAirdrop.claim(user, TOTAL_CLAIM, TOTAL_CLAIM, PROOF);
        vm.expectRevert("Exceeds eligible amount");
        vm.prank(user);
        ratherAirdrop.claim(user, TOTAL_CLAIM, 1, PROOF);
    }

    function testAirdropPausePreventsClaims() public {
        pauseAirdrop();

        vm.expectRevert("EnforcedPause()");
        vm.prank(user);
        ratherAirdrop.claim(user, TOTAL_CLAIM, TOTAL_CLAIM, PROOF);
    }

    function testOnlyOwnerCanPauseAirdrop() public {
        vm.prank(user);
        vm.expectRevert(
            abi.encodeWithSelector(
                Ownable.OwnableUnauthorizedAccount.selector,
                user
            )
        ); // more gas efficient
        ratherAirdrop.pauseAirdrop();
    }

    function testRecoverUnclaimedTokensAfterPause() public {
        uint256 contractBalanceBefore = ratherToken.balanceOf(
            address(ratherAirdrop)
        );

        vm.prank(user);
        ratherAirdrop.claim(user, TOTAL_CLAIM, TOTAL_CLAIM, PROOF);

        uint256 ownerBalanceBefore = ratherToken.balanceOf(address(this)); //test contract has 900
        console.log("owner balance before:", ownerBalanceBefore);

        pauseAirdrop();
        ratherAirdrop.recoverUnclaimedTokens(); //recover 75

        uint256 ownerBalanceAfter = ratherToken.balanceOf(address(this));
        assertEq(
            ownerBalanceAfter - ownerBalanceBefore,
            contractBalanceBefore - TOTAL_CLAIM
        );
    }

    function testRecoverFailsIfNotPaused() public {
        vm.expectRevert("ExpectedPause()");
        ratherAirdrop.recoverUnclaimedTokens();
    }

    function testGetRecentClaimers() public {
        vm.prank(user);
        ratherAirdrop.claim(user, TOTAL_CLAIM, TOTAL_CLAIM, PROOF);

        (address[] memory claimers, uint256[] memory amounts) = ratherAirdrop
            .getRecentClaimers(1);
        assertEq(claimers[0], user);
        assertEq(amounts[0], TOTAL_CLAIM);
    }

    function testGetAirdropStatus() public view {
        (
            uint256 total,
            uint256 claimed,
            uint256 remaining,
            bool paused
        ) = ratherAirdrop.getAirdropStatus();
        assertEq(total, AMOUNT_TO_SEND);
        assertEq(claimed, 0);
        assertEq(remaining, AMOUNT_TO_SEND);
        assertEq(paused, false);
    }

    function testGetMerkleRoot() public view {
        assertEq(ratherAirdrop.getMerkleRoot(), ROOT);
    }

    function testGetToken() public view {
        assertEq(
            address(ratherAirdrop.getAirdropToken()),
            address(ratherToken)
        );
    }
}
