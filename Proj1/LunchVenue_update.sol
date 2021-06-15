// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

/// @title Contract to agree on the lunch venue
contract LunchVenue{
    
    struct Friend { 
        string name;
        bool voted; 
    }

    struct Vote {
        address voterAddress; 
        uint venue;
    }
    
    
    mapping (uint => string) public venues; 
    mapping(address => Friend) public friends;

    uint public numVenues = 0; 
    uint public numFriends = 0;
    uint public numVotes = 0;
    address public manager; 
    string public votedVenue = ""; //Where to have lunch
    
    uint public voteStartTime;
    uint public voteEndTime;
    uint public temp;

    
    mapping (uint => Vote) private votes;
    mapping (uint => uint) private results; 
    bool voteOpen = false; //voting is open

    //Creates a new lunch venue contract
    constructor () {
        manager = msg.sender; //Set contract creator as manager 
    }
    

    function addVenue(string memory name) public restricted returns (uint){
        numVenues++; 
        venues[numVenues] = name;
        return numVenues; 
    }
    

    function addFriend(address friendAddress, string memory name) public restricted returns (uint){
        Friend memory f; 
        f.name = name;
        f.voted = false;
        friends[friendAddress] = f;   
        numFriends++;
        return numFriends; 
    }
    
    function createStartTime(uint time) public restricted returns (uint){
        voteStartTime = time;
        return voteStartTime;
    }
    
    function createEndTime(uint time) public restricted returns (uint){
        voteEndTime = time;
        return voteEndTime;
    }
    
    function getBlockNum() public returns (uint) {
        temp = block.timestamp;
        return temp;
    }
    
    function doVote(uint venue) public votingOpen returns (bool validVote){ 
        validVote = false; //Is the vote valid?
        if(friends[msg.sender].voted != true){
            if (bytes(friends[msg.sender].name).length != 0) { //Does friend exist? 
                if (bytes(venues[venue]).length != 0) { //Does venue exist?
                    validVote = true;
                    friends[msg.sender].voted = true; 
                    Vote memory v;
                    v.voterAddress = msg.sender; 
                    v.venue = venue;
                    numVotes++; 
                    votes[numVotes] = v;
                } 
            }
        }
        
        if (numVotes >= numFriends/2 + 1) { //Quorum is met
            finalResult(); 
        }
        return validVote; 
    }
    
    /// @notice Determine winner venue
    /// @dev If top 2 venues have the same no of votes, final result depends on vote order
    function finalResult() private{ 
        uint highestVotes = 0;
        uint highestVenue = 0;
        
        for (uint i = 1; i <= numVotes; i++){ //For each vote 
            uint voteCount = 1;
            if(results[votes[i].venue] > 0) { // Already start counting 
            voteCount += results[votes[i].venue];
            }
            results[votes[i].venue] = voteCount;

            if (voteCount > highestVotes){ // New winner
                highestVotes = voteCount; highestVenue = votes[i].venue;
            } 
            
        }
        votedVenue = venues[highestVenue]; //Chosen lunch venue 
        voteOpen = false; //Voting is now closed
    }
    
    /// @notice Only manager can do
    modifier restricted() {
        require (msg.sender == manager, "Can only be executed by the manager"); 
        _;
    }
    /// @notice Only whenb voting is still open
    modifier votingOpen() {
        uint currentTime;
        currentTime = block.timestamp;
        
        if (currentTime < voteEndTime && currentTime > voteStartTime){
            voteOpen = true;
        }
        else{
            voteOpen = false;
        }
        
        require(voteOpen == true, "Can vote only while voting is open."); 
        _;
    } 
    
}