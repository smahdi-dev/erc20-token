// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployMahdiToken} from "../script/DeployMahdiToken.s.sol";
import {MahdiToken} from "../src/MahdiToken.sol";

contract MahdiTokenTest is Test {
    DeployMahdiToken public deployer;
    MahdiToken public mahdiToken;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant STARTING_BALANCE = 100 ether;
    uint256 public constant INITIAL_SUPPLY = 1000e18;

    function setUp() external {
        deployer = new DeployMahdiToken();
        mahdiToken = deployer.run();

        vm.prank(msg.sender);
        mahdiToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public view {
        assertEq(STARTING_BALANCE, mahdiToken.balanceOf(bob));
    }

    function testAllowancesWork() public {
        uint256 initialAllowance = 1000;

        // bob approves alice to spend tokens on his behalf
        vm.prank(bob);
        mahdiToken.approve(alice, initialAllowance);

        uint256 transferAmount = 500;

        vm.prank(alice);
        mahdiToken.transferFrom(bob, alice, transferAmount);

        assertEq(mahdiToken.balanceOf(alice), transferAmount);
        assertEq(mahdiToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }

    function testTransfer() public {
        uint256 transferAmount = 50 ether;

        vm.prank(bob);
        mahdiToken.transfer(alice, transferAmount);

        assertEq(mahdiToken.balanceOf(alice), transferAmount);
        assertEq(mahdiToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }

    function testDecreaseAllowance() public {
        uint256 initialAllowance = 1000;
        uint256 decreaseAmount = 500;

        vm.prank(bob);
        mahdiToken.approve(alice, initialAllowance);

        // Decrease the allowance for alice to spend tokens on behalf of bob
        vm.prank(bob);
        mahdiToken.approve(alice, initialAllowance - decreaseAmount);

        assertEq(
            mahdiToken.allowance(bob, alice),
            initialAllowance - decreaseAmount
        );
    }

    function testIncreaseAllowance() public {
        uint256 initialAllowance = 1000;
        uint256 increaseAmount = 500;

        vm.prank(bob);
        mahdiToken.approve(alice, initialAllowance);

        // Increase the allowance for alice to spend tokens on behalf of bob
        vm.prank(bob);
        mahdiToken.approve(alice, initialAllowance + increaseAmount);

        assertEq(
            mahdiToken.allowance(bob, alice),
            initialAllowance + increaseAmount
        );
    }

    function testTotalSupply() public view {
        assertEq(mahdiToken.totalSupply(), INITIAL_SUPPLY);
    }
}
