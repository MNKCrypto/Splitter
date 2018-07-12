pragma solidity ^0.4.21;

//@title Splitter Contract  - Allows a single party to split ether among two recievers
//@author Naveen Kumar M - <naveen.k.manickam@gmail.com>
contract Splitter {
    address public owner;
    bool isPaused;
    mapping(address=>uint) public userBalance;
    /* Event to log registered receivers */
    event LogCreateContract(address indexed owner);
    /* Event to log transactions */
    event LogSplit(address indexed receiver1,address indexed reciever2,address indexed sender, uint256 receiverShare, uint256 senderShare); 
    /* Event to log withdrawals */
    event LogWithDrawal(address indexed receiver1,uint256 value);
    
    
    // @dev constructor - validates whether valid receiver addresses are passed and stores them in
    // contract storage
    function Splitter() public  {
        owner = msg.sender;
        isPaused = false;
        emit LogCreateContract(owner);
    }	
    
    //modifier
    modifier onlyOwner{
        require(msg.sender == owner);
        _;
    }
    
    modifier isActive {
        require(!isPaused);
        _;
    }

    // Public functions
    // @dev This function allows any user to split funds equally
    // among the receivers
    function splitFunds(address receiver1, address receiver2) public payable isActive {
        /* Validate receiver address */
       require (receiver1 != address(0), "Receiver 1 Address is required");
       require (receiver2 != address(0), "Receiver 2 Address is required");
       uint singleShare = msg.value/2; 
       uint remainingShare = 0;
       userBalance[receiver1] += singleShare;  
       userBalance[receiver2] += singleShare;
       if (msg.value  != (2*singleShare)){
          userBalance[msg.sender]  += 1;
	      remainingShare = 1;
       }	
       emit LogSplit(receiver1,receiver2,msg.sender,singleShare,remainingShare);
    }

    // @dev This function allows receivers / owners to withdraw their balance
    // fund from the contract
    // @param Fund to be withdrawn
    function withDrawFunds(uint fundToWithdraw) public isActive{
       uint balanceFund = userBalance[msg.sender];
       require(balanceFund > 0, "Zero Balance");
       require(fundToWithdraw <= balanceFund, "Insufficient Balance");       
       userBalance[msg.sender] -= fundToWithdraw;
       emit LogWithDrawal(msg.sender,fundToWithdraw);
       msg.sender.transfer(fundToWithdraw);
    }
    
    // @dev This function allows contract owner to pause the active contract 
    function pauseContract() public  onlyOwner {
        isPaused = true;
    }
    
    // @dev This function allows contract owner to re-activate the paused
    //      contract
    function resumeContract() public onlyOwner {
        isPaused = false;
    }
}
