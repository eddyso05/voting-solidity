pragma solidity >= 0.7.0 < 0.9.0;

contract Ballot {
    // all the code goes here

    // struct is a method to create your own data type

    // voters : voted = bool,access to vote = uint, vote index = unit

    struct Voter {
        uint vote;
        bool voted;
        uint weight;
        
    }

    struct Proposal {
        bytes32 name; // the name of each proposal
        uint voteCount; //number of accummulated votes
    }

    Proposal[] public proposals;

    // mapping allows for us to create a store value with keys and indexes
    mapping(address => Voter) public voters; //votes get address as a key and Voter for value

    address public chairperson;

    constructor(bytes32[] memory proposalNames) {
        // memory defines a temporary data location in solidity during runtime only
        // we guarantee space for it 

        // msg.sender = is a global variable that states the person 
        // who is currently connecting to the contract
        chairperson = msg.sender;

        // add 1 to chairperson weight
        voters[chairperson].weight = 1;

        // will add the proposal names to the smart contract upon deployment
        for(uint i=0; i < proposalNames.length; i++) {
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }

    // function authenticate votes
    function giveRightToVote(address voter) public {
        require(msg.sender == chairperson,'only the chairperson can give access to vote');
        // require that the voter hasn't voted yet
        require(!voters[voter].voted,'The voter has already voted');
        require(voters[voter].weight == 0);

        voters[voter].weight = 1;
    }

    // function for voting
    function vote(uint proposal) public {
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0,'Has no right to vote');
        require(!sender.voted,'Already Voted');
        sender.voted = true;
        sender.vote = proposal;

        proposals[proposal].voteCount += sender.weight;

    }

    // functions for showing the results
     
    // 1. functions that shows the winning proposal by integer
    function winningProposal() public view returns (uint winningProposal_) {
        uint winningVoteCount = 0;
        for(uint i =0;i < proposals.length;i++) {
            if(proposals[i].voteCount > winningVoteCount) {
                winningVoteCount = proposals[i].voteCount;
                winningProposal_ = i;
            }
        }
    }

    // 2. function that shows the winner by name
    function winningName() public view returns (bytes32 winningName_) {
        winningName_ = proposals[winningProposal()].name;
    }
}