pragma solidity ^0.4.21;

contract Splitter {
    /* Owner address */
    address public owner;
    /* Receiver1 address */
    address public receiver1;
    /* Receiver2 address */
    address public receiver2;
    /* Receiver1 balance */
    uint public receiver1Balance;
    /* Receiver2 balance */
    uint public receiver2Balance;
    /* Owner balance */
    uint public ownerBalance;
    /* Event to log registered receivers */
    event LogRegisteredReceiver (address indexed, address indexed);
    /* Event to log transactions */
    event LogTransaction(address indexed receiver1,address indexed reciever2, uint256 value); 
    /* Event to log withdrawals */
    event LogWithDrawal(address indexed receiver1,uint256 value, bool status);
    /* constructor */
    constructor (address _rec1, address _rec2) public {
        /* Setup the reciever accounts and owner accounts */
        owner = msg.sender;
        receiver1 = _rec1;
        receiver2 = _rec2;
        emit LogRegisteredReceiver(receiver1,receiver2);
    }
    
    
    function splitFunds() public payable {
        /* Making sure that we have required addresses*/
        require (receiver1 != address(0) && receiver2 != address(0));
        uint fundsSent = msg.value;
        uint singleShare = fundsSent/2;
        uint remainingShare = 0;
        /* Alloting funds to the first receiver */ 
        receiver1Balance += singleShare;
        /* Alloting funds to the second receiver */  
        receiver2Balance += singleShare;
        /* Pushing the left-out value back to sender */
        remainingShare = fundsSent - (2*singleShare);
        ownerBalance += remainingShare;
        /* Logging split transfer for each of the recievers */
        emit LogTransaction(receiver1,receiver2,msg.value/2);
        }
        
    function withDrawReciever1(uint fundToWithdraw){
        address initiator = msg.sender;
        bool status = true;
        /* Validating receiever1 */
        require(initiator == receiver1);
        /* Validating receiver1 balance */
        require(receiver1Balance > 0);
        require(fundToWithdraw <= receiver1Balance);
        /* Adjust the balance for this reciever in the contract */
        receiver1Balance -= fundToWithdraw;
        if(!initiator.send(fundToWithdraw)){
            /* If the withdrawal failed, restore the balance */
            receiver1Balance += fundToWithdraw;
            status = false;
        }
        /* Logging the withdrawal event */
        LogWithDrawal(initiator,fundToWithdraw, status);
    }
     function withDrawReciever2(uint fundToWithdraw){
        address initiator = msg.sender;
        bool status = true;
        /* Validating receiever2 */
        require(initiator == receiver2);
        /* Validating receiver2 balance */
        require(receiver2Balance > 0);
        require(fundToWithdraw <= receiver2Balance);
        /* Adjust the balance for this reciever in the contract */
        receiver2Balance -= fundToWithdraw;
        if(!initiator.send(fundToWithdraw)){
            /* If the withdrawal failed, restore the balance */
            receiver2Balance += fundToWithdraw;
            status = false;
        }
        /* Logging the withdrawal event */
        LogWithDrawal(initiator,fundToWithdraw, status);
    }
   
     function withDrawOwner(uint fundToWithdraw){
        address initiator = msg.sender;
        bool status = true;
        /* Validating owner */
        require(initiator == owner);
        /* Validating owner balance */
        require(ownerBalance > 0);
        require(fundToWithdraw <= ownerBalance);
        /* Adjust the balance for this owner in the contract */
        ownerBalance -= fundToWithdraw;
        if(!initiator.send(fundToWithdraw)){
            /* If the withdrawal failed, restore the balance */
            ownerBalance += fundToWithdraw;
            status = false;
        }
        /* Logging the withdrawal event */
        LogWithDrawal(initiator,fundToWithdraw, status);
    }
}
