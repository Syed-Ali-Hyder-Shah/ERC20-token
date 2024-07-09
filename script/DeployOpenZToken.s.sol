// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

/**
 * @title ERC20-Token
 * @author Shah_Hyder 
 * @notice This contract creates an ERC20 contract(Token)
 * @dev 
 */

import {Script} from "forge-std/Script.sol";
import {OpenZToken} from "src/OpenZToken.sol";

contract DeployOpenZToken is Script{
    
    uint256 public constant INITIAL_SUPPLY = 100 ether;
    
    function run () external returns (OpenZToken){
        vm.startBroadcast();
        
        OpenZToken oT = new OpenZToken(INITIAL_SUPPLY);
        vm.stopBroadcast();
        return oT;
    }
}