//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import {StringUtils} from "./libraries/StringUtils.sol";
import {Base64} from "./libraries/Base64.sol";

import "hardhat/console.sol";

contract Domains is ERC721URIStorage { //Domain contract is now inherited the props and funcs of ERC721URIStorage contract
    
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds; //_tokenIds initialized to zero
    //above thing helps to keep track of tokenIds

    
    //Top-level-domain(tld)
    string public tld;

    //defining the svg format for the NFT images of the domains
    string svgPartOne = '<svg xmlns="http://www.w3.org/2000/svg" width="270" height="270" fill="none"><path fill="url(#a)" d="M0 0h270v270H0z"/><defs><filter id="b" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse" height="270" width="270"><feDropShadow dx="0" dy="1" stdDeviation="2" flood-opacity=".225" width="200%" height="200%"/></filter></defs><path d="M72.863 42.949a4.382 4.382 0 0 0-4.394 0l-10.081 6.032-6.85 3.934-10.081 6.032a4.382 4.382 0 0 1-4.394 0l-8.013-4.721a4.52 4.52 0 0 1-1.589-1.616 4.54 4.54 0 0 1-.608-2.187v-9.31a4.27 4.27 0 0 1 .572-2.208 4.25 4.25 0 0 1 1.625-1.595l7.884-4.59a4.382 4.382 0 0 1 4.394 0l7.884 4.59a4.52 4.52 0 0 1 1.589 1.616 4.54 4.54 0 0 1 .608 2.187v6.032l6.85-4.065v-6.032a4.27 4.27 0 0 0-.572-2.208 4.25 4.25 0 0 0-1.625-1.595L41.456 24.59a4.382 4.382 0 0 0-4.394 0l-14.864 8.655a4.25 4.25 0 0 0-1.625 1.595 4.273 4.273 0 0 0-.572 2.208v17.441a4.27 4.27 0 0 0 .572 2.208 4.25 4.25 0 0 0 1.625 1.595l14.864 8.655a4.382 4.382 0 0 0 4.394 0l10.081-5.901 6.85-4.065 10.081-5.901a4.382 4.382 0 0 1 4.394 0l7.884 4.59a4.52 4.52 0 0 1 1.589 1.616 4.54 4.54 0 0 1 .608 2.187v9.311a4.27 4.27 0 0 1-.572 2.208 4.25 4.25 0 0 1-1.625 1.595l-7.884 4.721a4.382 4.382 0 0 1-4.394 0l-7.884-4.59a4.52 4.52 0 0 1-1.589-1.616 4.53 4.53 0 0 1-.608-2.187v-6.032l-6.85 4.065v6.032a4.27 4.27 0 0 0 .572 2.208 4.25 4.25 0 0 0 1.625 1.595l14.864 8.655a4.382 4.382 0 0 0 4.394 0l14.864-8.655a4.545 4.545 0 0 0 2.198-3.803V55.538a4.27 4.27 0 0 0-.572-2.208 4.25 4.25 0 0 0-1.625-1.595l-14.993-8.786z" fill="#fff"/><defs><linearGradient id="a" x1="0" y1="0" x2="270" y2="270" gradientUnits="userSpaceOnUse"><stop stop-color="#00FF0A"/><stop offset="1" stop-color="#F9FE09"/></linearGradient></defs><text x="32.5" y="231" font-size="27" fill="#fff" filter="url(#b)" font-family="Plus Jakarta Sans,DejaVu Sans,Noto Color Emoji,Apple Color Emoji,sans-serif" font-weight="bold">';
    string svgPartTwo = '</text></svg>';


    mapping(string => address) public domains; //for storing addresses
    mapping (string => string) public records; //for storing records
    
    //made the constructor payable
    //NFT Collections's name: Smaash Name Service
    //NFT's Symbol: SNS
    constructor(string memory _tld) payable ERC721("Smaash Name Service", "SNS"){
        tld = _tld;
        console.log("%s name service deployed", _tld);
    }

    //this gives the price of the domain depending on the lenght
    function price(string calldata name) public pure returns(uint){
        uint len = StringUtils.strlen(name);
        require(len > 0);
        if(len == 3)
        {
            return 2 * 10**18;
        }
        else if(len == 4) {
            return 0.01 * 10**18;
        }
        else{
            return 0.1 * 10**18;
        }
    }

    //this function will map the domain names with the owners address
    function register(string calldata name) public payable{
        require(domains[name] == address(0)); //checks whether the domain is not taken by someone else
        uint _price = price(name);
        console.log("Matic to be paid: %d", _price);
        require(msg.value >= _price, "Not enough Matic paid");

        //combining the name passed with the TLD
        string memory _name = string(abi.encodePacked(name, ".", tld));
        //creating an svg for the NFT for the name
        string memory finalSvg = string(abi.encodePacked(svgPartOne, _name, svgPartTwo));

        uint newRecordId = _tokenIds.current();
        uint length = StringUtils.strlen(name); 
        string memory strLen = Strings.toString(length);

        console.log("Registering %s.%s on the contract with tokenID %d", name, tld, newRecordId);

        //Creating JSON metadata of our NFT by combining strings and encoding as base64
        string memory json = Base64.encode(
            abi.encodePacked(
                '{"name": "',
                _name,
                '", "description": "A domain on the Smaash name service", "image": "data:image/svg+xml;base64,',
                Base64.encode(bytes(finalSvg)),
                '","length":"',
                strLen,
                '"}'
            )
        );

        string memory finalTokenUri = string( abi.encodePacked("data:application/json;base64,", json));

        console.log("\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
        console.log("Final tokenURI: ", finalTokenUri);
        console.log("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n");
        
        _safeMint(msg.sender, newRecordId);
        _setTokenURI(newRecordId, finalTokenUri);
        domains[name] = msg.sender;

        _tokenIds.increment();
            // console.log("%s has registered a domain!", msg.sender);
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