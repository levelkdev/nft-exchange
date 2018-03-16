pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/math/SafeMath.sol';
import 'zeppelin-solidity/contracts/token/ERC721/ERC721.sol';

contract NFTExchange {
  using SafeMath for uint256;

  event _TokenWrapped(address owner, address token, uint256 tokenId);
  event _TokenUnwrapped(address owner, address token, uint256 tokenId);
  event _SwapProposed(address offerTokenOwner, address askTokenOwner, address offerToken, address askToken, uint256 offerTokenId, uint256 askTokenId);
  event _ProposalCanceled(address offerTokenOwner, address askTokenOwner, address offerToken, address askToken, uint256 offerTokenId, uint256 askTokenId);
  event _SwapExecuted(address offerTokenOwner, address askTokenOwner, address offerToken, address askToken, uint256 offerTokenId, uint256 askTokenId);

  struct ExchangeToken {
    address owner;
    ERC721 token;
    uint256 tokenId;
  }

  struct ProposedSwap {
    bytes32 askToken;
    bytes32 offerToken;
  }

  mapping(bytes32 => ExchangeToken) public _tokens;
  mapping(bytes32 => ProposedSwap) public _proposedSwaps;

  function wrapToken(ERC721 token, uint256 tokenId) public {
    require(tokenId != 0);
    require(address(token) != 0x0);

    _tokens[keccak256(token, tokenId)] = ExchangeToken(
      msg.sender,
      token,
      tokenId
    );

    token.takeOwnership(tokenId);

    _TokenWrapped(msg.sender, address(token), tokenId);
  }

  function unwrapToken(bytes32 tokenHash) public {
    ExchangeToken storage exchangeToken = _tokens[tokenHash];
    require(exchangeToken.owner == msg.sender);

    _tokens[tokenHash] = ExchangeToken(0x0, ERC721(0x0), 0);
    exchangeToken.token.transfer(msg.sender, exchangeToken.tokenId);

    _TokenUnwrapped(msg.sender, address(exchangeToken.token), exchangeToken.tokenId);
  }

  function proposeSwap(bytes32 askTokenHash, bytes32 offerTokenHash) public {
    ExchangeToken storage askToken = _tokens[askTokenHash];
    ExchangeToken storage offerToken = _tokens[offerTokenHash];

    // token you're asking for has to be wrapped by some owner
    require(askToken.owner != 0x0);
  
    // you can only offer a token you own
    require(offerToken.owner == msg.sender);

    _proposedSwaps[keccak256(askTokenHash, offerTokenHash)] = ProposedSwap(askTokenHash, offerTokenHash);

    _SwapProposed(
      offerToken.owner,
      askToken.owner,
      address(offerToken.token),
      address(askToken.token),
      offerToken.tokenId,
      askToken.tokenId
    );
  }

  function cancelProposedSwap(bytes32 proposalHash) public {
    ProposedSwap storage proposal = _proposedSwaps[proposalHash];
    ExchangeToken storage askToken = _tokens[proposal.askToken];
    ExchangeToken storage offerToken = _tokens[proposal.offerToken];
    require(offerToken.owner == msg.sender);

    _clearProposedSwap(proposalHash);

    _ProposalCanceled(
      offerToken.owner,
      askToken.owner,
      address(offerToken.token),
      address(askToken.token),
      offerToken.tokenId,
      askToken.tokenId
    );
  }

  function acceptSwap(bytes32 proposalHash) public {
    ProposedSwap storage proposal = _proposedSwaps[proposalHash];
    ExchangeToken storage askToken = _tokens[proposal.askToken];
    ExchangeToken storage offerToken = _tokens[proposal.offerToken];
    require(offerToken.owner != 0x0);
    require(askToken.owner == msg.sender);

    // swap ownership
    address proposer = offerToken.owner;
    offerToken.owner = msg.sender;
    askToken.owner = proposer;

    _clearProposedSwap(proposalHash);

    _SwapExecuted(
      offerToken.owner,
      askToken.owner,
      address(offerToken.token),
      address(askToken.token),
      offerToken.tokenId,
      askToken.tokenId
    );
  }

  function _clearProposedSwap(bytes32 proposalHash) internal {
    _proposedSwaps[proposalHash] = ProposedSwap(0x0, 0x0);
  }

}
