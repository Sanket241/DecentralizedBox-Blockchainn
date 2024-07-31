// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { Math } from "@openzeppelin/contracts/utils/math/Math.sol";
import { EnumerableSet } from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

contract DecentralizedBox is Ownable {
    using EnumerableSet for EnumerableSet.AddressSet;

    error DecentralizedBox__AlreadyUploaded();
    error DecentralizedBox__IncorrectIdx();
    error DecentralizedBox__AlreadySubOwner();
    error DecentralizedBox__NotOwnerOrSubOwner();
    error DecentralizedBox__AlreadyNotSubOwner();

    mapping(string ipfsHash => bool) private s_isUploaded;
    EnumerableSet.AddressSet private s_subOwners;
    string[] private s_ipfsHashes;

    event HashUploaded(string indexed ipfsHash);

    modifier revertIfAlreadyUploaded(string memory _ipfsHash) {
        if (s_isUploaded[_ipfsHash]) {
            revert DecentralizedBox__AlreadyUploaded();
        }
        _;
    }

    modifier onlyOwnerOrSubOwner() {
        if (msg.sender != owner() && !s_subOwners.contains(msg.sender)) {
            revert DecentralizedBox__NotOwnerOrSubOwner();
        }
        _;
    }

    constructor() Ownable(msg.sender) {

    }

    function addSubOwner(address _subOwner) external onlyOwner {
        if (s_subOwners.contains(_subOwner)) {
            revert DecentralizedBox__AlreadySubOwner();
        }

        s_subOwners.add(_subOwner);
    }

    function removeSubOwner(address _subOwner) external onlyOwner {
        if (!s_subOwners.contains(_subOwner)) {
            revert DecentralizedBox__AlreadyNotSubOwner();
        }

        s_subOwners.remove(_subOwner);
    }

    function uploadHash(string memory _ipfsHash) external onlyOwnerOrSubOwner revertIfAlreadyUploaded(_ipfsHash) {
        s_isUploaded[_ipfsHash] = true;
        s_ipfsHashes.push(_ipfsHash);
        emit HashUploaded(_ipfsHash);
    }

    function getIpfsHashInRange(uint256 st, uint256 end) external view returns (string[] memory) {
        uint256 len = s_ipfsHashes.length;
        
        if (st >= len || st > end) {
            revert DecentralizedBox__IncorrectIdx();
        }
        
        end = Math.min(end, len - 1);
        string[] memory _ipfsHashes = new string[](end - st + 1);

        for (uint256 i = st; i <= end; ++i) {
            _ipfsHashes[i - st] = s_ipfsHashes[i];
        }

        return _ipfsHashes;
    }

    function getAllHashes() external view returns (string[] memory) {
        return s_ipfsHashes;
    }

    function getIpfsHashAtIdx(uint256 idx) external view returns (string memory) {
        return s_ipfsHashes[idx];
    }

    function getIsUploaded(string memory _ipfsHash) external view returns (bool) {
        return s_isUploaded[_ipfsHash];
    }

    function isSubOwner(address _subOwner) external view returns (bool) {
        return s_subOwners.contains(_subOwner);
    }

    function getAllSubOwners() external view returns (address[] memory) {
        return s_subOwners.values();
    }
   
}



