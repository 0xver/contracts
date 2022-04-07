# contract-lib

[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/0xver/contract-lib/blob/master/LICENSE.md)

## An Ethereum smart contract library with IPFS integration

Use this library to reference ERC standards and example implementations of their functions. Edit any smart contract in `contracts/` and use the template contracts `MyERC20Token.sol`, `MyERC721Token.sol`, or `MyERC1155Token.sol` to extend ERC contracts.

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
Navigate to `contracts/` and create a smart contract using `MyERC20Token.sol`, `MyERC721Token.sol`, or `MyERC1155Token.sol`
```
cd contract-lib && open .
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