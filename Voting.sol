//SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

contract Voting {
    address public owner;
    bool public VotingOpen;

    struct Candidate{
        uint id;
        string name;
        uint voteCount;
    }
    struct Voter{
        bool voted;
        uint candidateId;
    }
    mapping(uint => Candidate) public candidates;
    mapping(address => Voter) public voters;
    uint public candidateCount;

    event CandidateAdded(uint id, string name);
    event Voted(address Voter, uint candidateId);
    event VotingStarted();
    event VotingEnded();

    modifier OwnerOnly() {
        require(msg.sender == owner, "Not the owner");
        _;
    }
    
    modifier whenVotingOpen() {
        require(VotingOpen, "Voting is not open");
        _;
    }
    constructor () {
        owner = msg.sender;
    }
    function addCandidate(string memory _name) public OwnerOnly {
        candidateCount++;
        candidates[candidateCount] = Candidate(candidateCount,_name, 0);
        emit CandidateAdded(candidateCount, _name);
    }
    function StartVoting() public OwnerOnly {
        require(!VotingOpen, "Voting is already open");
        VotingOpen = true;
        emit VotingStarted();

    }
    function EndVoting() public OwnerOnly{
        require(VotingOpen, "Voting is already closed");
        VotingOpen = false;
        emit VotingEnded();
    }
    function vote(uint _candidateId) public whenVotingOpen{
        require(!voters[msg.sender].voted, "Already voted");
        require(_candidateId > 0 && _candidateId <= candidateCount, "No valid candidate");

        voters[msg.sender] = Voter(true, _candidateId);
        candidates[_candidateId].voteCount++;

        emit Voted(msg.sender,_candidateId);
    }

    function GetWinner() public view returns(string memory winnerName, uint winnerVotes) {
        require(!VotingOpen, "Voting still open");
        uint WinnerVotes = 0;
        uint WinnerId = 0;

        for (uint i = 0; i <= candidateCount; i++) {
            if (candidates[i].voteCount > WinnerVotes) {
                WinnerVotes = candidates[i].voteCount;
                WinnerId = i;
                
            }
        }
        return (candidates[WinnerId].name, WinnerVotes);
    }  

}
