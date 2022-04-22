// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.11;

contract CrowdFunding{
	mapping(address => uint) public contributors;
	address public admin;
	uint public noOfContributors;
	uint public minimumContribution;
	uint public deadline; // timestamp
	uint public goal;
	uint public raisedAmount;

	constructor(uint _goal, uint _deadline){
		goal = _goal;
		deadline = block.timestamp + _deadline;
		minimumContribution = 100 wei;
		admin = msg.sender;
	}

	function contribute() public payable{
		require(block.timestamp < deadline, "Deadline has passed!");
		require(msg.value >= minimumContribution, "Minimum contribution not met");

		if(contributors[msg.sender] == 0){ // Check for first time a user contributes
			noOfContributors++;
		}

		contributors[msg.sender] += msg.value; // Update the contribution of the user
		raisedAmount += msg.value;
	}

	function receive() payable external{
		contribute();
	}

	function getBalance() public view returns(uint){
		return address(this).balance;
	}

	function getRefund() public{
		require(block.timestamp > deadline && raisedAmount < goal, "NO REFUND : Campaign is not finished yet | Goal was met");
		require(contributors[msg.sender] > 0, "NO REFUND : You are not a contributor");
	
		// Make the refund
		address payable recipient = payable(msg.sender);
		uint value = contributors[msg.sender];
		recipient.transfer(value);

		// Reset the contribution of this user
		contributors[msg.sender] = 0;
	}
}