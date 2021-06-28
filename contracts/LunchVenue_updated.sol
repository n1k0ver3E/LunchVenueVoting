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
    
    mapping (uint => Vote) private votes;
    mapping (uint => uint) private results; 
    bool voteOpen = true; //voting is open
    
    // addVenue and addFriend should be done before voting start
    uint public votingStartBlock;
    uint public votingEndBlock;
    

    //Creates a new lunch venue contract
    constructor () {
        manager = msg.sender; //Set contract creator as manager 
    }
    

    function addVenue(string memory name) public  addingOpen restricted returns (uint){
        numVenues++; 
        venues[numVenues] = name;
        return numVenues; 
    }
    
    function addFriend(address friendAddress, string memory name) public addingOpen restricted  returns (uint){
        Friend memory f; 
        f.name = name;
        f.voted = false;
        friends[friendAddress] = f;   
        numFriends++;
        return numFriends; 
    }
    
    /// setting StartBlock, add friend and add venue must be finished before StartBlock. (for q2)
    /// before StartBlock it's the preparing phrase; 
    /// During the StartBlock and EndBlock, it's the voting phrase; after EndBlock is the finishing phrase
    function addStartBlock(uint blockNum) public restricted returns (uint){
        votingStartBlock = blockNum;
        return votingStartBlock;
    }
    
    /// setting Ending Block, votingEndBlock = StartBlock + param, (for q3)
    function addEndBlock(uint blockNum) public restricted returns (uint256){
        uint expireOf = blockNum;
        votingEndBlock = votingStartBlock + expireOf;
        return votingEndBlock;
    }
    
    /// Setting printCurrentBlock to callback the latest blocknumber, 
    /// And to verify whether the block number is beyond the timeout(votingEndBlock), for q3
    function printCurrentBlock() public restricted returns (uint){
        uint currentBlock = block.number;
        if (currentBlock >= votingEndBlock){
            finalResult();
        }
        return currentBlock;
    }
    

    function doVote(uint venue) public votingOpen returns (bool validVote){ 
        validVote = false; //Is the vote valid?
        if (bytes(friends[msg.sender].name).length != 0) { //Does friend exist? 
            if (bytes(venues[venue]).length != 0) { //Does venue exist?
                validVote = true;
                Vote memory v;
                v.voterAddress = msg.sender; 
                v.venue = venue;
                if (friends[msg.sender].voted == false){   //only if the friend never vote, the numvotes could be added. (for q1)
                    numVotes++; 
                }
                friends[msg.sender].voted = true;  // if  the friend.voted=true, the numvotes could not be added. (for q1)
                votes[numVotes] = v;
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
    
    /// only manager can kill the contract, for q4
    function kill() public restricted returns (bool killRes){
        selfdestruct(payable(msg.sender));
        killRes = true;
        return killRes;
    }
        
    
    /// @notice Only manager can do
    modifier restricted() {
        require (msg.sender == manager, "Can only be executed by the manager"); 
        _;
    }
    
    /// @notice Only whenb voting is still open
    modifier votingOpen() {
        require(voteOpen == true, "Can vote only while voting is open."); 
        _;
    } 
    
    modifier addingOpen() {
        require(
            votingStartBlock > 0 && votingEndBlock > 0,
            "Setting StartBlock and EndBlock firstly."
            );
            
        require(
            block.number <= votingStartBlock,
            "Execution Error."
        );
        _;
    }
    
    
    
}