// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract CheckOdd {

    function check(uint256 var_) external pure returns(bool) {
        bool odd = var_ % 2 == 0? false: true; 
        return odd; 
    }

}