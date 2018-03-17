pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol';

contract ExampleNFT is ERC721Token {
    uint256 public tokenCount;

    function createFor(address _to) public {
        _mint(_to, tokenCount);
        tokenCount = tokenCount + 1;
    }
}
