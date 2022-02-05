// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
contract TokenComrade{
    address payable owner;
    // The events that admission tokens are created for
    struct Event {
        address payable organizer;
        string name;
        string description;
        uint initialSupply;
        uint supply;
        uint price; //wei
        bool soldOut;
    }

    struct Holder {
        address wallet;
        uint inventory;

    }

    uint256 public redeemableBalance;
    address[] public approvedScanners;  
    constructor(){
        owner = msg.sender;
    }
    uint numEvents;
    mapping (uint => Event) events;
    //Owner Section | Create tickets, Pull funds, Assign scanners
    function createEvent(uint _supply, bytes32 _name, uint _price) external payable public {
    eventID = numEvents++;
    Event storage e = events[eventID];
    e.initialSupply = _supply;
    e.supply = _supply;
    e.name = _name;
    e.price = _price;
    e.organizer = msg.sender;
    e.soldOut = false;
    }
    function pullFunds(uint eventID) external public{
        require (msg.sender == owner, "Ah ah ah, that money's for someone else")
        owner.transfer(uint256 redeemableBalance);
    }
    function approveScanner(address _scanner, uint eventID) public external (returns bool){
        Event storage e = events[eventID];
        for(uint i=0;i<e.approvedScanners.length;i++){
            if(e.approvedScanner[i]==_scanner){
                uint one = 1;
            } else {approvedScanners.push(_scanner)}
        }
    }
    function checkSoldOut(uint eventID) view{
        
    }

    function mintTicket(uint eventID, uint _quantity) public payable{
        Event storage e = events[eventID];
        require(msg.value >= e.price, "incorrect value");
        e.supply -= _quantity;
        buyer.ticketsHeld += quantity
    }
    function scanTicket(address _entrant, uint _quantity)public external{
        Event storage e = events[eventID];
        require(msg.sender == e.approvedScanner, "Not an approved scanner");
        if(_entrant in e.Holders[]){
            _entrant.
        }
    }
}
