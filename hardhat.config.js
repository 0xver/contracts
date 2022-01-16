require("dotenv").config();
require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
require("hardhat-gas-reporter");

const PRIVATE_KEY = process.env.PRIVATE_KEY;
const NETWORK_API = process.env.NETWORK_API;
const ETHERSCAN_API = process.env.ETHERSCAN_API;

module.exports = {
  solidity: "0.8.0",
  networks: {
    hardhat: {
    },
    //network: {
      //url: NETWORK_API,
      //accounts: [PRIVATE_KEY],
    //}
  }
  //etherscan: {
    //apiKey: ETHERSCAN_API,
  //}
};
