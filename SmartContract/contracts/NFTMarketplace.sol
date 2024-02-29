// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

// Internal import for  nft openzeppelin
// URI storage
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
// ERC721 storage
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// Import for nft marketplace
import "@openzeppelin/contracts/access/Ownable.sol";

import "hardhat/console.sol";

// NFTMarketplace contract
contract NFTMarketplace is ERC721URIStorage {
  uint256 private _tokenIds;
  uint256 private _itemsSold;

  uint256 public listingPrice = 0.025 ether;

  address payable owner;

  mapping (uint256 => MarketItem) private idMarketItem;

  struct MarketItem {
    uint256 tokenId;
    address payable seller;
    address payable owner;
    uint256 price;
    bool sold;
  }

  event MarketItemCreated(
    uint256 indexed tokenId,
    address seller,
    address owner,
    uint256 price,
    bool sold
  );

  constructor() ERC721("NFT Metaverse Token", "MYNFTM") {
    owner = payable(msg.sender);
  }

  modifier onlyOwner() {
    require(msg.sender == owner, "Only owner can call this function");
    _;
  }

  modifier onlySeller(uint256 tokenId) {
    require(msg.sender == idMarketItem[tokenId].seller, "Only seller can call this function");
    _;
  }

  function updateListingPrice(uint256 _listingPrice) public payable onlyOwner {
    _listingPrice = _listingPrice;
  }

  function getListingPrice() public view returns (uint256) {
    return listingPrice;
  }

  // CREATE MARKET ITEM FUNCTION
  function createMarketItem(uint256 tokenId, uint256 price) private {
    require(price > 0, "Price must be at least 1");
    require(msg.value == listingPrice, "Price must be equal to listing price");

    idMarketItem[tokenId] = MarketItem(
      tokenId,
      payable(msg.sender),
      payable(address(this)),
      price,
      false
    );

    _transfer(msg.sender, address(this), tokenId);

    emit MarketItemCreated(tokenId, msg.sender, address(this), price, false);
  }

  // CREATE NFT TOKEN FUNTION
  function createToken(string memory tokenURI, uint256 price) public payable returns(uint256) {
    _tokenIds++;
    uint256 tokenId = _tokenIds;

    _mint(msg.sender, tokenId);
    _setTokenURI(tokenId, tokenURI);
    createMarketItem(tokenId, price);

    return tokenId;
  }

  // RESALE NFT TOKEN FUNCTION
  function resaleToken(uint256 tokenId, uint256 price) public payable onlySeller(tokenId){
    require(idMarketItem[tokenId].owner == msg.sender, "Only owner can resale the token");
    require(msg.value == listingPrice, "Price must be equal to listing price");

    idMarketItem[tokenId].sold = false;
    idMarketItem[tokenId].price = price;
    idMarketItem[tokenId].seller = payable(msg.sender);
    idMarketItem[tokenId].owner = payable(address(this));
    _itemsSold--;
    _transfer(msg.sender, address(this), tokenId);
  }

  // CREATE MARKET SALE FUNCTION
  function createMarketSale(uint256 tokenId) public payable {
    MarketItem memory item = idMarketItem[tokenId];
    uint256 price = item.price;
    require(msg.value == price, "Please submit the asking price in order to complete the purchase");

    item.sold = true;
    item.seller = payable(msg.sender);
    item.owner = payable(address(this));
    _itemsSold++;
    _transfer(address(this), msg.sender, tokenId);
    payable(owner).transfer(listingPrice);
    payable(item.seller).transfer(msg.value);
    idMarketItem[tokenId] = item;
  }

  // GETTITNG UNSOLD NFT DATA
  function fetchMarketItem() public view returns(MarketItem[] memory items) {
    uint256 itemCount = _tokenIds;
    uint256 unsoldItemCount = _tokenIds - _itemsSold;
    uint256 currentIndex = 0;

    items = new MarketItem[](unsoldItemCount);
    for (uint256 i = 0; i < itemCount; i++) {
      if (idMarketItem[i + 1].owner == address(this)) {
        uint256 currentId = i+1;
        MarketItem storage currentItem = idMarketItem[currentId];
        items[currentIndex] = currentItem;
        currentIndex += 1;
      }
    }
    return items;
  }

  // PURCHASE ITEM
  function fetchMyNft() public view returns(MarketItem[] memory items) {
    uint256 itemCount = _tokenIds;
    uint256 currentIndex = 0;

    for (uint256 i = 0; i < itemCount; i++) {
      if (idMarketItem[i + 1].owner == msg.sender) {
        itemCount++;
      }
    }
    items = new MarketItem[](itemCount);
    for (uint256 i = 0; i < itemCount; i++) {
      if (idMarketItem[i + 1].owner == msg.sender) {
        uint256 currentId = i+1;
        MarketItem storage currentItem = idMarketItem[currentId];
        items[currentIndex] = currentItem;
        currentIndex++;
      }
    }
    return items;
  }

}