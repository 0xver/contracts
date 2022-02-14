# contract-lib

![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)

## An Ethereum smart contract library with IPFS integration

Use this library to reference ERC standards and example implementations of their functions. Edit any smart contract in `contracts/` and use the template contracts `MyERC20Token.sol` or `MyERC721Token.sol` to extend ERC contracts.

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
Navigate to `contracts/` and create a smart contract using `MyERC20Token.sol` or `MyERC721Token.sol`
```
cd contract-lib && open .
```

### Compile
Run the command to compile `MyERC20Token.sol` or `MyERC721Token.sol`
```
npx hardhat compile
```

### Test
Run the command to test `MyERC20Token.sol` or `MyERC721Token.sol` using `test/hardhat.test.js`
```
npx hardhat test
```

### Deploy
Run the command to deploy `MyERC20Token.sol` or `MyERC721Token.sol` using `scripts/deploy.js`
```
npx hardhat run scripts/deploy.js --network <network>
```

### Verify
Run the command to verify `MyERC20Token.sol` or `MyERC721Token.sol` on Etherscan
```
npx hardhat verify --network <network> <contract-address> "Constructor argument 1"
```