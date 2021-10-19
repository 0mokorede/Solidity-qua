pragma solidity >= 0.7.0 < 0.9.0;

contract qToken {

    string public tokenName = 'Q Token';
    string public tokenSymbol = 'QTK';
    uint256 public totalSupply = 1000000000000000000000; // 1000 Tokens
    uint256 public decimals;
    address public owner;

    mapping(address => uint) balances;

    constructor() public {
        owner = msg.sender;
        balance[msg.sender] = totalSupply;
        
    }

    function mint(address receiver, uint amount) public {
        require(msg.sender == owner);
        balances[receiver] += amount;

    }

    function send(address receiver, uint amount) {
        require(msg.sender != receiver, 'no self sending');

        if(amount <= balances[msg.sender]) {
            balances[msg.sender] -= amount;
            balances[receiver] += amount; 

        }else{ 
        
            revert(insufficientBalance{
            amountRequested: amount,
            amountAvailable: balances[msg.sender]
        }) 
        }

        

        emit Sent(msg.sender, receiver, amount);

    } 
}