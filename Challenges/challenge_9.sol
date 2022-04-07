//SPDX-License-Identifier: MIT
 
pragma solidity ^0.8.0;

// Declare a function that concatenates two strings.
// Note: Since Solidity does not offer a native way to concatenate strings use abi.encodePacked() to do that.
// Read the official doc for examples: https://docs.soliditylang.org/en/latest/abi-spec.html
//
// "Dynamically-sized types like string, bytes or uint[] are encoded without their length field."
// "The encoding of string or bytes does not apply padding at the end unless it is part of an array or 
// struct (then it is padded to a multiple of 32 bytes)."
contract Strings{
    string public s1;
    string public s2;
    string public s3;

    constructor(string memory _s1, string memory _s2){
        s1 = _s1;
        s2 = _s2;
    }

    // Saves output on memory
    function saveMemory() public view returns(string memory){
        return string(abi.encodePacked(s1, s2));
    }

    // Saves output on state variable
    function saveVariableState() public{
        s3 = string(abi.encodePacked(s1, s2));
    }
}