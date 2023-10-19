// SPDX-License-Identifier: MIT


// Here the overview of the challenge is to create  the contract in which owner
// only have the permission to mint the tokens to the given specific address
// And other is any user should be able to burn and transfer tokens.

pragma solidity 0.8.18;
// This is an interface for the ERC-20 standard functions that any ERC-20 token contract must implement.


interface IERC20 {
    // This  totalSupply function returns the total supply of tokens.
    function totalSupply() external view returns (uint);
    
//  The balanceOf function returns the balance of tokens for a given address.
    function balanceOf(address account) external view returns (uint);
// The transfer function allows an address to send tokens to another address.
    function transfer(address recipient, uint amount) external returns (bool);

    // The allowance function returns the amount of tokens that an address is allowed to spend on behalf of another address
    function allowance(address owner, address spender) external view returns (uint);
    
// The approve function allows an address to approve another address to spend a certain amount of tokens.
    function approve(address spender, uint amount) external returns (bool);
    
 // The transferFrom function allows an approved address to spend tokens on behalf of the owner.
    function transferFrom(address spender, address recipient, uint amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint amount);
    event Approval(address indexed owner, address indexed spender, uint amount);
}

// This contract inherits from the IERC20 interface and implements the ERC-20 functions.
contract ERC20 is IERC20 {
    address public immutable owner;
    uint public totalSupply;
    
// A mapping to store the balances of token holders.
    mapping (address => uint) public balanceOf;
    mapping (address => mapping (address => uint)) public allowance;
    
// The 'owner' is set to the address that deployed the contract.
    constructor() {
        owner = msg.sender;
    }
    modifier onlyOwner {
        require(msg.sender == owner, "Only owner can execute this function");
        // Only the owner can execute functions with this modifier.
        _; // Continue with the function's execution.
    }

    string public constant name = "ABHI";
    string public constant symbol = "AB";
    uint8 public constant decimals = 18;
   
   // Allows the sender to transfer tokens to another address and 
   // Checks if the sender has a sufficient balance to perform the transfer.
    function transfer(address recipient, uint amount) external returns (bool) {
        require(balanceOf[msg.sender] >= amount, "Insufficient Balance");
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }
 // this function allows the sender to approve another address to spend tokens on their behalf and
  // Ensures that the approval amount is positive.
    function approve(address spender, uint amount) external returns (bool) {
        require(amount > 0, "Approval amount must be greater than zero");
        allowance[msg.sender][spender] += amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    // this function transfer from allows an approved address to transfer tokens on behalf of the owner.
    function transferFrom(address sender, address recipient, uint amount) external returns (bool) {
 // Check if the sender has a sufficient balance and the spender is allowed to spend the required amount.
        require(balanceOf[sender] >= amount, "Insufficient Balance");
        require(allowance[sender][msg.sender] >= amount, "Less approval to spend tokens");
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }
     // Allows the owner to mint new tokens.
    function mint(uint amount) external onlyOwner {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }
 // Allows an address to burn  their own tokens.
    function burn(uint amount) external {
        require(amount > 0, "Amount should not be zero");
        require(balanceOf[msg.sender] >= amount, "Insufficient Balance");
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
       
    }
}
