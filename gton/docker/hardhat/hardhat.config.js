require('dotenv').config()

const isForkModeEnabled = !!process.env.FORK_URL
const forkUrl = process.env.FORK_URL
const forkStartingBlock =
  parseInt(process.env.FORK_STARTING_BLOCK, 10) || undefined
const gasPrice = parseInt(process.env.GAS_PRICE, 10) || 0

const config = {
  networks: {
    'goerli-gton': {
      chainId: 5,
      url: process.env.CONTRACTS_RPC_URL || '',
      deploy,
      accounts: [privateKey],
    },
    'private-bsc': {
      chainId: 1214,
      url: process.env.CONTRACTS_RPC_URL || '',
      deploy,
      accounts: [privateKey],
    },
  },
  analytics: { enabled: false },
}

module.exports = config