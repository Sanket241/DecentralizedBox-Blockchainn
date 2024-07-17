// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "forge-std/Test.sol";
import "../src/DecentralizedBox.sol";

contract DecentralizedBoxTest is Test {
    DecentralizedBox box;

    event HashUploaded(string indexed ipfsHash);

    function setUp() public {
        box = new DecentralizedBox();
    }

    // function testUploadHash() public {
    //     string memory hash = "";
    //     box.uploadHash(hash);
    //     assertEq(box.getHash(), hash);
    // }

    // function testEmitHashUploadedEvent() public {
    //     string memory hash = "";
    //     vm.expectEmit(true, true, true, true);
    //     emit HashUploaded(hash);
    //     box.uploadHash(hash);
    // }
}
