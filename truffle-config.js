require('dotenv').config()

module.exports = {
  networks: {
    development: {
      host: process.env.HOST,
      port: process.env.PORT,
      network_id: "*" // Match any network id
    },
    advanced: {
      websockets: true,
    },
  },
  contracts_build_directory: './src/abis/',
  compilers: {
    solc: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  }
}
