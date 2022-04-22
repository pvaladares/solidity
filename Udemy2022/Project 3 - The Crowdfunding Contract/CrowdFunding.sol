// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.11;
//>=0.5.0 <0.9.0;
contract CrowdFunding{
	mapping(address => uint) public contributors;
	address public admin;
	uint public noOfContributors;
	uint public minimumContribution;
	uint public deadline; // timestamp
	uint public goal;
	uint public raisedAmount;
	struct Request{
		string description;
		address payable recipient;
		uint value;
		bool completed; // by default is false
		uint noOfVoters;
		mapping(address => bool) voters;
	}
	mapping(uint => Request) public requests;

	uint public numRequests;

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

    // Initiates a new instance based on the argument passed
	function createRequest(string memory _description, address payable _recipient, uint _value) public onlyAdmin{
		Request storage newRequest = requests[numRequests];
		numRequests++; // increment variable to make it ready for the next request

		newRequest.description = _description;
		newRequest.recipient = _recipient;
		newRequest.value = _value;
		newRequest.completed = false;
		newRequest.noOfVoters = 0;
	}

    function voteRequest(uint _requestNo) public{
        require(contributors[msg.sender] > 0, "You must a contributor in order to vote!");
        Request storage thisRequest = requests[_requestNo];

        require(thisRequest.voters[msg.sender] == false, "You have already voted!");
        thisRequest.voters[msg.sender] = true;
        thisRequest.noOfVoters++;
    }

    function makePayment(uint _requestNo) public onlyAdmin{
        require(raisedAmount >= goal, "The goal was not achieved!");
        Request storage thisRequest = requests[_requestNo];
        require(thisRequest.completed == false, "The request has been completed!");
        require(thisRequest.noOfVoters > noOfContributors / 2); // 50% is required to have voted for this request

        thisRequest.recipient.transfer(thisRequest.value);
        thisRequest.completed = true;
    }

	modifier onlyAdmin(){
		require(msg.sender == admin, "Only admin can call this function!");
		_;
	}
}