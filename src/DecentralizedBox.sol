// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { Math } from "@openzeppelin/contracts/utils/math/Math.sol";

contract DecentralizedBox is Ownable {
    error DecentralizedBox__AlreadyUploaded();
    error DecentralizedBox__IncorrectIdx();

    mapping(string ipfsHash => bool) private s_isUploaded;
    string[] private s_ipfsHashes;

    event HashUploaded(string indexed ipfsHash);

    modifier revertIfAlreadyUploaded(string memory _ipfsHash) {
        if (s_isUploaded[_ipfsHash]) {
            revert DecentralizedBox__AlreadyUploaded();
        }
        _;
    }

    constructor() Ownable(msg.sender) {

    }

    function uploadHash(string memory _ipfsHash) external onlyOwner revertIfAlreadyUploaded(_ipfsHash) {
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

    // @note owner of this contract can be viewed by calling the inherited function: owner()
}


