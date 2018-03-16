/* global describe it beforeEach artifacts */

import { expect } from 'chai'

const ShrimpCoin = artifacts.require('ShrimpCoin')

/* import moment from 'moment'
import lkTestHelpers from 'lk-test-helpers'
import { web3 } from 'helpers/w3'

const { increaseTime, latestTime } = lkTestHelpers(web3)

const { accounts } = web3.eth */

describe('ShrimpCoin', () => {
  let shrmp
  beforeEach(async () => {
    shrmp = await newShrimpCoin()
  })
  it('should have a shrimpy symbol', async () => {
    expect(await shrmp.symbol.call()).to.equal('SHRMP')
  })
})

async function newShrimpCoin () {
  const shrmp = await tryAsync(ShrimpCoin.new())
  return shrmp
}

async function tryAsync (asyncFn) {
  try {
    return await asyncFn
  } catch (err) {
    console.error(err)
  }
}
