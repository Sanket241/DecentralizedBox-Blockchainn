// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/DecentralizedBox.sol";

contract DeployDecentralizedBox is Script {
    function run() external {
        vm.startBroadcast();
        new DecentralizedBox();
        vm.stopBroadcast();
    }
}
