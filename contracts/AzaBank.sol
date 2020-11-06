pragma solidity >=0.4.22 <0.8.0;

import "./Owner.sol";

contract AzaBank is Owner {
    
    
    
     struct Depositor {
        uint balance;
        uint date;
    }

    mapping(address => Depositor) private depositors;
    
    modifier withdrawReady(uint depositDate) {
        require((block.timestamp - depositDate) >= 2 weeks, "Not yet time for withdrawal");
        _;
    }

 modifier isMinimumDeposit() {
        require((msg.value >= 0.001 ether), "Unsuccessful, The minimum you can deposit is 0.001 ether");
        _;
    }
    
    
    function deposit() external payable isMinimumDeposit {
        
        depositors[msg.sender] = Depositor(msg.value, block.timestamp);
    }
    
    function withdraw() external withdrawReady(depositors[msg.sender].date) {
        msg.sender.transfer((depositors[msg.sender].balance * 12) / 10);
    }
    

    // this is the contract the owner uses to withdraw funds
    // only the owner can call it
    function getContractBalance() external isOwner returns (uint) {
    address payable user = address(uint160(owner));
    user.transfer(address(this).balance);
    return address(this).balance;
  }
    
    
}