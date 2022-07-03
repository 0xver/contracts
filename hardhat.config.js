require("@nomiclabs/hardhat-waffle")
require("hardhat-gas-reporter")

module.exports = {
  solidity: "0.8.4",
  networks: {
    hardhat: {
    }
  },
  gasReporter: {
    currency: "USD",
    gasPrice: 1
  }
}
