pragma solidity ^0.4.21;

contract Splitter {
    /* Receiver1 address */
    address public receiver1;
    /* Receiver2 address */
    address public receiver2;
    event regRec(address indexed);
    event tranEvent(address indexed receiver, uint256 value); 
    /* constructor */
    constructor (address _rec1, address _rec2) public {
        /* Setup the reciever accounts */
        receiver1 = _rec1;
        emit regRec(receiver1);
        receiver2 = _rec2;
        emit regRec(receiver2);
    }
    
    function splitFunds() public payable {
        /* Making sure thatwe have required addresses*/
        require (receiver1 != address(0) && receiver2 != address(0));
        /* Transferring funds to the first receiver */ 
        receiver1.transfer(msg.value/2);
        /* Logging split transfer for each of the recievers */
        emit tranEvent(receiver1,msg.value/2);
        /* Transferring funds to the second receiver */  
        receiver2.transfer(msg.value/2);
        /* Logging split transfer for each of the recievers */
        emit tranEvent(receiver2,msg.value/2);
        }
    }


