# Contracts

[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/0xver/contracts/blob/master/LICENSE.md)

## An Ethereum smart contract library for common standards

Use this library to reference ERC standards and example implementations of their functions. Edit any smart contract in `contracts/` and use the template contracts `MyERC20Token.sol`, `MyERC721Token.sol`, or `MyERC1155Token.sol` to extend ERC contracts.

# Installation
Clone contracts
```
gh repo clone 0xver/contracts
```
Install packages
```
npm install
```

# Usage
### Getting Started
Navigate to `contracts/` and create a smart contract using `MyERC20Token.sol`, `MyERC721Token.sol`, or `MyERC1155Token.sol`
```
cd contracts && open .
```

### Compile
Run the command to compile `MyERC20Token.sol`, `MyERC721Token.sol`, or `MyERC1155Token.sol`
```
npx hardhat compile
```

### Test
Run the command to test `MyERC20Token.sol`, `MyERC721Token.sol`, or `MyERC1155Token.sol` using `test/hardhat.test.js`
```
npx hardhat test
```