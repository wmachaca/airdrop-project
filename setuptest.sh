#!/bin/bash

set -e

echo "Step 1: Generating the input file..."
forge script script/GenerateInput.s.sol:GenerateInput --silent
echo "Input file generated successfully."

echo "Step 2: Generating the Merkle tree and proofs..."
forge script script/MakeMerkle.s.sol:MakeMerkle --silent
echo "Merkle tree and proofs generated successfully."

echo "Step 3: Running the tests..."
forge test
echo "All tests completed successfully."
