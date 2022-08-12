//lines that begin with a // are comments for humans to interpret the contract
/*
we can also have mulit line comments
by enclosing text between /*
*/
//the first thing in a solidity smart contract is the complier version preference
//tell the compiler which version to use
pragma solidity ^0.8.15;
//the ^ character indiciates that we can use the specified version OR NEWER

//we can import other programmer's code by using the import statement
import "@openzeppelin/contracts/access/Ownable.sol";
//openzeppelin is a trusted repository of code (github)
//the @ symbol tells the compiler to fetch the files online

/*
This contract stores a data string or "text" for the non-technical folks
It makes the stored data string available for anyone to read

This version allows ONLY the contract "owner" to change the message
*/

// the 'is' keyword tells the compiler to incorporate a second contract within this one
contract MessageStore is Ownable{
//the contract keyword tells the compiler we're defining a new contract
//there can be more than one contract in each .sol file
//the entire contract is contained between the {}

    //let's define internal state variables - this is the data that the smart contract 'remembers' or knows about
    string private data; //statements in solidity end in a ; semicolon
    //string is the type of information we're storing - it means that we're storing some text
    //private means that by default this information will be 'hidden' from other contracts
    //"data" is simply a name we chose for this piece of contract state (also called a variable)

    //to make ownership of this contract purchasable let's define a price
    uint public price;
    //uint is short for unsigned integer which means this variable can only store non-negative whole numbers
    //sometimes you'll see a certain number of bits specified like uint256
    //public means that the compiler will automatically generate a "view" function to give others access to view this variable

    /*
    every contract needs a 'constructor' function that tells the compiler how to initialize the contract
    the variable names within the () braces is information passed to the constructor so that it can do it's job (arguments)
    every variable in a solidity function needs to be declared as either 'memory' or 'storage' (storage is more expensive in terms of gas)
    */
    constructor (string memory newData, uint newPrice){
        //everything between these {} braces is the constructor function
        //the only thing we need to do now is initialize the "data" state variable
        data = newData;
        price = newPrice;
    }

    /*
    we can create functions to view or modify the internal state of the contract
    the function below allows anyone to view the data
    the first set of () braces contain any external information the function needs to do its job
    in this case, no external information is needed
    public means that this function can be used by other contracts as part of the public interface
    the view keyword indicates this function won't change the internal state
    the returns key word describes the type of information this function will provide as an answer
    */
    function viewData() public view returns(string memory){
        return data; // the return statement specifies which piece of information to provide as an answer
    }

    /*
    this function allows the caller (anyone) to change the stored data
    */
    function changeData(string memory updatedData) public onlyOwner{
        //onlyOwner is the modifier introduced by Ownable.sol
        //a modifier runs (typically) before the rest of the function - usually to make sure conditions for calling the function are met
        //change the stored data to the updatedData
        data = updatedData;
    }

    /*
    this function allows the contract ownership to be sold to anyone who pays the price
    this introduces the 'payable' keyword which indicates that this function can accept ETH
    in this version this contract will keep the ETH that was sent
    */
    function buyOwnership() payable public{
        //check that the amount of ETH sent is at least the price that was set
        //we're going to do it in a very 'first principles way' for demonstration pruposes
        //there's a more concise way to do this in production using the 'require' or 'assert' keywords
        if(msg.value >= price){//msg.value is a special keyword that refers to the amount of ETH sent with the transaction
            //change the owner to whoever paid the ETH
            _transferOwnership(msg.sender); //msg.sender is the account that's calling the buyOwnership function
        }
    }
}