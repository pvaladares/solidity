//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract CryptosToken{
    // Change the state variable name to be declared as a public constant.
    string constant public name = "Cryptos";
    uint supply;

    // Declare a setter and a getter function for the supply state variable.
    function setSupply(uint _supply) public{
        supply = _supply;
    } 

    function getSupply() public view returns(uint){
        return supply;
    }
}
