//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import "./allowance.sol";

contract SharedWallet is Allowance {
    event MoneySent(address indexed _beneficiary, uint _amount);
    event MoneyReceived(address indexed _from, uint _amount);

    function withdrawAllowance(address payable _to, uint _amount) public ownerOrAllowed(_amount) {
        require(_amount < address(this).balance, "There is not enough balance in smart contract");
        if(msg.sender != owner()){
            reduceAllowance(msg.sender, _amount);
        }
        emit MoneySent(_to, _amount);
        _to.transfer(_amount);
    }
    
    fallback() external payable {
        emit MoneyReceived(msg.sender, msg.value);
    }
}