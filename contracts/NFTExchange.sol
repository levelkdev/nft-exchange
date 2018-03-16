pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/math/SafeMath.sol';
import 'zeppelin-solidity/contracts/token/ERC721/ERC721.sol';

contract NFTExchange {
  using SafeMath for uint256;

  event _ListingCreated(uint256 listingId, address creator, address token, uint256 tokenId, uint256 expirationTime);

  struct Listing {
    address owner;
    ERC721 token;
    uint256 tokenId;
    uint256 expirationTime;
  }

  struct Offer {
    uint256 listingId;
    address owner;
    ERC721 token;
    uint256 tokenId;
  }

  uint256 _listingsCount;

  mapping(uint256 => Listing) public _listings;

  // hash of (token, tokenId)
  mapping(bytes32 => Offer) public _offers;

  // listingId => [bytes32_offer_hash, bytes32_offer_hash, bytes32_offer_hash]
  // mapping(uint256 => bytes32[]) public _offersByListing;



  modifier isActive(uint256 listingId) {
    require(_listings[listingId].expirationTime > now);
    _;
  }
  
  function NFTExchange() public {

  }

  function createListing(ERC721 token, uint256 tokenId, uint256 expirationTime) public {
    require(tokenId != 0);
    require(address(token) != 0x0);
    require(expirationTime > now);
  
    uint256 listingId = _listingsCount;
    _listings[listingId] = Listing(
      msg.sender,
      token,
      tokenId,
      expirationTime
    );
    _listingsCount = _listingsCount.add(1);
    token.takeOwnership(tokenId);
  
    _ListingCreated(listingId, msg.sender, address(token), tokenId, expirationTime);
  }

  function makeOffer(uint256 listingId, ERC721 token, uint256 tokenId) public isActive(listingId) {
    Listing memory listing = _listings[listingId];
    require(listingId < _listingsCount);
    require(msg.sender != listing.owner);

    Offer offer = Offer(
      listingId,
      msg.sender,
      token,
      tokenId
    );
  }

  function acceptOffer() public {

  }

  function withdraw() public {

  }

}
