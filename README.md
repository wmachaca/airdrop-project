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
| Tooling     | Anvil, GitHub Actions (planned) |

## 🔐 Smart Contracts

The system will consist of:

### ✅ RatherToken (ERC20)
### ✅ Airdrop

## Instalation

```
# Clone the repository
git clone git@github.com:wmachaca/airdrop-project.git
cd airdrop-project

# Install Foundry (if not already)
curl -L https://foundry.paradigm.xyz | bash
foundryup

# Install dependencies
forge install

```


## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
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