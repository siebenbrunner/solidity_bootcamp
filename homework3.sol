// SPDX-License-Identifier:UNLICENSED

pragma solidity ^0.8.0;

contract VolcanoCoin {

uint total_supply = 1000;
address owner;

modifier onlyOwner {
    if (msg.sender == owner) {
        _;
    }
}

constructor() {
    owner = msg.sender;
}

event totalSupplyIncreased(uint);

function getTotalSupply() public view returns(uint) {
    return total_supply;
}

function increaseTotalSupply() public onlyOwner {
    total_supply += 1000;
    emit totalSupplyIncreased(total_supply);
}


}