#!/bin/bash

# Step 1: Generate the input file
forge script script/GenerateInput.s.sol:GenerateInput

# Step 2: Generate the Merkle tree and proofs
forge script script/MakeMerkle.s.sol:MakeMerkle

# Step 3: Run the tests
forge test
