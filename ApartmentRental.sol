// Step 1: License & Solidity version (5 pts)
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ApartmentRental {

    // Step 2: Contract owner (5 pts)
    address payable public owner;

    // Step 3: At least two other state variables (10 pts)
    bool public available;
    uint public rentPerMonth;
    address public tenant;

    // Step 7: Event (15 pts)
    event Log(address indexed sender, string message);

    // Step 4: Initial conditions set in the constructor (10 pts)
    constructor() {
        owner = payable(msg.sender);
        available = true;
        rentPerMonth = 1 ether;
    }

    // Step 6: Two modifiers (15 pts)

    // Modifier 1: only the owner can call the function
    modifier onlyOwner() {
        require(msg.sender == owner, "Must be the contract owner to use this function.");
        _;
    }

    // Modifier 2: the apartment must be available
    modifier isAvailable() {
        require(available, "Apartment is not available.");
        _;
    }

    // Step 5: At least three public functions (20 pts)

    // Function 1: rent the apartment
    function rentApartment(uint numMonths) public payable isAvailable {
        // Check payment
        uint totalRent = rentPerMonth * numMonths;
        require(msg.value >= totalRent, "Not enough money to rent the apartment.");

        // Send payment to the owner
        (bool sent, ) = owner.call{value: msg.value}("");
        require(sent, "Transaction failed. Try again.");

        tenant = msg.sender;
        available = false;
        emit Log(msg.sender, "Apartment is rented.");
    }

    // Function 2: owner makes the apartment available again
    function makeApartmentAvailable() public onlyOwner {
        available = true;
        tenant = address(0);
        emit Log(msg.sender, "Apartment is now available.");
    }

    // Function 3: owner updates the monthly rent
    function updateRent(uint newRent) public onlyOwner {
        rentPerMonth = newRent;
        emit Log(msg.sender, "Rent has been updated.");
    }

    // Step 8: Transfer ownership of the contract (20 pts)
    function transferOwnership(address payable newOwner) public onlyOwner {
        owner = newOwner;
        emit Log(msg.sender, "Apartment has a new owner.");
    }
}
