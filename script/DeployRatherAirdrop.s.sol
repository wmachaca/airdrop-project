//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {RatherAirdrop} from "../contracts/RatherAirdrop.sol";
import {RatherToken} from "../contracts/RatherToken.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {stdJson} from "forge-std/StdJson.sol";

contract DeployRatherAirdrop is Script {
    using stdJson for string; // Enable stdJson functions for strings

uint256 private s_amountToTransfer = 8 * 25 * 1e18;
    uint256 private initialSupply = 2000 * 1e18;

/// @dev Reads the Merkle root from the output.json file
    function getMerkleRootFromJson() internal view returns (bytes32) {
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

        // Use stdJson to extract the root from the first entry in the JSON array
string memory basePath = "$[0]"; // Access the first object in the array
        bytes32 root = json.readBytes32(string.concat(basePath, ".root"));

        console.log("Merkle root found:", vm.toString(root));
        return root;
    }

    /// @dev Deploys the RatherAirdrop and RatherToken contracts
    function deployRatherAirdrop() public returns (RatherAirdrop, RatherToken) {    
        bytes32 s_merkleRoot = getMerkleRootFromJson();

        vm.startBroadcast();
        RatherToken token = new RatherToken(initialSupply);
        RatherAirdrop airdrop = new RatherAirdrop(s_merkleRoot, IERC20(address(token)), s_amountToTransfer);
                token.transfer(address(airdrop), s_amountToTransfer);
        vm.stopBroadcast();

        console.log("RatherToken deployed at:", address(token));
        console.log("RatherAirdrop deployed at:", address(airdrop));

        return (airdrop, token);
    }

    /// @dev Entry point for the script
    function run() external returns (RatherAirdrop, RatherToken) {    
        return deployRatherAirdrop();
    }
}