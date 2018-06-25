pragma solidity ^0.4.21;

contract Splitter {
    uint private recCount;
    mapping(address => uint) addrIndex;
    address[] receivers;
    event recEvent(address indexed receiver);
    event tranEvent(address indexed receiver, uint256 value); 
    /* constructor */
    function Splitter (uint count) public {
        /* Setting up a limit on the receivers count at the time of contract deployment */
        recCount = count;
    }
    function addReciever(address rec) public{
        /* Validating the count of recievers before adding a new entry */
        require(receivers.length < recCount);
        /* Validating for duplicate address entry */
        require(addrIndex[rec] == 0);
        receivers.push(rec);
        addrIndex[rec] = receivers.length;
        /* Logging addition of new reciever */
        emit recEvent(rec);
    }
    
    function splitEther() public payable{
        /* Validating whether there is atleast one reciever */
        require(receivers.length>0);
        /* Sharing the ether equally among the recievers */
        uint256 singleShare = msg.value/(receivers.length);
        /* Making sure that share is valid */
        require (singleShare > 0);
        for (uint i=0; i< receivers.length; i++){
            receivers[i].transfer(singleShare);
            /* Logging split transfer for each of the recievers */
             emit tranEvent(receivers[i],singleShare);
        }
    }
}


