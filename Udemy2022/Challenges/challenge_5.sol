//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

// Consider the solution from the previous challenge.
// Add a function that transfers the entire balance of the contract to another address.
// Deploy and test the contract on Rinkeby Testnet.
contract Deposit{
    
    receive() external payable{
    }
    
    function sendEther() public payable{
    }

    function getBalance() public view returns(uint){
        return address(this).balance;
    }

    function transferBalance(address payable _recipient) public{
        uint _balance = getBalance(); 
        _recipient.transfer(_balance);
    }
}