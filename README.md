# Airdrop Project – RatherToken (RDT)

A blockchain-based airdrop system for distributing ERC20 tokens.

## 🚀 Project Overview

A blockchain company is launching a new ERC20 token — `RatherToken (RDT)` — and distributing it via an airdrop to eligible community members. This system is designed to:

- Allow users to **claim partial amounts** of their allocated tokens whenever they choose.
- Offer administrators real-time **analytics** and **control**, including:
  - Total claimed vs total allocated tokens.
  - Recent token claim activity.
  - The ability to **pause/resume** the airdrop.

## 🛠️ Tech Stack

| Layer       | Technology                 |
|-------------|-----------------------------|
| Smart Contracts | Solidity, OpenZeppelin, Foundry |
| Frontend    | React, Next.js, Tailwind (planned) |
| Tooling     | Anvil, GitHub Actions |

## 🔐 Smart Contracts

The system will consist of:

### ✅ RatherToken (ERC20)
### ✅ RatherAirdrop 

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

### Anvil

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
├── script/             # Deployment scripts
├── test/               # Unit tests
├── lib/                # External libraries (e.g., OpenZeppelin)
├── foundry.toml        # Foundry project config
└── .env                # Environment variables (not committed)

```