# Airdrop Project – RatherToken (RDT)

A blockchain-based airdrop system for distributing ERC20 tokens using Merkle tress and smart contracts.

## 🚀 Project Overview

RatherToken (RDT) is an ERC20 token distributed through a decentralized airdrop system. The system is designed to:

- Allow users to **claim partial amounts** of their allocated tokens whenever they choose.
- Offer administrators real-time **analytics** and **control**, including:
  - Total claimed vs total allocated tokens.
  - Recent token claim activity.
  - The ability to **pause/resume** the airdrop.

## 🛠️ Tech Stack

| Layer       | Technology                 |
|-------------|-----------------------------|
| Smart Contracts | Solidity, OpenZeppelin, Foundry |
| Frontend    | React, Next.js, Tailwind |
| Tooling     | Anvil, GitHub Actions |

## 🔐 Smart Contracts

The system will consist of:

### ✅ RatherToken (ERC20) - RDT
### ✅ RatherAirdrop 

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


## Instalation

```
# Clone the repository
git clone git@github.com:wmachaca/airdrop-project.git
cd airdrop-project

# Install Foundry (if not already)
curl -L https://foundry.paradigm.xyz | bash
foundryup

# Install dependencies (e.g., OpenZeppelin)
forge install

# (Alternative) Install from submodules
git submodule update --init --recursive

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

### Generate Abi.json

```shell
$ forge inspect RatherAirdrop abi --json > abi/airdropAbi.json
```

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