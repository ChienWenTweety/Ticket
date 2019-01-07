pragma solidity ^0.4.25;

import "./ERC20.sol";
import "./safeMath.sol";
import "./ownable.sol";

contract SimpleTicket is ERC20, Ownable{
    using SafeMath for uint256;
    
    mapping(address => uint256) ticketBalances;
    mapping(address => uint256) allowanceBalances;
    mapping(address => uint256) etherBalance;
    
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
    
    uint256 public totalSupply;
    string public ticketName;
    uint256 public constant decimals = 18;
    string public symbol;
    uint256 price;
    
    function totalSupply() public view returns (uint){
        return totalSupply;
    }
    
    function mintSimpleTicket(string _ticketName, string _symbol, uint256 _totalSupply, uint256 _price)external onlyOwner{
        ticketName = _ticketName;
        totalSupply += _totalSupply;
        symbol = _symbol;
        price = _price;
        ticketBalances[msg.sender] += _totalSupply;
        
        
    }
    
    function balanceOf(address _tokenOwner) public view returns (uint){
        return ticketBalances[_tokenOwner];
    }
    
    function etherBalanceOf() public view returns (uint){
        return etherBalance[msg.sender];
    }
    
    function allowance(address tokenOwner, address spender) public view returns (uint){
        return allowanceBalances[spender];
        
    }

    
    function transfer(address to, uint tokens) public returns (bool success){
        require(msg.sender == owner());
        
        ticketBalances[owner()].sub(tokens);
        ticketBalances[to].add(tokens);
    }
    
    function approve(address spender, uint tokens) public returns (bool success){
        require(msg.sender == owner());
        
        allowanceBalances[spender].add(tokens);
    }
    
    function transferFrom(address from, address to, uint tokens) public returns (bool success){
        require(allowanceBalances[from] > tokens);
        transfer(to, tokens);
        allowanceBalances[from].sub(tokens);
    }
    
    
    function buySimpleTicket(uint256 _amount)public payable{
        require(msg.sender != owner());
        require(msg.value == 1 ether * price * _amount);
        require(ticketBalances[owner()] >= _amount);
        
        ticketBalances[owner()] -= _amount;
        ticketBalances[msg.sender] += _amount;
        etherBalance[owner()] += msg.value;
    }
    
    function getPrice()public view returns(uint256){
        return price;
    }
    
    function refund(uint256 _amount)public payable{
        require(ticketBalances[msg.sender] >= _amount);
        require(etherBalance[owner()] >= 1 ether * price * _amount);
        uint256 refunds =  1 ether * price * _amount;
        ticketBalances[msg.sender] -= _amount;
        ticketBalances[owner()] += _amount;
        etherBalance[owner()] -= refunds;
        etherBalance[msg.sender] += refunds;
        
    }
    
    function withdraw(uint256 etherValue) public {
        uint256 weiValue = etherValue * 1 ether;

        require(etherBalance[msg.sender] >= weiValue, "your balances are not enough");

        msg.sender.transfer(weiValue);

        etherBalance[msg.sender] -= weiValue;
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}