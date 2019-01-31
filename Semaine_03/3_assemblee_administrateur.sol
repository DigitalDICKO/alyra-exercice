//Write your own contracts here. Currently compiles using solc v0.4.15+commit.bbb8e64f.
pragma solidity ^0.4.18;
contract Assemblee {
  /*
  string[] descriVotes;
  uint[] votesPour;
  uint[] votesContre; */
  string nomAssemblee;
  address[] participants;
  //address[] administrateurs;

  struct Administrateur {
    address adminAddress;
    uint nombreDeBlames;
    uint dateLimiteNomination;
    bool enFonction;     //Un administrateur peut démissionner ou etre expulser. Ce booleen signal si l'administrateur est actif ou pas.
  }
  Administrateur[] administrateurs;

  constructor(string memory nom) public {
    nomAssemblee = nom;
    Administrateur memory admin;
    admin.adminAddress = msg.sender;
    admin.dateLimiteNomination = now + 604800; //Toutes les nominations (dont la nomination au déploiement) sont désormais provisoires et limitées à une semaine.
    admin.enFonction=true;
    administrateurs.push(admin);     // On place le code ds le constructeur car Celui qui déploie le smart contract est le premier administrateur.
  }

  function nommerAdministrateur(address nouvelAdmin) public {
      if (administrateurs[0].adminAddress == msg.sender) {
        Administrateur memory adm;
        adm.adminAddress = nouvelAdmin;
        adm.dateLimiteNomination = now + 604800; //Toutes les nominations (dont la nomination au déploiement) sont désormais provisoires et limitées à une semaine.
        adm.enFonction=true;
        administrateurs.push(adm);     // On place le code ds le constructeur car Celui qui déploie le smart contract est le premier administrateur.
      }
  }


  function estAdministrateur(address adm) public constant returns (bool) {
    for (uint i=0; i<administrateurs.length; i++) {
      if (administrateurs[i].adminAddress==adm) {
        return true;
      }
    }
    return false;
  }

  function finFonctionDAdministrateur(uint numAdmin) public {   //en cas de demission ou d'exclusion enFonction passe à false
      require(estAdministrateur(msg.sender), "Vous devez etre Administrateur !");
      administrateurs[numAdmin].enFonction = false;
  }

  function blamerAdmin(uint numAdmin) public {   //   (optionnel) Un administrateur peut donner un blâme à un membre. Au deuxième blâme, celui-ci est expulsé.
      require(estAdministrateur(msg.sender), "Vous devez etre Administrateur !");
      if (administrateurs[numAdmin].enFonction = true) {
          if (administrateurs[numAdmin].nombreDeBlames<2) {
            administrateurs[numAdmin].nombreDeBlames++;
          } else {
            finFonctionDAdministrateur(numAdmin);
          }
      }
  }

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

 /*V1
  function proposerUnVote(string memory description) public {
    descriVotes.push(description);
    votesPour.push(0);
    votesContre.push(0);
  }
  */

  struct Vote {
    string descriVote;
    uint votesPour;
    uint votesContre;
    address[] votersAddress;
    uint dateLimite;
  }

  Vote[] votes;

  function proposerUnVote(string memory description, uint date) public {
    require(estParticipant(msg.sender), "Vous devez etre participant!");
    Vote memory vote;
    vote.descriVote = description;
    vote.votesPour = 0;
    vote.votesContre = 0;
    vote.dateLimite = date;
    votes.push(vote);
   // descriVotes.push(description);
   // votesPour.push(0);
   // votesContre.push(0);
  }

  function supprimerUnVote(uint numVote) public {   // Une proposition de décision peut être fermée par un administrateur
    require(estAdministrateur(msg.sender), "Vous devez etre Administrateur !");
    votes[numVote].descriVote = "";
  }

  function statusVote(uint numVote)  public constant returns (bool) {
    bool status = false;
    for (uint i=0; i<votes[numVote].votersAddress.length; i++) {
      if (votes[numVote].votersAddress[i]==msg.sender) {
        status = true;
      } 
    }
    return status;
  }

  function voter(uint numVote, uint vote) public {    // Dans Ethfiddle on utilise uint vote au lieu de bool car mauvaise interpretation du compilateur. Dans remix eth c'est ok
    if (estParticipant(msg.sender)) {
      if (statusVote(vote)==false) {
        if (votes[numVote].dateLimite<now+604800)  {  // verification délai vote < 7 jours  soit 604800 secondes.
          if (vote==1) {    // Dans Ethfiddle on utilise uint vote au lieu de bool car mauvaise interpretation du compilateur. Dans remix eth c'est ok
            votes[numVote].votesPour+=1;
          } else {
            votes[numVote].votesContre+=1;
          }
          votes[numVote].votersAddress.push(msg.sender);
        }
      }  
    }
  }

  function resultatVotesPour(uint numVote) public constant returns (uint) {
    return votes[numVote].votesPour;
  }

  function resultatVotesContre(uint numVote) public constant returns (uint) {
    return votes[numVote].votesContre;
  }

  function ecartDeVote(uint numVote) public constant returns (int) {
    return int(votes[numVote].votesPour)-int(votes[numVote].votesContre);
  }


}