// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.11;

contract A{

	address public ownerA;

	constructor(address eoa){ // external owned account
		ownerA = eoa;
	}
}

contract Creator{
	address public 	ownerCreator;
	A[] public deployedA;

	constructor(){
		ownerCreator = msg.sender;
	}

	function deployA() public{
		A new_A_address = new A(msg.sender);
		deployedA.push(new_A_address);
	}
}