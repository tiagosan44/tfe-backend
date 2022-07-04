//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./DroneNFT.sol";
import "./ParcelNFT.sol";
import "./FDToken.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract Core is IERC721Receiver, Ownable {
    address public droneContract;
    address public parcelContract;
    DroneNFT public immutable droneInstance;
    ParcelNFT public immutable parcelInstance;

    constructor() Ownable() {
        droneContract = address(new DroneNFT(10));
        parcelContract = address(new ParcelNFT(20));
        droneInstance = DroneNFT(droneContract);
        parcelInstance = ParcelNFT(parcelContract);
    }

    struct job {
        uint256 parcelId;
        hiringStatus status;
    }

    mapping(uint256 => job) public jobList;

    enum hiringStatus { UNASIGNED, ASIGNED, DONE }
    event AsignedDrone(uint256 droneId, uint256 parcelId);
    event ExecutedJob(uint256 droneId, uint256 parcelId, hiringStatus);

    function registerDrone(uint256 maxHigh, uint256 minHigh, uint256 flightCost, uint256[] memory listPesticides) 
    validateHeigh(maxHigh, minHigh) onlyOwner external returns (uint256) {
        uint256 tokenId = droneInstance.mint(maxHigh, minHigh, flightCost, listPesticides );
        return tokenId;
    }

    function registerParcel(address to, uint256 maxHigh, uint256 minHigh, uint256 pesticide) 
    validateHeigh(maxHigh, minHigh) external returns (uint256 result) {
        uint256 tokenId = parcelInstance.mint(to, maxHigh, minHigh, pesticide);
        return tokenId;
    }

    function asignDrone(uint256 droneId, uint256 parcelId) droneAvailability(droneId) external returns (bool) {
         
        require (matchDroneParcel(droneId, parcelId), "Drone is not compatible with requirements");
        jobList[droneId].parcelId = parcelId;
        jobList[droneId].status   = hiringStatus.ASIGNED;
        emit AsignedDrone(droneId, parcelId);
        return true;
    }

    function matchDroneParcel (uint256 droneId, uint256 parcelId) public view returns (bool result)
    {
        if (droneInstance.getMinHight(droneId) > parcelInstance.getMaxHight(parcelId))
            return false;

        if (parcelInstance.getMinHight(parcelId) > droneInstance.getMaxHight(droneId))
            return false;

        uint256[] memory pesticides =  droneInstance.getListPesticides(droneId);
        uint256 parcelPesticide =  parcelInstance.getpesticide(parcelId);

        if (pesticides.length < 0){
            return false;
        }
        for (uint256 i = 0; i < pesticides.length ; i++) {
            if (pesticides[i] == parcelPesticide ) {
                return true;
            }
        }            
        return false;
    }

    function executeJob (uint256 droneId, uint256 parcelId) external onlyOwner checkDroneJob(droneId, parcelId) returns (bool result) {
        jobList[droneId].status= hiringStatus.DONE;  
        emit ExecutedJob(droneId, parcelId, jobList[droneId].status);
        return true;
    }

    modifier checkDroneJob(uint256 droneId, uint256 parcelId) {
        require(jobList[droneId].parcelId == parcelId, "Drone is asigned to other parcel");
        require(jobList[droneId].status == hiringStatus.ASIGNED, "Drone doesn't have an assigned job");
        _;
    }

    modifier droneAvailability(uint256 droneId) {
        require(jobList[droneId].status != hiringStatus.ASIGNED, "Drone is already asigned");
        _;
    }

    modifier validateHeigh(uint256 maxHigh, uint256 minHigh) {
        require(maxHigh > minHigh, "Inconsistent height values");
        _;
    }

    function parcelsByOwner(address owner) external view returns (uint[] memory) {
        uint256 balance = parcelInstance.balanceOf(owner);
        uint256[] memory parcels = new uint256[](balance);

        for (uint256 i=0; i < balance; i++) {
            parcels[i] = (parcelInstance.tokenOfOwnerByIndex(owner, i));
        }
        return parcels;
    }

    function getDroneData(uint256 droneId)  external view returns ( uint256 maxHigh, uint256 minHigh, uint256 flightCost, uint256[] memory listPesticides) {
        return (droneInstance.getDronData(droneId));
    }

    function getDroneState(uint256 droneId) external view returns (hiringStatus) {
        return (jobList[droneId].status);
    }

    function getParcelData(uint256 parcelId) external view returns (uint256 maxHigh, uint256 minHigh, uint256 pesticide, address owner) {
        return (parcelInstance.getParcelData(parcelId));

    }

    function getPesticidesDrone(uint256 droneId) external view returns(uint256[] memory pesticides)  {
        return (droneInstance.getListPesticides(droneId));
    }

    function totalDrones() external view returns(uint256)  {
        return (droneInstance.getCurrentIndex());
    }

    function totalParcels() external view returns(uint256)  {
        return (parcelInstance.getCurrentIndex());
    }

    function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
        override public returns (bytes4)  {
            return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
    }
}
