pragma solidity ^0.4.25;

import "./ERC721.sol";
import "./SafeMath.sol";
import "./ownable.sol";

contract StructTicket is ERC721, Ownable{
    
     struct TicketStruct{
        string Area;
        uint256 date;
        address owner;    //Owner of Tajmahal
        uint256 price;
        uint256 supplyAmount;
    }
    

    using SafeMath for uint256;
    using SafeMath32 for uint32;
    using SafeMath16 for uint16;

    mapping (uint256 => address) ticketIdToOwner;
    mapping (address => uint256) ownerTicketCount;
    mapping (uint256 => address) ticketIdToApproved;
    mapping (address => uint256) private etherBalance;
    mapping (uint256 => TicketStruct) TicketArea;
    
     TicketStruct[] public Tstructs;
    
    uint256 totalSupplyAccounts;
    
    event mint(address minter, uint256 ticketId);
    
    function _approve(address _to, uint256 _ticketId) internal{
        ticketIdToApproved[_ticketId] = _to;
        emit Approval(msg.sender, _to, _ticketId);
    }
    
    function _transfer(address _from, address _to, uint256 _ticketId) internal{
        ownerTicketCount[_from] = ownerTicketCount[_from].sub(1);
        ownerTicketCount[_to] = ownerTicketCount[_to].add(1);
        ticketIdToOwner[_ticketId] = _to;
        
        emit Transfer(_from, _to, _ticketId);
    }
    
    function balanceOf(address _owner) external view returns(uint256){
        return ownerTicketCount[_owner];
        
    }
    
    function ownerOf(uint256 _ticketId)external view returns(address){
        return ticketIdToOwner[_ticketId];
    }

    
     function _mintTicket(address owner, uint256 ticketId) internal   {
        ticketIdToOwner[ticketId] = owner;
        ownerTicketCount[msg.sender] = ownerTicketCount[msg.sender].add(1);
        emit mint(owner, ticketId);
    }
    
   function batchMintTicket(address _owner, uint256 _amount, uint256 _date, string _area, uint256 _price) public onlyOwner {
        Tstructs.push(TicketStruct(_area, _date, _owner, _price, _amount)); 
        
        uint256 hasminted = ownerTicketCount[_owner];
        for(uint i = ownerTicketCount[_owner]; i <  hasminted + _amount; i++){
            _mintTicket(_owner, i);
            TicketArea[i] = Tstructs[Tstructs.length - 1];
        }
        totalSupplyAccounts = totalSupplyAccounts.add(_amount);

    }
    
   function setDate(uint256 _index, uint256 _date) public onlyOwner{
        Tstructs[_index].date = _date;
    }
    
    function setArea(uint256 _index, string area) public onlyOwner{
       Tstructs[_index].Area = area;
    }
    
    function totalSupply()external view returns(uint256){
        return totalSupplyAccounts;
    }
    
    function transferFrom(address _from, address _to, uint256 _ticketId)external payable{
        require(_to != _from);
        require(ticketIdToApproved[_ticketId] == _to);
        require(ticketIdToOwner[_ticketId] == _from);
        
        _transfer(_from, _to, _ticketId);
    }
    
    function approve(address _to, uint256 _ticketId) external payable{
        require(_to != msg.sender);
        require(ticketIdToOwner[_ticketId] == msg.sender);
        _approve(_to, _ticketId);
    }
    
    function buyTicket(uint _ticketId)public payable{
        require(ticketIdToOwner[_ticketId] == owner());
        require(msg.value == 1 ether * TicketArea[_ticketId].price);
        require(msg.sender != owner());
        
        etherBalance[owner()] += msg.value;
        _transfer(owner(), msg.sender, _ticketId);
    }
    
    function getEtherBalance()public view returns (uint256){
        return etherBalance[address(owner())];
    }
    
    function getTicketArea(uint256 _ticketId)public view returns (string){
        return TicketArea[_ticketId].Area;
    }
  /*  function getPriceRate(uint256 _ticketId)public view returns(uint256){
        if(_ticketId >= 0 && _ticketId < 100){
            return 80;
        }
        else if(_ticketId >=100 && _ticketId < 200){
            return 70;
        }
        else if(_ticketId >=200 && _ticketId < 300){
            return 60;
        }
        else if(_ticketId >=300 && _ticketId < 400){
            return 50;
        }
        else if(_ticketId >=400 && _ticketId < 500){
            return 40;
        }
        else if(_ticketId >=500 && _ticketId < 600){
            return 30;
        }
        else if(_ticketId >=600 && _ticketId < 700){
            return 20;
        }
        else if(_ticketId >=700 && _ticketId < 800){
            return 10;
        }
        else if(_ticketId >=800 && _ticketId < 900){
            return 5;
        }
        else if(_ticketId >=900 && _ticketId < 1000){
            return 1;
        }
        else{
            return 0;
        }
    }
    */
}