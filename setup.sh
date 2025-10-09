#!/bin/bash

set -e

echo "🔍 Checking for Foundry installation..."
if ! command -v forge &> /dev/null; then
    echo "❌ Foundry not found. Installing Foundry..."
    curl -L https://foundry.paradigm.xyz | bash
    foundryup
else
    echo "✅ Foundry is installed."
fi

echo "🔗 Installing dependencies (OpenZeppelin, etc.)..."
forge install
git submodule update --init --recursive

echo "📄 Generating input data for Merkle tree..."
forge script script/GenerateInput.s.sol:GenerateInput --silent
echo "✅ Input file generated."

echo "🌳 Building Merkle tree and proofs..."
forge script script/MakeMerkle.s.sol:MakeMerkle --silent
echo "✅ Merkle tree and proofs generated."

echo "🧪 Running unit tests..."
forge test
echo "✅ All tests completed successfully."

echo "📦 Exporting RatherAirdrop ABI for frontend..."
mkdir -p abi
forge inspect RatherAirdrop abi --json > abi/airdropAbi.json
echo "✅ ABI exported to abi/airdropAbi.json."

echo "🚀 Setup complete! You can now deploy contracts or start the frontend."