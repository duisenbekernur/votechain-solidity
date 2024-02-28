// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
pragma abicoder v2;

/** 
 * @title Ballot
 * @dev Implements voting process along with vote delegation
 */
contract Ballot {

    struct Voter {
        uint weight; // weight is accumulated by delegation
        bool voted;  // if true, that person already voted
        uint vote;   // index of the voted proposal
    }

    struct Candidate {
        int id;        // candidate ID
        string name;   // candidate name 
        int voteCount; // number of accumulated votes
    }

    struct Action {
        string passportID;
        int candidateID;
    }

    address public chairperson;

    mapping(address => Voter) public voters;

    Candidate[] public candidates;
    Action[] public actions;

    uint256 public totalSupply;

    mapping(address => uint256) public balances;

    enum State {Created, Voting, Ended} // State of voting period

    State public state;

    constructor(Candidate[] memory candidatesList) {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;
        state = State.Created;

        for (uint i = 0; i < candidatesList.length; i++) {
            candidates.push(Candidate({
                id: candidatesList[i].id,
                name: candidatesList[i].name,
                voteCount: 0
            }));
        }
    }

    event Transfer(address indexed from, address indexed to, uint256 value);

    function mint(address account, uint256 amount) public  {
        require(amount > 0, "Amount should be greater than zero");

        // Увеличиваем баланс пользователя на указанное количество монет
        balances[account] += amount;
        totalSupply += amount;

        // Отправляем событие Transfer
        emit Transfer(address(0), account, amount);
    }

    // MODIFIERS
//    modifier onlySmartContractOwner() {
//        require(
//            msg.sender == chairperson,
//            "Only chairperson can start and end the voting"
//        );
//        _;
//    }
//
//    modifier CreatedState() {
//        require(state == State.Created, "it must be in Started");
//        _;
//    }
//
//    modifier VotingState() {
//        require(state == State.Voting, "it must be in Voting Period");
//        _;
//    }
//
//    modifier EndedState() {
//        require(state == State.Ended, "it must be in Ended Period");
//        _;
//    }

    function addCandidates(Candidate[] memory candidatesList)
    public
    {
        state = State.Created;
        for (uint i = 0; i < candidatesList.length; i++) {
            candidates.push(Candidate({
                id: candidatesList[i].id,
                name: candidatesList[i].name,
                voteCount: 0
            }));
        }
    }

    // to start the voting period
    function startVote()
    public
    {
        state = State.Voting;
    }

    /*    
     * to end the voting period
     * can only end if the state in Voting period
    */
    function endVote()
    public
    {
        state = State.Ended;
    }

    /** 
     * @dev Give 'voter' the right to vote on this ballot. May only be called by 'chairperson'.
     * @param voter address of voter
     */
    function giveRightToVote(address voter) public {
        require(
            msg.sender == chairperson,
            "Only chairperson can give right to vote."
        );
        require(
            !voters[voter].voted,
            "The voter already voted."
        );
        require(voters[voter].weight == 0);
        voters[voter].weight = 1;
    }

    /**
     * @dev Give your vote (including votes delegated to you) to candidate 'candidates[candidate].name'.
     * @param candidate index of candidate in the candidates array
     */
    function vote(int candidate, string memory passportID)
    public
    {
//        Voter storage sender = voters[msg.sender];
//        require(sender.weight != 0, "Has no right to vote");
//        require(!sender.voted, "Already voted.");

          actions.push(Action({candidateID: candidate, passportID: passportID}));

        uint index = uint(candidate);

        // Check if the index is within the bounds of the array
        require(index < candidates.length, "Invalid candidate index");

        // Update the vote count for the candidate
        candidates[index].voteCount += 1;

        mint(msg.sender, 1);

    }

    function winningCandidate()
    public
    view
    returns (string memory winnerName_)
    {
        int winningVoteCount = 0;
        for (uint p = 0; p < candidates.length; p++) {
            if (candidates[p].voteCount > winningVoteCount) {
                winningVoteCount = candidates[p].voteCount;
                winnerName_ = candidates[p].name;
            }
        }
    }

    function getCandidatesWithVotes() public view returns (Candidate[] memory, Action[] memory) {
        string[] memory candidateNames = new string[](candidates.length);
        int[] memory voteCounts = new int[](candidates.length);

        for (uint i = 0; i < candidates.length; i++) {
            candidateNames[i] = candidates[i].name;
            voteCounts[i] = candidates[i].voteCount;
        }

        return (candidates, actions);
    }

//    function mint(address account, uint256 amount) public {
//        require(msg.sender == minter, "Only minter can mint tokens");
//        require(amount > 0, "Amount should be greater than zero");
//
//        balances[account] += amount;
//        totalSupply += amount;
//
//        emit Transfer(address(0), account, amount);
//    }
}