//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

// Consider the solution from the previous challenge.
// Add a new immutable state variable called admin and initialize it with the address of the account that deploys the contract;
// Add a restriction so that only the admin can transfer the balance of the contract to another address;
contract Deposit{

    address public immutable admin;

    constructor(){
        admin = msg.sender;
    }
    
    receive() external payable{
    }
    
    function sendEther() public payable{
    }

    function getBalance() public view returns(uint){
        return address(this).balance;
    }

    function transferBalance(address payable _recipient) public{
        require(msg.sender == admin, "Caller is not the admin of this contract!");
        uint _balance = getBalance();             
        _recipient.transfer(_balance);            
    }
}
