// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DecentralizedBox {
    string public ipfsHash;
    event HashUploaded(string indexed ipfsHash);

    function uploadHash(string memory _ipfsHash) public {
        ipfsHash = _ipfsHash;
        emit HashUploaded(_ipfsHash);
    }

    function getHash() public view returns (string memory) {
        return ipfsHash;
    }
}


