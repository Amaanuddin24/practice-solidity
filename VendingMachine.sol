// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Define the VendingMachine contract
contract VendingMachine
{
// Store the owner address
address public owner;

// Mapping to store donut balances of addresses
mapping (address => uint) public donutBalances;

// Constructor to set the owner and initialize the donut balance of the vending machine
constructor()
{
    // Set the owner to the address of the contract deployer
    owner = msg.sender;
    // Set the initial donut balance of the vending machine to 100
    donutBalances[address(this)] = 100;
}

// Function to get the balance of the vending machine
function getVendingMachineBalance() public view returns (uint)
{
    // Return the donut balance of the vending machine
    return donutBalances[address(this)];
}

// Function to restock the vending machine
function restock(uint amount) public 
{
    // Require the msg.sender to be the owner
    require(msg.sender == owner, "Only the owner can restock this machine.");
    // Increase the donut balance of the vending machine by the restock amount
    donutBalances[address(this)] += amount;
}

// Function to purchase donuts from the vending machine
function purchase (uint amount) public payable{
    // Require the msg.value to be at least 2 ether per donut
    require(msg.value >= amount * 2 ether, "You must pay at least 2 ether per donut");
    // Require the vending machine to have enough donuts in stock to fulfill purchase request
    require(donutBalances[address(this)] >= amount, "Not enough donuts in stock to fulfill purchase request");
    // Decrease the donut balance of the vending machine by the purchase amount
    donutBalances[address(this)] -= amount;
    // Increase the donut balance of the purchasing address by the purchase amount
    donutBalances[msg.sender] += amount;
}

}