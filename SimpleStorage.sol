// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract SimpleStorage {
    
    uint256 private _storedData; 
    
    function setStoredData(uint256 value_) external {
        _storedData = value_; 
    }
    
    function storedData() external view returns(uint256) {
        return _storedData; 
    }

}