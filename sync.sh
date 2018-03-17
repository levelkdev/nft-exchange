#!/bin/sh
# assumes you are in top level and nft-frontent is next to nft-exchange
(cd .. &&\
    cp nft-exchange/build/contracts/NFTExchange.json nft-frontend/src/contracts)
