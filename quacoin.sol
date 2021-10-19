pragma solidity ^0.4.24;

/* Building my own cryptocurrency

parameters

Coin name: Qua Coin
Symbol: QUA
Total Supply: 10000000
Decimals: 4

Let's get it */


// math operations for $QUA
contract quaCoin {
    
    function quaAdd(uint a, uint b) public pure returns (uint c) {
      
        c = a + b;
        require(c >= a);
        
    }
    
    function quaSub(uint a, uint b) public pure returns (uint c) {

        c = a - b;
        require(b <= a);
    }
    
    function quaDiv(uint a, uint b) public pure returns (uint c) {
        
        c = a / b;
        require(b > 0);
    }
    
 /*   function quaMul(uint a, uint b) public pure returns (uint c) {
        
        c = a * b;
        require(a == 0 || c / b = a);
    }
    
} */

/* This is a standard ERC20Interface.
code is at https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
*/

contract ERC20Interface {
    
    function totalSupply() public constant returns (uint);
    function balanceOf(address tokenOwner) public constant returns (uint balance);
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

/* I'm not sure yet what this next section does. Have to come back to it.
Source says it was borrowed from MiniMe token */

contract ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
}

// Actual Token contract
contract QUAToken is ERC20Interface, quaCoin {
    string public symbol;
    string public  name;
    uint8 public decimals;
    uint public _totalSupply;

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;
    
// constructor
    constructor() public {
        symbol = "QUA";
        name = "QUA Coin";
        decimals = 4;
        _totalSupply = 10000000;
        balances[0x5f9b2253a7AA8abB73362D1b3d86156C07293677] = _totalSupply;
        emit Transfer(address(0), 0x5f9b2253a7AA8abB73362D1b3d86156C07293677, _totalSupply);
    }
    
// Total Supply
    function totalSupply() public constant returns (uint) {
        return _totalSupply - balances[address(0)];
    }
    
// To get token balance of tokenOwner account   
    function balanceOf(address tokenOwner) public constant returns (uint balance) {
        return balances[tokenOwner];
    }

/* Transfer tokens from token owner to other address
Owner's account must have sufficient balance to transfer */

    function transfer(address to, uint tokens) public returns (bool success) {
        balances[msg.sender] = quaSub(balances[msg.sender], tokens);
        balances[to] = quaAdd(balances[to], tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
        
    }
    
/* Token owner approval for trnsfer.
Might not be necessary but leaving it in for now*/

    function approve(address spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }
    
// Transfer tokens between two accounts    
    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        balances[from] = quaSub(balances[from], tokens);
        allowed[from][msg.sender] = quaSub(allowed[from][msg.sender], tokens);
        balances[to] = quaAdd(balances[to], tokens);
        emit Transfer(from, to, tokens);
        return true;
    }

// number of tokens owner approved to be spent  
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }
    
// Token owner approves transfer and receiveApproval is called for the receiver
    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
        return true;
    }
    
    function () public payable {
        revert();
    }
}
    
    
    
    
    