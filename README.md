# Airdrop Project – RatherToken (RDT)

A blockchain-based airdrop system for distributing ERC20 tokens using Merkle trees and smart contracts.

---

## 🚀 Project Overview

RatherToken (RDT) is an ERC20 token distributed through a decentralized airdrop system. The system is designed to:

- Allow users to **claim partial amounts** of their allocated tokens whenever they choose.
- Offer administrators real-time **analytics** and **control**, including:
  - Total claimed vs total allocated tokens.
  - Recent token claim activity.
  - The ability to **pause/resume** the airdrop.
- Ensure **security** and **efficiency** using Merkle trees for proof verification.

---

## 🛠️ Tech Stack

| Layer       | Technology                 |
|-------------|-----------------------------|
| Smart Contracts | Solidity, OpenZeppelin, Foundry |
| Frontend    | React, Next.js, Tailwind |
| Tooling     | Anvil, Forge, Cast, GitHub Actions |

---

## 🔐 Smart Contracts

The system consists of:

### ✅ RatherToken (ERC20) - RDT
- A standard ERC20 token contract with an initial supply minted to the deployer.

### ✅ RatherAirdrop 

---

## Quick Start

### Automated Setup

```
# Clone the repository
git clone git@github.com:wmachaca/airdrop-project.git
cd airdrop-project

chmod +x setup.sh
./setup.sh

# Setup environment
cp .env.example .env
# Edit .env with your keys and RPC URLs
```

### Manual Setup
```
# Install Foundry
curl -L https://foundry.paradigm.xyz | bash
foundryup

# Install dependencies
forge install
git submodule update --init --recursive

# Setup environment
cp .env.example .env
# Edit .env with your keys and RPC URLs
```

## Development

### Build contracts

```
forge build
```

### Code quality
```bash
# Format Solidity
forge fmt

# Lint & Format (if using Node.js tools)
npm run format
npm run lint
```

### Merkle Tree management

``` bash
# Generate input data
forge script script/GenerateInput.s.sol:GenerateInput
# Build merkle tree & proofs
forge script script/MakeMerkle.s.sol:MakeMerkle

```

---

## Testing


### Test Suite

```bash
# Run all tests
forge test

# Run with detailed traces
forge test -vv

# Run specific test
forge test --match-test testClaimAllAtOnce
```

### Automated Test Suite

```bash
./setuptest.sh
```

---

## Deployment

### Local Development

```shell
# Start local blockchain
anvil

# Deploy to Anvil
forge script script/DeployRatherAirdrop.s.sol \
  --broadcast \
  --rpc-url http://127.0.0.1:8545 \
  --private-key $PRIVATE_KEY_ANVIL
```

### Sepolia Testnet

The contracts have been deployed to the Sepolia testnet:

| Contract         | Address                                                                 |
|------------------|-------------------------------------------------------------------------|
| **RatherAirdrop**    | [`0x697F9b3ea7ab4F955127D37C8ED2A59876357e40`](https://sepolia.etherscan.io/address/0x697F9b3ea7ab4F955127D37C8ED2A59876357e40) |
| **RatherToken (RDT)**| [`0xe67DB62bF604A5E4c83dc7edF063cAA7EbC5DFE6`](https://sepolia.etherscan.io/address/0xe67DB62bF604A5E4c83dc7edF063cAA7EbC5DFE6) |

The contracts were deployed using **Foundry** with the following command:

```bash
forge script script/DeployRatherAirdrop.s.sol \
  --broadcast \
  --rpc-url $RPC_URL_SEPOLIA \
  --private-key $PRIVATE_KEY_SEPOLIA_ACCOUNT1 \
  --verify \
  --etherscan-api-key $ETHERSCAN_API_KEY
```

### Deployment Verification in Anvil

#### Configure MetaMask for Anvil
1. Open MetaMask and add a new network:
   - **Network Name**: Anvil
   - **RPC URL**: `http://127.0.0.1:8545`
   - **Chain ID**: `31337`
2. Import the deployer's private key into MetaMask:
   - Use the private key from `.env` (`PRIVATE_KEY_ANVIL`).
   - This will show an account with `10000 ETH`.
3. Import the RatherToken (RDT) contract into MetaMask:
   - Open MetaMask → Assets → "Import Tokens".
   - Use the deployed RatherToken contract address.



#### Interact with RatherToken

```bash
# Total Supply
cast call 0xTokenAddress "totalSupply()" --rpc-url $RPC_URL | cast --to-dec | xargs -I {} cast --to-unit {} ether
# Balance of Owner
cast call 0xTokenAddress "balanceOf(address)" 0xYourAddress --rpc-url $RPC_URL | cast --to-dec | xargs -I {} cast --to-unit {} ether

# Transfer Tokens
cast send 0xTokenAddress "transfer(address,uint256)" 0xRecipientAddress 1000000000000000000 --private-key $PRIVATE_KEY_ANVIL --rpc-url $RPC_URL
```

#### Interact with RatherAirdrop

```bash
# Claim Tokens
cast send 0xAirdropAddress "claim(address,uint256,uint256,bytes32[])" 0xYourAddress 1000000000000000000 500000000000000000 "[]" --private-key $PRIVATE_KEY_ANVIL --rpc-url $RPC_URL

# Pause Airdrop
cast send 0xAirdropAddress "pauseAirdrop()" --private-key $PRIVATE_KEY_ANVIL --rpc-url $RPC_URL

# Unpause Airdrop
cast send 0xAirdropAddress "unpauseAirdrop()" --private-key $PRIVATE_KEY_ANVIL --rpc-url $RPC_URL

# Recover Unclaimed Tokens
cast send 0xAirdropAddress "recoverUnclaimedTokens()" --private-key $PRIVATE_KEY_ANVIL --rpc-url $RPC_URL

# Get Airdrop Status
cast call 0xAirdropAddress "getAirdropStatus()" --rpc-url $RPC_URL
```

---

### Frontend Integration: ABI Generation

```bash
forge inspect RatherAirdrop abi --json > abi/airdropAbi.json
```

---


## Project Structure

```
airdop-project/
│
├── contracts/          # Solidity smart contracts
│   └── RatherToken.sol
│   └── RatherAirdrop.sol
├── script/             # Deployment scripts
├── test/               # Unit tests
├── lib/                # External libraries (e.g., OpenZeppelin)
├── abi/                # ABI files for frontend integration
├── broadcast/          # Deployment logs
├── foundry.toml        # Foundry project config
└── .env                # Environment variables (not committed)

```