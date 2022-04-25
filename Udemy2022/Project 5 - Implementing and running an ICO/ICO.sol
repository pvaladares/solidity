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
    function allowance(address tokenOwner, address spender) external view returns (uint remaining);
    function approve(address spender, uint tokens) external returns (bool success);
    function transferFrom(address from, address to, uint tokens) external returns (bool success);
    
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
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
    
    mapping(address => mapping(address => uint)) public allowed;

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

        return true;
    }

    function allowance(address tokenOwner, address spender) public view returns (uint remaining){
        return allowed[tokenOwner][spender];
    }

    function approve(address spender, uint tokens) public override returns (bool success){
        require(balanceOf(msg.sender) >= tokens);
        require(tokens > 0);

        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    function transferFrom(address from, address to, uint tokens) public override returns (bool success){
        require(allowed[from][to] >= tokens);
        require(balances[from] >= tokens);

        balances[from] -= tokens;
        balances[to] += tokens;
        allowed[from][to] -= tokens;
        return true;
    }
}

contract CryptoICO is Cryptos{
    address public admin;
    address payable public deposit;
    uint tokenPrice = 0.001 ether; // 1ETH = 1000 CRPT, 1CRPT = 0.001
    uint public hardCap = 300 ether;
    uint public raisedAmount;
    uint public saleStart = block.timestamp; // ICO starts immediatly after deployment
    uint public saleEnd = saleStart + 1 weeks;
    uint public tokenTradeStart = saleStart + 1 weeks;
    uint public maxInvestment = 5 ether;
    uint public minInvestment = 0.1 ether;
    enum State {beforeStart, running, afterEnd, halted}
    State public icoState;

    constructor(address payable _deposit){
        deposit = _deposit;
        admin = msg.sender;
        icoState = State.beforeStart;
    }
}