//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

import {StringUtils} from "./libraries/StringUtils.sol";
import "hardhat/console.sol";

contract Domains{
    //Top-level-domain(tld)
    string public tld;

    mapping(string => address) public domains; //for storing addresses
    mapping (string => string) public records; //for storing records
    
    //made the constructor payable
    constructor(string memory _tld) payable {
        tld = _tld;
        console.log("%s name service deployed", _tld);
    }

    //this gives the price of the domain depending on the lenght
    function price(string calldata name) public pure returns(uint){
        uint len = StringUtils.strlen(name);
        require(len > 0);
        if(len == 3)
        {
            return 5 * 10**17;
        }
        else if(len == 4) {
            return 3 * 10**17;
        }
        else{
            return 1 * 10**17;
        }
    }

    //this function will map the domain names with the owners address
    function register(string calldata name) public {
        require(domains[name] == address(0)); //checks whether the domain is not taken by someone else
        uint _price = price(name);
        require(msg.value >= _price, "Not enough Matic paid");
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