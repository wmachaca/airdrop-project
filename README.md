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

## Instalation

```
# Clone the repository
git clone git@github.com:wmachaca/airdrop-project.git
cd airdrop-project

```bash
chmod +x setup.sh
./setup.sh
```


## Merkle Tree

### Generate Input

```shell
$ forge script script/GenerateInput.s.sol:GenerateInput
```

### Build Merkle Tree

```shell
$ forge script script/MakeMerkle.s.sol:MakeMerkle
```

---

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
$ forge test --match-test testRecoverUnclaimedTokensAfterPause -vv
```

### Use `setuptest.sh`
The `setuptest.sh` script automates the generation of PROOF files and runs the tests:
```bash
./setuptest.sh
```

### Format

```shell
$ forge fmt
$ npm run format
$ npm run lint
```

### Local Blockchain (Anvil)

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/DeployRatherToken.s.sol:DeployRatherToken --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```

### Generate Abi.json for frontend

```shell
$ forge inspect RatherAirdrop abi --json > abi/airdropAbi.json
```

---

## Sepolia Deployment

The contracts have been deployed to the Sepolia testnet:

| Contract         | Address                                                                 |
|------------------|-------------------------------------------------------------------------|
| **RatherAirdrop**    | [`0x697F9b3ea7ab4F955127D37C8ED2A59876357e40`](https://sepolia.etherscan.io/address/0x697F9b3ea7ab4F955127D37C8ED2A59876357e40) |
| **RatherToken (RDT)**| [`0xe67DB62bF604A5E4c83dc7edF063cAA7EbC5DFE6`](https://sepolia.etherscan.io/address/0xe67DB62bF604A5E4c83dc7edF063cAA7EbC5DFE6) |

---

The contracts were deployed using **Foundry** with the following command:

```
forge script script/DeployRatherAirdrop.s.sol \
  --broadcast \
  --rpc-url $RPC_URL_SEPOLIA \
  --private-key $PRIVATE_KEY_SEPOLIA_ACCOUNT1
```

---

## 🧪 Testing Locally with Anvil

### Step 1: Run Anvil
Start a local blockchain using Anvil:
```bash
anvil
```

### Step2: Deploy Contracts
Deploy the `RatherAirdrop` and `RatherToken` contracts locally:
```bash
forge script script/DeployRatherAirdrop.s.sol --broadcast --rpc-url $RPC_URL --private-key $PRIVATE_KEY_ANVIL
```

This will create two contracts:
- **RatherAirdrop**: `0xAirdropAddress`
- **RatherToken**: `0xTokenAddress`

### Step 3: Configure MetaMask for Anvil
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

###  Step 4: Interact with RatherToken

#### Total Supply
```bash
cast call 0xTokenAddress "totalSupply()" --rpc-url $RPC_URL | cast --to-dec | xargs -I {} cast --to-unit {} ether
```

#### Balance of Owner
```bash
cast call 0xTokenAddress "balanceOf(address)" 0xYourAddress --rpc-url $RPC_URL | cast --to-dec | xargs -I {} cast --to-unit {} ether
```

#### Transfer Tokens
```bash
cast send 0xTokenAddress "transfer(address,uint256)" 0xRecipientAddress 1000000000000000000 --private-key $PRIVATE_KEY_ANVIL --rpc-url $RPC_URL
```

---

### Step 5: Interact with RatherAirdrop

#### Claim Tokens
```bash
cast send 0xAirdropAddress "claim(address,uint256,uint256,bytes32[])" 0xYourAddress 1000000000000000000 500000000000000000 "[]" --private-key $PRIVATE_KEY_ANVIL --rpc-url $RPC_URL
```

#### Pause Airdrop
```bash
cast send 0xAirdropAddress "pauseAirdrop()" --private-key $PRIVATE_KEY_ANVIL --rpc-url $RPC_URL
```

#### Unpause Airdrop
```bash
cast send 0xAirdropAddress "unpauseAirdrop()" --private-key $PRIVATE_KEY_ANVIL --rpc-url $RPC_URL
```

#### Recover Unclaimed Tokens
```bash
cast send 0xAirdropAddress "recoverUnclaimedTokens()" --private-key $PRIVATE_KEY_ANVIL --rpc-url $RPC_URL
```

#### Get Airdrop Status
```bash
cast call 0xAirdropAddress "getAirdropStatus()" --rpc-url $RPC_URL
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