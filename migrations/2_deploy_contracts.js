/* global artifacts */

const NFTExchange = artifacts.require('NFTExchange')
const Castle = artifacts.require('Castle')
const Moogle = artifacts.require('Moogle')

module.exports = function (deployer) {
  deployer.deploy(
    NFTExchange
  )

  deployer.deploy(Castle)
  deployer.deploy(Moogle)
}
