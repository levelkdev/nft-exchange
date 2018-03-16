pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/token/MintableToken.sol';

contract ShrimpCoin is MintableToken {
	string public constant name = "Shrimp Coin";
	string public constant symbol = "SHRMP";
	uint8 public constant decimals = 18;
}
