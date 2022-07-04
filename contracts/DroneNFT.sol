//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract DroneNFT is ERC721, ERC721Enumerable, Ownable {

    uint256 public maxSupply;
    using Counters for Counters.Counter;
    using Strings for uint256;
    Counters.Counter private _idCounter;
    
    struct DronData {
        uint256 maxHigh;
        uint256 minHigh;
        uint256 flightCost;
        uint256[] listPesticides;
    }

    mapping(uint256 => DronData) dronList;

    constructor(uint256 _maxSupply) ERC721("Dron NFT", "DNFT") Ownable() {
        maxSupply = _maxSupply;
    }

    function mint(uint256 maxHigh, uint256 minHigh, uint256 flightCost, uint256[] memory listPesticides) onlyOwner public returns (uint256 droneId) {
        uint256 current = _idCounter.current();
        require(current < maxSupply, "No drones left");
        _safeMint(msg.sender, current);
        buildDrone(current, maxHigh, minHigh, flightCost, listPesticides);
        _idCounter.increment();
        return current;
    }

    function buildDrone(uint256 current, uint256 maxHigh, uint256 minHigh, uint256 flightCost, uint256[] memory listPesticides) public {
        dronList[current].maxHigh       = maxHigh;
        dronList[current].minHigh       = minHigh;
        dronList[current].flightCost    = flightCost;
        
        for(uint256 i = 0; i< listPesticides.length; i++){      
            dronList[current].listPesticides.push(listPesticides[i]);
        }
    }

    function getDronData(uint256 droneId) public view returns (
        uint256 maxHigh,
        uint256 minHigh,
        uint256 flightCost,
        uint256[] memory listPesticides)
    {
           return (dronList[droneId].maxHigh,    
                dronList[droneId].minHigh,    
                dronList[droneId].flightCost,
                dronList[droneId].listPesticides);
    }

    function getCurrentIndex() public view returns (uint256)
    {
        return _idCounter.current();
    }

    function getMaxHight(uint256 droneId) public view returns (uint256 maxHigh) {
        return (dronList[droneId].maxHigh);
    }

    function getMinHight(uint256 droneId) public view returns (uint256 minHigh) {
        return (dronList[droneId].minHigh);
    }

    function getFlightCost(uint256 droneId) public view returns (uint256 flightCost) {
        return (dronList[droneId].flightCost);
    }

    function getListPesticides(uint256 droneId) public view returns(uint256[] memory listPesticides) {
        return (dronList[droneId].listPesticides);
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
