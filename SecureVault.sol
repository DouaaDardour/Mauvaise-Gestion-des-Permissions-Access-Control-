// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SecureVault {
    address public owner;
    uint256 public withdrawalLimit = 1 ether;
    
    mapping(address => uint256) public balances;
    
    // MODIFIER: Only owner can call functions with this
    modifier onlyOwner() {
        require(msg.sender == owner, "NOT_OWNER");
        _;
    }
    
    constructor() {
        owner = msg.sender;
    }
    
    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }
    
    // FIXED: Added onlyOwner modifier!
    function changeWithdrawalLimit(uint256 _newLimit) external onlyOwner {
        withdrawalLimit = _newLimit;
    }
    
    function withdraw(uint256 _amount) external {
        require(balances[msg.sender] >= _amount, "Not enough balance");
        require(_amount <= withdrawalLimit, "Exceeds limit");
        
        balances[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);
    }
}
