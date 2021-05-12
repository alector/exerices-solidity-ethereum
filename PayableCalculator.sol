// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol";


contract PayableCalculator {
    
    address private _owner;
    uint256 private _operationCost; 
    uint256 public result; 
    uint256 public _operationsTotalProfit;
    mapping(address => uint256) private _balances;
    mapping(address => uint256) private _operations;
    
    event DepositByOperation(address indexed sender, uint256 amount);
    event WithdrawAllProfit(address indexed recipient, uint256 amount);

    
    uint256 private _totalOperations; 

    using Address for address payable; 
    
    constructor () {
        _owner = msg.sender; 
        _operationCost = 1000000000000000; 
    }
    
    
    modifier onlyOwner() {
        require(msg.sender == _owner, "Ownable: Only owner can call this function");
        _;
    }

    
    function setOperationCost(uint256 cost) onlyOwner external {
        _operationCost = cost; 
    }
    
    function deposit() external payable {
        _deposit(msg.sender, msg.value);
    }


    function _deposit(address sender, uint256 amount) private {
        _balances[sender] += amount;
        _operations[sender] += 1; 
        _totalOperations += 1;
        emit DepositByOperation(sender, amount);
    }


    function _withdrawByOperation (address sender) private {
        require( _balances[sender]>= _operationCost, "Not enough ether to perform this operation"); 
        _balances[sender] -= _operationCost; 
        _operationsTotalProfit += _operationCost;

    }
    

  
    function add(uint256 num1_, uint256 num2_) public returns(uint256) {
        _withdrawByOperation(msg.sender); 
        result = num1_ + num2_ ; 
        return result; 
        
    }
    
    function mul(uint256 num1_, uint256 num2_) public returns(uint256) {
        _withdrawByOperation(msg.sender); 
        result = num1_ * num2_ ; 
        return result; 
        
    }


    function div(uint256 num1_, uint256 num2_) public returns(uint256) {
        _withdrawByOperation(msg.sender); 
        require(num2_>0, "Can't divide by zero");
        result = num1_ / num2_ ; 
        return result; 
        
    }
    
    function sub(uint256 num1_, uint256 num2_) public returns(uint256) {
        _withdrawByOperation(msg.sender); 
        result = num1_ - num2_ ; 
        return result; 
        
    }
    
    function modulo(uint256 num1_, uint256 num2_) public returns(uint256) {
        _withdrawByOperation(msg.sender); 
        result = num1_ % num2_ ; 
        return result; 
        
    }
    
    
    function withdrawProfit() public onlyOwner {
        require(_operationsTotalProfit > 0, "PayableCalculator: can not withdraw 0 ether");
        uint256 amount = _operationsTotalProfit;
        _operationsTotalProfit = 0;

        // totalAmmount = address(this).balance 
        payable(_owner).sendValue(amount);
        emit WithdrawAllProfit (_owner, amount); 
    }


}