// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.17;

contract LotteryGame {
    // address of the contract owner
    address owner;
    // array to store addresses of players
    address payable[] public players;

    address public winner;

    constructor() {
        // set the owner of the contract to the message sender
        owner = msg.sender;
    }

    receive() external payable {
        // require that the value sent with the message is 1 ether
        require(msg.value == 1 ether, "The bet must be 1 ether.");
        // add the message sender to the players array
        players.push(payable(msg.sender));
    }

    function pickWinner() public {
        // require that the message sender is the contract owner
        require(msg.sender == owner, "Only the contract owner can pick a winner.");
        // require that there are at least 3 players in the lottery
        require(players.length >= 3, "There must be at least 3 players in the lottery.");

        // generate a random number
        uint randomNumber = random();
        // calculate the index of the winner using the random number
        uint index = randomNumber % players.length;
        // get the address of the winner from the players array
        address payable winnerAddress = players[index];
        
        winner = winnerAddress;
        // transfer the contract balance to the winner's address
        winnerAddress.transfer(getBalance());
        // reset the game by clearing the players array
        resetGame();
    }

    function getBalance() public view returns (uint) {
        // require that the message sender is the contract owner
        require(msg.sender == owner, "Only the contract owner can view the balance.");
        // return the balance of the contract
        return address(this).balance;
    }

    function random() private view returns (uint) {
        // generate a random number using keccak256 hash function
        // and the block difficulty, timestamp, and players length as input
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }

    function resetGame() private {
        // reset the game by creating a new empty players array
        players = new address payable[](0);
    }
}
