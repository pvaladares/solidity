//lines that begin with a // are comments for humans to interpret the contract
/*
we can also make
multi line comments
between /* and 
*/

//first thing we have to tell the compiler is which version to use
pragma solidity ^0.8.11; //lines in solidity end with a semicolon ;
//the ^ character above tells the compiler to use the specified version or newer

// we can import other programmers' code by using the import statement
import "@openzeppelin/contracts/access/Ownable.sol";

/*
the contract keyword tells the compiler we're defining a new contract
there can be more than one contract in a file
*/

/*
This contract stores a data string (a string stores text)
and makes it available for anyone to see
also allows anyone to change the message
update: we've added the ability to sell this contract for a price.
the `is` keyword tells the compiler to incorporate a contract into this one
*/
contract DataStore is Ownable {
    //first let's define internal state variables - this is the data that the contract `remembers`
    //the `private` keyword tells the compiler to make `data` inaccessable to the external world
    string private data;

    //define the price to sell this contract to someone else
    //uint means unsigned integer i.e.: a non-negative whole number
    uint public price; // public means that an external contract can VIEW this state variable
    //by default everything should be thought of in `wei`

    //every contract needs a `constructor` function that tells the compiler how to set it up (initialization)
    //the variable names within the () braces is information passed to the constructor to do it's job (arguments)
    //every variable used in a function needs to be declared as either `memory` or `storage` (storage is usually more expensive)
    constructor (string memory newData, uint newPrice) {
        //initialize the state variables
        data = newData; // `=` does assigment taking what's on the right hand side, and storing it in the left hand side
        price = newPrice;
    }

    /*
    we can create functions to view or modify the internal state of the contract 
    the function below allows anyone to view the data
    the returns statement tells the compuler what type of information is returned 
    once again public means that an external contract (or etherscan) can access this function 
    view is a hint that this function does not modify the internal state, only reads it
    */
    function viewData() public view returns (string memory) {
        return data;
    }

    /*
    this function allows the caller to change the stored data
    updated to only allow the owner of the contract (by default the deploying address) to change the data
    the onlyOwner modifier checks that the caller is the owner. If the caller is not the owner the transaction will fail
    */
    function changeData(string memory newData) public onlyOwner {
        //change the stored data to newData
        data = newData;
    }

    /*
    this function allows the contract ownership to be sold to anyone who pays the price
    the payable keyword means this function can accept ether
    */
    function buyOwnership() payable public {
        //check that the amount of ether sent is at least the price required
        //note: in production code this would probabily be in a `required`statement
        if (msg.value >= price) { //msg.value is a special keyword that tells us the amount of ETH sent in the transaction
            //exercise 1: send the ETH to the old owner!
            // THIS IS DEFINITELY NOT THE BEST, OR EVEN A SAFE WAY OF DOING IT!
            payable(owner()).transfer(msg.value);//the payable keyword here ensure that the address 
            //transfer ownership to the address that paid to buy the ownership
            //note that we are using the internal version of transferOwnership rather than the public once
            //(the public version of transferOwnership can only be called by the owner of the contract)
            _transferOwnership(msg.sender); //msg.sender is the account calling this function
            price = 2 * price;
        } else {
            //this causes an exception which "rolls back" the transaction including any ETH paid
            revert("not enough paid!");
        }
    }
}
//exercise 2: make it so the price doubles each time the contract is sold