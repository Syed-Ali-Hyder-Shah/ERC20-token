// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "src/OpenZToken.sol";
import {DeployOpenZToken} from "script/DeployOpenZToken.s.sol";
import {ERC20, IERC20Errors} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {IERC20ErrorsMock} from "test/IERC20errorsMock.sol";

contract OpenZTokenTest is Test {
    OpenZToken token;
    address deployer = address(0x1);
    address user1 = address(0x2);
    address user2 = address(0x3);

    uint256 initialSupply = 100 ether;

    function setUp() public {
        vm.startPrank(deployer);
        token = new OpenZToken(initialSupply);
        vm.stopPrank();
    }

    function testInitialSupply() public view {
        assertEq(token.totalSupply(), initialSupply);
        assertEq(token.balanceOf(deployer), initialSupply);
    }

    function testTransfer() public {
        vm.prank(deployer);
        token.transfer(user1, 10 ether);
        assertEq(token.balanceOf(user1), 10 ether);
        assertEq(token.balanceOf(deployer), initialSupply - 10 ether);
    }

    function testApprove() public {
        vm.prank(deployer);
        token.approve(user1, 20 ether);
        assertEq(token.allowance(deployer, user1), 20 ether);
    }

    function testTransferFrom() public {
        vm.prank(deployer);
        token.approve(user1, 20 ether);

        vm.prank(user1);
        token.transferFrom(deployer, user2, 15 ether);

        assertEq(token.balanceOf(user2), 15 ether);
        assertEq(token.balanceOf(deployer), initialSupply - 15 ether);
        assertEq(token.allowance(deployer, user1), 5 ether);
    }

    // function testTransferFromFailsWithoutApproval() public {
    //     vm.expectRevert(IERC20Errors.ERC20InsufficientAllowance.selector);
    //     vm.prank(user1);
    //     token.transferFrom(deployer, user2, 15 ether);
    // }

    function testBurn() public {
        vm.prank(deployer);
        token.transfer(user1, 10 ether);

        vm.prank(user1);
        token.burn(10 ether);
        assertEq(token.balanceOf(user1), 0);
        assertEq(token.totalSupply(), initialSupply - 10 ether);
    }

    function testBurnFrom() public {
        vm.prank(deployer);
        token.approve(user1, 10 ether);

        vm.prank(user1);
        token.burnFrom(deployer, 10 ether);
        assertEq(token.totalSupply(), initialSupply - 10 ether);
        assertEq(token.balanceOf(deployer), initialSupply - 10 ether);
    }

    function testMint() public {
        vm.prank(deployer);
        token.mint(user1, 10 ether);
        assertEq(token.balanceOf(user1), 10 ether);
        assertEq(token.totalSupply(), initialSupply + 10 ether);
    }

    function testFailTransferToZeroAddress() public {
        vm.expectRevert(IERC20Errors.ERC20InvalidReceiver.selector);
        vm.prank(deployer);
        token.transfer(address(0), 10 ether);
    }

    function testFailApproveToZeroAddress() public {
        vm.expectRevert(IERC20Errors.ERC20InvalidSpender.selector);
        vm.prank(deployer);
        token.approve(address(0), 10 ether);
    }

    function testFailTransferFromInsufficientBalance() public {
        vm.prank(deployer);
        token.transfer(user1, 10 ether);

        vm.expectRevert(IERC20Errors.ERC20InsufficientBalance.selector);
        vm.prank(user1);
        token.transfer(user2, 15 ether);
    }

    function testFailBurnMoreThanBalance() public {
        vm.prank(deployer);
        token.transfer(user1, 10 ether);

        vm.expectRevert(IERC20Errors.ERC20InsufficientBalance.selector);
        vm.prank(user1);
        token.burn(15 ether);
    }
}