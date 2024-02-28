require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.24",
  networks: {
    sepolia: {
      url: process.env.INFURA_SEPOLIA_ENDPOINT,
      accounts: [process.env.PRIVATE_KEY],
    },
    hardhat: {
      chainId: 31337, // Hardhat Network Chain ID
      gas: 9500000,
      gasPrice: 8000000000,

    },
  },
};