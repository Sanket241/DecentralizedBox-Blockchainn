
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

    struct UploadInfo {
        string ipfsHash;
        string name;
        string id;
        uint256 timestamp;
        string description;
    }

    mapping(string ipfsHash => bool) private s_isUploaded;
    EnumerableSet.AddressSet private s_subOwners;
    UploadInfo[] private s_uploadInfos;

    event HashUploaded(string ipfsHash, string name, string id, uint256 timestamp, string description);
    event SubOwnerAdded(address indexed subOwner);
    event SubOwnerRemoved(address indexed subOwner);

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

        emit SubOwnerAdded(_subOwner);
        s_subOwners.add(_subOwner);
    }

    function removeSubOwner(address _subOwner) external onlyOwner {
        if (!s_subOwners.contains(_subOwner)) {
            revert DecentralizedBox__AlreadyNotSubOwner();
        }

        emit SubOwnerRemoved(_subOwner);
        s_subOwners.remove(_subOwner);
    }

    function uploadHash(string memory _ipfsHash, string memory _name, string memory _id, string memory _description) external onlyOwnerOrSubOwner revertIfAlreadyUploaded(_ipfsHash) {
        s_isUploaded[_ipfsHash] = true;

        emit HashUploaded(_ipfsHash, _name, _id, block.timestamp, _description);
        s_uploadInfos.push(UploadInfo({
            ipfsHash: _ipfsHash,
            name: _name,
            id: _id,
            timestamp: block.timestamp,
            description: _description
        }));
    }

    function getUploadInfoInRange(uint256 st, uint256 end) external view returns (UploadInfo[] memory) {
        uint256 len = s_uploadInfos.length;
        
        if (st >= len || st > end) {
            revert DecentralizedBox__IncorrectIdx();
        }
        
        end = Math.min(end, len - 1);
        UploadInfo[] memory _uploadInfos = new UploadInfo[](end - st + 1);

        for (uint256 i = st; i <= end; ++i) {
            _uploadInfos[i - st] = s_uploadInfos[i];
        }

        return _uploadInfos;
    }

    function getAllUploadInfos() external view returns (UploadInfo[] memory) {
        return s_uploadInfos;
    }

    function getUploadInfoAtIdx(uint256 idx) external view returns (UploadInfo memory) {
        return s_uploadInfos[idx];
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
    // @note owner of this contract can be viewed by calling the inherited function: owner()
}



