// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.11;

contract Lottery{
    address payable[] public players; // Dynamic array since we don't know the number of players
    address public manager;

    // The manager is the address that deploys the contract
    constructor(){
        manager = msg.sender;
    }
 
    receive() external payable{
        // Unit converter Wei-Gwei-Ether: https://eth-converter.com/
        require(msg.value == 0.1 ether, "Sorry, value is different than 0.1 ETH");
        // Adds the address that sends the ETH to the contract,
        // but first converts the plain address to a payable address
        players.push(payable(msg.sender));
    }

    // Get the current balance of ETH from the contract
    function getBalance() public view returns(uint){
        require(msg.sender == manager, "Sorry, only the manager can view the balance!");
        return address(this).balance;
    }

    // Function to create a pseudo random big number based on block attributes and players length
    // It is pseudo random since it is computed by hashing deterministic parameters
    // Better way of creating a random number in solidity: https://docs.chain.link/docs/get-a-random-number/
    function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }

    // Function to pick the winner
    function pickWinner() public{
        require(msg.sender == manager, "Sorry, only the manager can run this function!");
        require(players.length >= 3, "Sorry, there must be at least 3 players!");

        uint r = random();
        address payable winner;

        // Select the winner
        winner = players[r % players.length];

        // Transfer all the balance to the winner
        winner.transfer(getBalance());

        // Reset the lottery
        players = new address payable[](0);
    }
}