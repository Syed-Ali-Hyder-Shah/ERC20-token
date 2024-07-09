// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

/**
 * @title ERC20-Token
 * @author Shah_Hyder 
 * @notice This contract creates an ERC20 contract(Token)
 * @dev Uses Openzeppelin ERC20 contract
 */

 import {ERC20, IERC20Errors} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
 import {IERC20ErrorsMock} from "test/IERC20errorsMock.sol";

contract OpenZToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("OurToken", "OT") {
        _mint(msg.sender, initialSupply);
    }

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    function burnFrom(address account, uint256 amount) external {
        uint256 currentAllowance = allowance(account, msg.sender);
        if (currentAllowance < amount) {
            revert ERC20InsufficientAllowance(msg.sender, currentAllowance, amount);
        }
        _spendAllowance(account, msg.sender, amount);
        _burn(account, amount);
    }

      function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        uint256 currentAllowance = allowance(sender, msg.sender);
        if (currentAllowance < amount) {
            revert ERC20InsufficientAllowance(msg.sender, currentAllowance, amount);
        }
        _approve(sender, msg.sender, currentAllowance - amount);
        _transfer(sender, recipient, amount);
        return true;
    }
}