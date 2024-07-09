// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

/**
 * @title ERC20-Token
 * @author Shah_Hyder 
 * @notice This contract creates an ERC20 contract(Token)
 * @dev 
 */

 

contract ERC20{

/*VARIABLES */
    address private immutable i_owner;
    mapping(address => uint256) private  s_addressToAccountBalanceMapped;
/*VARIABLES */



    function name() public pure returns (string memory){
        return "Manual Token";
    }

    function totalSupply() public pure returns (uint256){
        return 100 ether;
    }

    function decimals() public pure returns (uint8){
        return 18;
    }

    function balanceOf(address _owner) public view returns (uint256 balance){
        return s_addressToAccountBalanceMapped[_owner];
    }

    function transfer(address _to, uint256 _amount) public {
        uint256 previousBalance = balanceOf(msg.sender) + balanceOf(_to);
        uint256 currentBalanceOfOwner = s_addressToAccountBalanceMapped[msg.sender] -= _amount;
        uint256 currentBalanceOfReciever = s_addressToAccountBalanceMapped[_to] += _amount;

        require(currentBalanceOfOwner + currentBalanceOfReciever == previousBalance);
    }


}