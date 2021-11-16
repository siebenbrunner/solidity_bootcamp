// SPDX-License-Identifier:UNLICENSED

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.4/contracts/token/ERC20/ERC20.sol"; // specify template version
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.4/contracts/access/Ownable.sol";

contract VolcanoCoin is ERC20, Ownable {

struct Payment {
    address recipient;
    address spender; // track spender separately, because approved addresses may spend on behalf of others
    uint amount;
}

mapping(address => Payment[]) public payments;

event PaymentRecordFound(address recipient, address spender, uint amount);

constructor(string memory name_, string memory symbol_) ERC20(name_,symbol_) { // call parent constructor
    _mint(msg.sender,10000);
    }

function mintToOwner(uint _amount) public onlyOwner {
    _mint(msg.sender,_amount);
}

function transfer(
    address _recipient, 
    uint256 _amount) 
    public override returns (bool) { // override parent transfer function
        _recordPayment(_msgSender(), _msgSender(), _recipient, _amount); // use our custom _recordPayment function
        return ERC20.transfer(_recipient,_amount); // call parent transfer function
    }

function transferFrom(
    address _sender,
    address _recipient,
    uint256 _amount
    ) public override returns (bool) { // also override parent transferFrom function
        _recordPayment(_sender, _msgSender(), _recipient, _amount);
        return ERC20.transferFrom(_sender,_recipient,_amount);
    }

function getPayments(address _sender) public returns(bool) {
    for (uint i=0; i<payments[_sender].length; i++) {
            emit PaymentRecordFound(
                payments[_sender][i].recipient,
                payments[_sender][i].spender,
                payments[_sender][i].amount);
        } 
    return (true);
}

function _recordPayment(address _sender, address _spender, address _recipient, uint _amount) internal {
    payments[_sender].push(Payment({
        recipient: _recipient,
        spender: _spender,
        amount: _amount
    }));
}

}

