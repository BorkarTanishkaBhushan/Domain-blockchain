//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

import "hardhat/console.sol";

contract Domains{
    mapping(string => address) public domains;

    constructor(){
        console.log("This is my domain contract and it is running");
    }

    //this function will map the domain names with the owners address
    function register(string calldata name) public {
        domains[name] = msg.sender;
        console.log("%s has regitered a domain!", msg.sender);
    }

    //this function is simply viewing and returning the addresses of the required domain names
    function getAddress(string calldata name) public view returns (address) {
        return domains[name];
    }

    
}