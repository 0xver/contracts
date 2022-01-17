# contract-lib

![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg) ![build](https://github.com/ntkme/github-buttons/workflows/build/badge.svg)

## An Ethereum smart contract library with IPFS integration

Use this library to reference ERC standards and example implementations of their functions. Edit any smart contract in `contracts/` and use the template contracts `MyFungibleToken.sol` or `MyNonFungibleToken.sol` to extend ERC contracts.

# Installation
Clone contract-lib
```
gh repo clone 0xver/contract-lib
```
Install packages
```
npm install
```

# Usage
### Getting Started
Navigate to `contracts/` and create a smart contract using `MyFungibleToken.sol` or `MyNonFungibleToken.sol`
```
cd contract-lib && open .
```

### Compile
Run the command to compile `MyFungibleToken.sol` or `MyNonFungibleToken.sol`
```
npx hardhat compile
```

### Test
Run the command to test `MyFungibleToken.sol` or `MyNonFungibleToken.sol` using `test/hardhat.test.js`
```
npx hardhat test
```

### Deploy
Run the command to deploy `MyFungibleToken.sol` or `MyNonFungibleToken.sol` using `scripts/deploy.js`
```
npx hardhat run scripts/deploy.js --network <network>
```

### Verify
Run the command to verify `MyFungibleToken.sol` or `MyNonFungibleToken.sol` on Etherscan
```
npx hardhat verify --network <network> <contract-address> "Constructor argument 1"
```