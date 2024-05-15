// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;


contract Counter {

    uint public counter;

    event update(
        address indexed senderAddress,
        uint indexed intToAdd, 
        uint currentCount,
        uint blockNumber
    );

    event reset(
        address indexed senderAddress,
        uint blocknumber, 
        uint currentCount
    );

    constructor() {
        counter = 0;
    }

    function updateCounter(uint updateAmount) external returns(uint256){
        counter += updateAmount;
        emit update(msg.sender, updateAmount, counter, block.number);
        return counter;
    }


    function resetCounter() public returns(uint256){
        counter = 0;
        emit reset(msg.sender, block.number, counter);
        return counter;
    }
}