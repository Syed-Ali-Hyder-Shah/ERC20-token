// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IERC20ErrorsMock {
    error ERC20InsufficientAllowance(address spender, uint256 currentAllowance, uint256 amount);
    error ERC20InvalidSender(address from);
    error ERC20InvalidReceiver(address to);
    error ERC20InsufficientBalance(address from, uint256 balance, uint256 amount);
    error ERC20InvalidApprover(address owner);
    error ERC20InvalidSpender(address spender);
}