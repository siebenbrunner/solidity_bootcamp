// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

contract Score {

uint score;
address owner;
mapping(address => uint) public score_list;

event NewScore(uint _newScore);
event NewUserScore(address _user, uint _newScore);

constructor() {
    owner = msg.sender;
}

modifier onlyOwner {
    if(msg.sender == owner) {
        _; // execute the remainder of the function
    }
}

function getScore() public view returns (uint) {
    return score;
}

function setScore(uint _newScore) public onlyOwner {
    score = _newScore;
    emit NewScore(score);
}

function setUserScore(address _user, uint _newScore) public onlyOwner {
    score_list[_user] = _newScore;
    emit NewUserScore(_user, _newScore);
}


/**
 * public -> wallets, other contrcts, internal function and contracts that intherit from  this cnntracct
 *
 * internal -> visible to internal function, inherited
 * 
 * external -> outside contract, not internal
 * 
 * private -> internally, cannot be inherited
 * 
 * 
 * view -> reads storage
 * 
 * pure -> neither reads no modifies state -> eg calculation
 * 
 */
 
}