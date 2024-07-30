// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { Math } from "@openzeppelin/contracts/utils/math/Math.sol";

contract DecentralizedBox2 is Ownable {
    error DecentralizedBox__AlreadyUploaded();
    error DecentralizedBox__IncorrectIdx();

    struct Storage {
        string name;
        string s_ipfsHashes;
        uint8 year;
        string branch;
        string collegeName;
    }

    mapping(string ipfsHash => bool) private s_isUploaded;
    Storage[] private storageData;

    event HashUploaded(Storage indexed data);

    modifier revertIfAlreadyUploaded(string memory _ipfsHash) {
        if (s_isUploaded[_ipfsHash]) {
            revert DecentralizedBox__AlreadyUploaded();
        }
        _;
    }

    constructor() Ownable(msg.sender) {

    }

    function uploadHash(string memory _ipfsHash, string memory _name, uint8 _year, string memory _branch, string memory _collegeName) external onlyOwner revertIfAlreadyUploaded(_ipfsHash) {
        s_isUploaded[_ipfsHash] = true;
        Storage memory _data = Storage({
            name: _name,
            s_ipfsHashes: _ipfsHash,
            year: _year,
            branch: _branch,
            collegeName: _collegeName
        });
        storageData.push(_data);
        emit HashUploaded(_data);
    }

    function getIpfsHashInRange(uint256 st, uint256 end) external view returns (string[] memory) {
        uint256 len = storageData.length;
        
        if (st >= len || st > end) {
            revert DecentralizedBox__IncorrectIdx();
        }
        
        end = Math.min(end, len - 1);
        string[] memory _ipfsHashes = new string[](end - st + 1);

        for (uint256 i = st; i <= end; ++i) {
            _ipfsHashes[i - st] = storageData[i].s_ipfsHashes;
        }

        return _ipfsHashes;
    }

    function getAllHashes() external view returns (string[] memory) {
        string[] memory _ipfsHashes = new string[](storageData.length);
        for (uint256 i = 0; i < storageData.length; ++i) {
            _ipfsHashes[i] = storageData[i].s_ipfsHashes;
        }
        return _ipfsHashes;
    }

    function getIpfsHashAtIdx(uint256 idx) external view returns (string memory) {
        return storageData[idx].s_ipfsHashes;
    }

    function getIsUploaded(string memory _ipfsHash) external view returns (bool) {
        return s_isUploaded[_ipfsHash];
    }

    // @note owner of this contract can be viewed by calling the inherited function: owner()
}


