/* global artifacts */

const NFTExchange = artifacts.require('NFTExchange')

module.exports = function (deployer) {
  deployer.deploy(
    NFTExchange
  )
}
