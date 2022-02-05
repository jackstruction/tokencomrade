// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract TokenComrade{

    // GLobal Variables
    address payable owner;
    uint numEvents;
    bool fundPulled;

    // declares a state variable that stores a `Holder` struct for each possible address.

    struct Holder {
        address wallet;
        uint inventory;
    }
    
    // The events that admission tokens are created for
    
    struct Event{
        address payable organizer;
        string name;
        string description;
        uint initialSupply;
        uint supply;
        uint price; //wei
        bool soldOut;
        uint256 redeemableBalance;
        mapping(address => bool) scanners; // stores boolean to check whether an address is an approved scanner.
        //maps address to uint to store the quantity of owned tickets
        mapping(address => uint) inventory;
    }

    mapping(address => Holder) holders;
    mapping (uint => Event) events;

    //alls I know is that I'm the owner.
    constructor(){
        owner = payable(msg.sender);
    }
    
    //Owner Section | Create tickets, Pull funds, Assign scanners
    function createEvent(uint _supply, string memory _name, uint _price) external payable returns (uint, uint, uint){
        uint eventID = numEvents++;
        Event storage e = events[eventID];
        e.initialSupply = _supply;
        e.supply = _supply;
        e.name = _name;
        e.price = _price;
        e.organizer = payable(msg.sender);
        e.soldOut = false;
        e.redeemableBalance = 0;
        return (eventID, e.initialSupply, e.price);
    }
    
    function mint(uint eventID, uint _quantity) external payable{
        Event storage e = events[eventID];
        require(msg.value >= e.price, "incorrect value");
        require(e.supply >= _quantity, "Not Enough Supply");
        address holderID = msg.sender;
        Holder storage h = holders[holderID];
        e.supply -= _quantity;
        h.inventory += _quantity;
        h.wallet = msg.sender;
        if(e.supply == 0){
            sellOut(eventID);
        }
    }

    function scan(uint eventID, address _holderID, uint _quantity) external {
        Event storage e = events[eventID];
        Holder storage h = holders[_holderID];
        require(e.scanners[msg.sender], "You are not an approved scanner");
        require(h.inventory > _quantity, "Not enough tokens");
        h.inventory -= _quantity;
        e.redeemableBalance += (_quantity * e.price);
    }

    function approveScanner(address _scanner, uint eventID) public{
        Event storage e = events[eventID];
        require(e.organizer == msg.sender);
        e.scanners[_scanner] = true;
    }

    function sellOut(uint eventID) internal {
        Event storage e = events[eventID];
        e.soldOut = true;
    }

    function pullFunds() external returns (bytes32){
        require(msg.sender == owner, "Ah ah ah, that money's for someone else");
        require(address(this).balance>0);
        owner.transfer(address(this).balance);        
        fundPulled = true;
        bytes32 successmsg = "success";
        return successmsg;
        //change to just the extra from events that are over.
    }

}
