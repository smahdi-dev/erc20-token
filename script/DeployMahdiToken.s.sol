// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MahdiToken} from "../src/MahdiToken.sol";

contract DeployMahdiToken is Script {
    uint256 private constant INITIAL_SUPPLY = 1000 ether;

    function run() external returns (MahdiToken) {
        vm.startBroadcast();
        MahdiToken mahdiToken = new MahdiToken(INITIAL_SUPPLY);
        vm.stopBroadcast();

        return mahdiToken;
    }
}
