// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.11;

// ----------------------------------------------------------------------------
// EIP-20: ERC-20 Token Standard
// https://eips.ethereum.org/EIPS/eip-20
// -----------------------------------------

interface ERC20Interface {
    // Mandatory functions
    function totalSupply() external view returns (uint);
    function balanceOf(address tokenOwner) external view returns (uint balance);
    function transfer(address to, uint tokens) external returns (bool success);
    
    // Optionals
    // function allowance(address tokenOwner, address spender) external view returns (uint remaining);
    // function approve(address spender, uint tokens) external returns (bool success);
    // function transferFrom(address from, address to, uint tokens) external returns (bool success);
    
    event Transfer(address indexed from, address indexed to, uint tokens);
    // event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}


contract Cryptos is ERC20Interface{
    string public name = "Cryptos";
    string public symbol = "CRPT";
    uint public decimals = 0; //18 is very common
    uint public override totalSupply;
    
    // The following is not part of the ERC standard, but it is useful
    address public founder;
    mapping(address => uint) public balances;
    // balances[0x1111...] = 100;
    
    constructor(){
        totalSupply = 1e6;
        founder = msg.sender;
        balances[founder] = totalSupply;
    }

    function balanceOf(address tokenOwner) public view override returns (uint balance){
        return balances[tokenOwner];
    }

    function transfer(address to, uint tokens) public override returns (bool success){
        require(balances[msg.sender] >= tokens, "Not enough tokens on the wallet!");
        balances[to] += tokens;
        balances[msg.sender] -= tokens;
        emit Transfer(msg.sender, to, tokens);
        return true; // on
    }
}
