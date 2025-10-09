//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {RatherAirdrop} from "../contracts/RatherAirdrop.sol";
import {RatherToken} from "../contracts/RatherToken.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {stdJson} from "forge-std/StdJson.sol";

contract RatherAirdropTest is Test {
    using stdJson for string;

    RatherAirdrop public ratherAirdrop;
    RatherToken public ratherToken;

    bytes32 public ROOT;
    uint256 public INITIAL_SUPPLY = 1000 * 1e18;
    uint256 public TOTAL_CLAIM = 25 * 1e18;
    uint256 public AMOUNT_TO_SEND = 4 * TOTAL_CLAIM;
    bytes32[] public PROOF;

    //address user = 0x6CA6d1e2D5347Bfab1d91e883F1915560e09129D;
    //address user;
    address user=0x99E97638276C46883e7730bF37091F807Ed08215; // test1 metamask
//uint256 userPrivKey;

    function setUp() public {
        (ROOT, PROOF) = getUserAirdropData(user);

        ratherToken = new RatherToken(INITIAL_SUPPLY);
        ratherAirdrop = new RatherAirdrop(ROOT, ratherToken, AMOUNT_TO_SEND);
        ratherToken.transfer(address(ratherAirdrop), AMOUNT_TO_SEND); // the airdrop has the token
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

function getUserAirdropData(address _user) internal view returns (bytes32 root, bytes32[] memory proof) {
    string memory rootPath = vm.projectRoot();
    string memory outputPath = string.concat(rootPath, "/script/target/output.json");
    
    console.log("Looking for file at:", outputPath);
    
    // Read the file - this returns a string that can be used directly with stdJson
    string memory json = vm.readFile(outputPath);
    
    // Debug: check if we actually read something
    bytes memory jsonBytes = bytes(json);
    console.log("File content length:", jsonBytes.length);
    
    if (jsonBytes.length == 0) {
        revert("JSON file is empty");
    }
    
    // Use the json string DIRECTLY with stdJson - no need for vm.parseJson()
    for (uint256 i = 0; i < 4; i++) {
        string memory basePath = string.concat("$[", vm.toString(i), "]");
        address addr = json.readAddress(string.concat(basePath, ".inputs[0]"));
        
        if (addr == _user) {
            root = json.readBytes32(string.concat(basePath, ".root"));
            proof = json.readBytes32Array(string.concat(basePath, ".proof"));
            
            console.log("Found user with root:", vm.toString(root));
            console.log("Proof length:", proof.length);
            
            return (root, proof);
        }
    }
    
    revert(string(abi.encodePacked("User ", vm.toString(_user), " not found in airdrop data")));
}
}
