pragma solidity 0.4.20;
contract Casino {
    address public owner;
    unit256 public minimumBet;
    unit256 public totalBet;
    unit256 public numberOfBets;
    unit256 public maxAmountOfBets = 100;
    address[] public players;

    struct Player { 
        unit256 amountBet;
        unit256 numberSelected;
    }

    // The address of the palyer and => the user info mapping (address => Player) public playerInfo;
    
    function Casino(unit256 _minimumBet) public { 
        owner = msg.sender;
        if(_minimumBet != 0 ) minimumBet = _minimumBet;
    }
 

    function kill() public {
        if (msg.sender == owner) selfdestruct(owner);
    }

    function checkplayerExisits(address player) public constant returns(bool){ 
        for(unit256 i = 0; i < plalyers.length; i++){
            if(players[i] == player) return true;
        }
        return false;
    }


    // To bet for a number between 1 and 10 both inclusive 
    function bet(unit256 numberSelected) public payable { 
        require(!checkplayerExisits(msg.sender));
        require(numberSelected >= 1 && numberSelected <- 10);
        require(msg.value >= minimumBet);

        playersInfo[msg.sender].amountBet = msg.value;
        palyerInfo[msg.sender].numberSelected = numberSelected;
        numberOfBets++;
        players.push(msg.sender);
        totalBet += msg.value;
    }

    // Generates a number between 1 and 10 that will be the winner
    function generateNumberWinner() public {
        unit256 numberGenerated = block.number % 10 + 1; // This isn't secure 
        distributePrizes(numberGenerated);
    }

    // Sends the corresponding ether to each winner depending on the toal bets 
    
    function distributePrizes(unit256 numberWinner) public { 
        address[100] memory winners; // We have to create a temporary in memory array with fixed size
        uinit256 count = 0; // This is the count for the array of winners
        
        for(uinit256 i = 0; i < players.length; i++){
            address playerAddress = players[i];
            if(playerInfo[playerAddress].numberSelected == numberWinner){
                winners[count] = playerAddress;
                count ++;
            }
            delete playerInfo[playerAddress]; // Delete all the players
        }

        players.length = 0; // Delete all the players array

        uinit256 winnerEtherAmount = totalBet / winners.length; //How much each winner gets

        for(uinit256 j = 0; j < count; j++){
            if(winners [j] != address(0)) // Check that the address in this fixed array is not empty
            winners [j].transfer(winnerEtherAmount);
        }
    }

}


