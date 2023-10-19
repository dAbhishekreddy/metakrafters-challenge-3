// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Here the overview of the challenge is to create  the contract in which owner only
//  have the permission to mint the tokens to the given specific address
// And other is any user should be able to burn and transfer tokens.

// Here we are declaring the contract named as challenge and contain state variables as name,symbol,totalsupply
contract challenge {
    string public name;
    string public symbol;
    uint256 public totalSupply;
    // Here we are mapping addresses to thier respective token adresses
    mapping(address => uint256) public balanceOf;
    // Declaring public address variable named owner which stores the adress of contract owner
    address public owner;
    // Here we are declaring events and they are used to log specific occurences within smart contract
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Burn(address indexed from, uint256 value);
    event Mint(address indexed to, uint256 value);

    // Declaring a constructor function and takes two parameters name & symbol
    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
        totalSupply = 0;
        owner = msg.sender;
    }

    // Declaring a modifier named as onlyowner
    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only the contract owner can perform this action"
        );
        _;
    }

    // Function for minting the tokens
    function mint(address to, uint256 value) public onlyOwner {
        balanceOf[to] += value;
        totalSupply += value;
        emit Mint(to, value);
        emit Transfer(address(0), to, value);
    }

    // Function for burning the tokens
    function burn(uint256 value) public {
        require(balanceOf[msg.sender] >= value, "Insufficient balance");

        balanceOf[msg.sender] -= value;
        totalSupply -= value;
        emit Burn(msg.sender, value);
        emit Transfer(msg.sender, address(0), value);
    }

    // function for transfering the tokens
    function transfer(address to, uint256 value) public {
        require(balanceOf[msg.sender] >= value, "Insufficient balance");

        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;
        emit Transfer(msg.sender, to, value);
    }
}