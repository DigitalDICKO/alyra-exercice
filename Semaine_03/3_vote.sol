//Write your own contracts here. Currently compiles using solc v0.4.15+commit.bbb8e64f.
pragma solidity ^0.4.18;
contract Assemblee {
  string[] descriVotes;
  uint[] votesPour;
  uint[] votesContre;
  string nomAssemblee;

  constructor(string memory nom) public {
    nomAssemblee = nom;
  }

  address[] participants;
  function rejoindre() public {
    participants.push(msg.sender);
  }

  function estParticipant(address par) public constant returns (bool) {
    for (uint i=0; i<participants.length; i++) {
      if (participants[i]==par) {
        return true;
      }
    }
    return false;
  }

  function proposerUnVote(string memory description) public {
    descriVotes.push(description);
    votesPour.push(0);
    votesContre.push(0);
  }

  function voter(uint numVote, uint vote) public {    // Dans Ethfiddle on utilise uint vote au lieu de bool car mauvaise interpretation du compilateur. Dans remix eth c'est ok
    if (estParticipant(msg.sender)) {
      if (vote==1) {    // Dans Ethfiddle on utilise uint vote au lieu de bool car mauvaise interpretation du compilateur. Dans remix eth c'est ok
        votesPour[numVote]+=1;
      } else {
        votesContre[numVote]+=1;
      }
    }
  }

  function resultatVotesPour(uint numVote) public constant returns (uint) {
    return votesPour[numVote];
  }

  function resultatVotesContre(uint numVote) public constant returns (uint) {
    return votesContre[numVote];
  }

  function ecartDeVote(uint numVote) public constant returns (int) {
    return int(votesPour[numVote])-int(votesContre[numVote]);
  }

}