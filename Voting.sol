// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Election{

    address public ElectionCommision;
    struct Party{
        string name;
        uint totalVote;
    }

    struct Voter{
        bool isRegistered;
        bool hasVoted;
        uint age;
    }

    Party[] public politicalParties;
    mapping (address=>Voter) public voters;
    modifier onlyElectionCommision {
        require(ElectionCommision==msg.sender,"You are not from Election Commision");
        _;
    }

    constructor(){
        ElectionCommision=msg.sender;
    }


    function registerPoliticalParty(string memory _name) public onlyElectionCommision{
        for(uint i=0;i<politicalParties.length;i++){
            string memory teamName=politicalParties[i].name;
            require(keccak256(abi.encodePacked(teamName))!=keccak256(abi.encodePacked((_name))));
        }

        Party memory _newParty=Party({
           name: _name,
           totalVote:0
        });
        politicalParties.push(_newParty);
    }

    function registerVoter(address _voter,uint _age) public onlyElectionCommision{
        require(voters[_voter].isRegistered==false,"Voter already registered");
        require(_age>=18,"Voter is not eligible");

        voters[_voter].isRegistered=true;
        voters[_voter].age=_age;
    }

    function voting(uint _index) public {
        require(voters[msg.sender].isRegistered==true,"Voter is not registered");
        require(voters[msg.sender].hasVoted==false,"Voter has already voted");

        politicalParties[_index].totalVote+=1;
        voters[msg.sender].hasVoted=true;
    }
    function watchResult() public view returns (string memory) {
        uint winnerTotalVote=0;
        uint winnerIndex=0;

        for(uint i=0;i<politicalParties.length;i++){
            if(politicalParties[i].totalVote>winnerTotalVote){
                winnerTotalVote=politicalParties[i].totalVote;
                winnerIndex=i;
            }
        }
        Party storage winner=politicalParties[winnerIndex];
        return winner.name;
    }

}
