//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

import "hardhat/console.sol";

contract Domains{
    mapping(string => address) public domains; //for storing addresses
    mapping (string => string) public records; //for storing records
    constructor(){
        console.log("This is my domain contract and it is running");
    }

    //this function will map the domain names with the owners address
    function register(string calldata name) public {
        require(domains[name] == address(0)); //checks whether the domain is not taken by someone else
        domains[name] = msg.sender;
        console.log("%s has regitered a domain!", msg.sender);
    }

    //this function is simply viewing and returning the addresses of the required domain names
    function getAddress(string calldata name) public view returns (address) {
        return domains[name];
    }

    //this function will first check whether the owner is only calling the setRecord function
    //if thats true then and only then the record is mapped to domain name
    function setRecord(string calldata name, string calldata record) public {
        //checks that the owner is the transcation sender
        require(domains[name] == msg.sender);
        records[name] = record;
    }

    //returns the record that is mapped with the required name
    function getRecord(string calldata name) public view returns(string memory){
        return records[name];
    }


}