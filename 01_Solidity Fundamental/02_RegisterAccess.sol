// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract RegisterAccess{
    string[] private info;
    address public owner;
    mapping (address => bool) allowList;

    constructor(){
        owner = msg.sender;
        allowList[msg.sender] = true;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only owner");
        _;
    }

    modifier onlyAllowList {
        require(allowList[msg.sender] == true, "Only whitelist");
        _;
    }

    event InfoChange(string oldInfo, string newInfo);

    function getInfo(uint index) public view returns (string memory){
        return info[index];
    }

    function infoList() public view returns (string[] memory){
        return info;
    }

    function addInfo(string memory _info) public onlyAllowList returns(uint index){
        info.push(_info);
        index = info.length - 1;
    }

    function setInfo(uint index, string memory _info) public onlyAllowList{
        emit InfoChange (info[index], _info);
        info[index] = _info;
    }

    function addMember(address _member) public onlyOwner{
        allowList[_member] = true;
    }

     function delMember(address _member) public onlyOwner{
        allowList[_member] = false;
    }
}