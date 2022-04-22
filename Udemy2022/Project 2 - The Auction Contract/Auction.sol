// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.11;

contract Auction{

	// State variables 
	address payable public owner;
	uint public startBlock;
	uint public endBlock;
	string public ipfsHash;

	enum State {Started, Running, Ended, Canceled}
	State public auctionState;

	uint public highestBindingBid; // highestBindingBid = minimum of bids + 10
	address  payable public highestBidder;

	mapping(address => uint) public bids;

	uint bidIncrement;

	// Constructor
	constructor(){
		owner = payable(msg.sender);
		auctionState = State.Running;
		startBlock = block.number;
		endBlock = startBlock + 1 weeks; // Auction will run for one week
		ipfsHash = "";
		bidIncrement = 100 wei;
	}

	// Modifiers
	modifier notOwner(){
		require(msg.sender != owner);
		_;
	}

	modifier afterStart(){
		require(block.number >= startBlock);
		_;
	}

	modifier beforeEnd(){
		require(block.number <= endBlock);
		_;
	}

	modifier onlyOwner(){
		require(msg.sender == owner);
		_;
	}

	// Functions
	function min(uint a, uint b) pure internal returns (uint){
		return a > b ? a : b;
	}

	function cancelAuction() public onlyOwner{
		auctionState = State.Canceled;
	}

	function placeBid() public payable notOwner afterStart beforeEnd{
		require(auctionState == State.Running);
		require(msg.value >= 100 wei);

		uint currentBid = bids[msg.sender] + msg.value;
		require(currentBid > highestBindingBid);

		bids[msg.sender] = currentBid;

		if(currentBid <= bids[highestBidder]){
			highestBindingBid = min(currentBid + bidIncrement, bids[highestBidder]);
		}
		else{
			highestBindingBid = min(currentBid, bids[highestBidder] + bidIncrement);
			highestBidder = payable(msg.sender);
		}
	}

	function finalizeAuction() public{
		require(auctionState == State.Canceled || block.number > endBlock);
		require(msg.sender == owner || bids[msg.sender] > 0); // Only the owner or addresses that have made a bid

		address payable recipient;
		uint value;

		if(auctionState == State.Canceled){ // Auction was canceled, every bidder can claim back his bid
			recipient = payable(msg.sender);
			value = bids[msg.sender];
		}
		else{
			if(msg.sender == owner){ // The caller is the owner, takes the the highest binding bid
				recipient = owner;
				value = highestBindingBid;
			}
			else{ // This is a bidder
				if(msg.sender == highestBidder){ // The case of the highest Bidder, can claim the excess of bid
					recipient = highestBidder;
					value = bids[highestBidder] - highestBindingBid;
				}
				else{ // Everyone else that bidded but did not win the auction, can claim 100% back their bid
					recipient = payable(msg.sender);
					value = bids[msg.sender];
				}
			}
		}
	
		bids[recipient] = 0; // Reseeting the mapping so bidder cannot claim again the bid

		recipient.transfer(value); // Send the value to the recipient
	}
}