/* global artifacts */

const Castle = artifacts.require('Castle')
const Moogle = artifacts.require('Moogle')

module.exports = function (deployer, network, accounts) {
  var creator = accounts[0]

  const numCastles = 5
  const numMoogles = 10

  var castle, moogle
  // give castles to the second account
  Castle.deployed().then(instance => {
    castle = instance
    return mint(castle, accounts[0], numCastles, creator)
  }).then(() => {
    // give some moogles to the third account
    return Moogle.deployed().then(instance => {
      moogle = instance
      return mint(moogle, accounts[1], numMoogles, creator)
    })
  // }).then(() => {
  //   // list balances
  //   return moogle.balanceOf(accounts[1])
  // }).then(balance => {
  //   console.log(`account 2 moogles: ${balance.toString()}`)
  // }).then(() => {
  //   return castle.balanceOf(accounts[0])
  // }).then(balance => {
  //   console.log(`account 1 castles: ${balance.toString()}`)
  }).catch(function(e) {
    console.log(e)
  })
}

function mint(token, account, count, creator) {
  let tokenMintingCalls = []
  for (var i = 0; i < count; i++) {
    tokenMintingCalls.push(
      token.createFor(account, {from: creator})
    )
  }
  return Promise.all(tokenMintingCalls)
}
