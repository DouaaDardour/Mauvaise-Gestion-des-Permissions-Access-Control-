// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VulnerableVault {
    // Public variable that anyone can change - THIS IS THE BUG!
    address public owner;
    uint256 public withdrawalLimit = 1 ether;
    
    mapping(address => uint256) public balances;
    
    // Constructor sets the deployer as owner
    constructor() {
        owner = msg.sender;
    }
    
    // Deposit money
    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }
    
    // BUG HERE: No "onlyOwner" modifier! Anyone can call this!
    function changeWithdrawalLimit(uint256 _newLimit) external {
        withdrawalLimit = _newLimit;
    }
    
    // Withdraw money (only owner can withdraw everything)
    function withdraw(uint256 _amount) external {
        require(balances[msg.sender] >= _amount, "Not enough balance");
        require(_amount <= withdrawalLimit, "Exceeds limit");
        
        balances[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);
    }
}
