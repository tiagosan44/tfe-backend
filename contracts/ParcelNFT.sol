//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract ParcelNFT is ERC721, ERC721Enumerable {

    uint256 public maxSupply;
    using Counters for Counters.Counter;
    using Strings for uint256;
    Counters.Counter private _idCounter;
    
    struct ParcelData {
        uint256 maxHigh;
        uint256 minHigh;
        uint256 pesticide;
    }

    mapping(uint256 => ParcelData) parcelList;

    constructor(uint256 _maxSupply) ERC721("Parcel NFT", "PNFT") {
        maxSupply = _maxSupply;
    }

    function mint(address to, uint256 maxHigh, uint256 minHigh, uint256 pesticide) public returns (uint256 parcelId) {
        uint256 current = _idCounter.current();
        require(current < maxSupply, "No parcels left");
        _safeMint(to, current);
        buildParcel(current, maxHigh, minHigh, pesticide);
        _idCounter.increment();
        return current;
    }

    function buildParcel(uint256 current, uint256 maxHigh, uint256 minHigh, uint256 pesticide) public {
        parcelList[current].maxHigh       = maxHigh;
        parcelList[current].minHigh       = minHigh;
        parcelList[current].pesticide     = pesticide;
    }

    function getParcelData(uint256 parcelId) public view returns (
        uint256 maxHigh,
        uint256 minHigh,
        uint256 pesticide,
        address owner)
    {
           return (parcelList[parcelId].maxHigh,    
                parcelList[parcelId].minHigh,
                parcelList[parcelId].pesticide,
                super.ownerOf(parcelId));
    }

    function getCurrentIndex() public view returns (uint256)
    {
        return _idCounter.current();
    }

    function getMaxHight(uint256 parcelId) public view returns (uint256 maxHigh) {
        return (parcelList[parcelId].maxHigh);
    }

    function getMinHight(uint256 parcelId) public view returns (uint256 minHigh) {
        return (parcelList[parcelId].minHigh);
    }

    function getpesticide(uint256 parcelId) public view returns(uint256 pesticide) {
        return (parcelList[parcelId].pesticide);
    }

    // Override required for ERC721 enumerable
    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }   
}
