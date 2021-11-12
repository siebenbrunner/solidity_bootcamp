// SPDX-License-Identifier:UNLICENSED

pragma solidity ^0.8.0;

contract VolcanoCoin {

uint total_supply = 1000;
address owner;
event totalSupplyIncreased(uint);
mapping(address => uint) public balance; // use mapping to store balances
// use public keyword to automatically create a getter method, otherwise we could write one
event coinTransferred(uint, address);
mapping(address => Payment[]) public payments;

modifier onlyOwner {
    if (msg.sender == owner) {
        _;
    }
}

constructor() {
    owner = msg.sender;
    balance[owner] = total_supply;
}

struct Payment {
    uint amount;
    address recipient;
}

function getTotalSupply() public view returns(uint) {
    return total_supply;
}

function increaseTotalSupply() public onlyOwner {
    total_supply += 1000;
    balance[owner] += 1000;
    emit totalSupplyIncreased(total_supply);
}

function transfer(uint _amount, address _recipient) public {
// we don't need the sender address because we can always get it from msg.sender
// if the sender address was a parameter then we would need to write extra assertions to make sure that wallets only transfer their own coin balances
    require(balance[msg.sender] >= _amount);
    balance[msg.sender] -= _amount; // start by deducting from the sender, to be safe
    balance[_recipient] += _amount;
    emit coinTransferred(_amount, _recipient);
    payments[msg.sender].push(Payment({amount:_amount,recipient:_recipient}));
}

function getPayments(address _sender) public view returns(Payment[] memory) {
    return payments[_sender];
}

}