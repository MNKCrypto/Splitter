pragma solidity ^0.4.21;

//@title Splitter Contract  - Allows a single party to split ether among two recievers
//@author Naveen Kumar M - <naveen.k.manickam@gmail.com>
contract Splitter {
    address public owner;
    mapping(address=>uint) public userBalance;
    /* Event to log registered receivers */
    event LogCreateContract(address indexed owner);
    /* Event to log transactions */
    event LogSplit(address indexed receiver1,address indexed reciever2,address indexed owner, uint256 receiverShare, uint256 ownerShare); 
    /* Event to log withdrawals */
    event LogWithDrawal(address indexed receiver1,uint256 value);
    
    // modifier
    modifier onlyOwner {
	require (msg.sender == owner);
    	_;
    }

    // @dev constructor - validates whether valid receiver addresses are passed and stores them in
    // contract storage
    function Splitter() public  {
        owner = msg.sender;
        emit LogCreateContract(owner);
    }	

    // Public functions
    // @dev This function allows owner address to split funds equally
    // among the receivers
    function splitFunds(address receiver1, address receiver2) public payable onlyOwner{
        /* Validate receiver address */
       require (receiver1 != address(0), "Receiver 1 Address is required");
       require (receiver2 != address(0), "Receiver 2 Address is required");
       uint fundsSent = msg.value;
       uint singleShare = fundsSent/2; 
       uint remainingShare = 0;
       userBalance[receiver1] += singleShare;  
       userBalance[receiver2] += singleShare;
       if (fundsSent  != (2*singleShare)){
          userBalance[msg.sender]  += 1;
	  remainingShare = 1;
       }	
       emit LogSplit(receiver1,receiver2,owner,singleShare,remainingShare);
    }

    // @dev This function allows receivers / owners to withdraw their balance
    // fund from the contract
    // @param Fund to be withdrawn
    function withDrawFunds(uint fundToWithdraw) public {
       address initiator = msg.sender;
       uint balanceFund = userBalance[initiator];
       require(balanceFund > 0, "Zero Balance");
       require(fundToWithdraw <= balanceFund, "Insufficient Balance");       
       userBalance[initiator] -= fundToWithdraw;
       emit LogWithDrawal(initiator,fundToWithdraw);
       initiator.transfer(fundToWithdraw);
    }

}
