//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

// Modify the changeTokens() function in such a way that it changes the state variable called tokens.
contract MyTokens{
    string[] public tokens = ['BTC', 'ETH'];
    
    function changeTokens() public{
        tokens[0] = 'VET';
    }   
}