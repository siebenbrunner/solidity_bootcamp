// SPDX-License-Identifier:UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol"; // specify template version
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract VolcanoCoinV2 is Initializable, ERC20Upgradeable, OwnableUpgradeable, UUPSUpgradeable {

uint public constant version = 2;
uint internal paymentId;
address internal administrator;

enum PaymentType {Unknown, BasicPayment, Refund, Dividend, GroupPayment}

struct Payment {
    address recipient;
    address spender; // track spender separately, because approved addresses may spend on behalf of others
    uint amount;
    uint identifier;
    uint timestamp;
    PaymentType paymentType;
    string comment;

}

mapping(address => Payment[]) public payments;

event PaymentRecordFound(address recipient, 
                         address spender, 
                         uint amount,
                         uint identifier,
                         uint timestamp,
                         PaymentType paymentType,
                         string comment);

function initialize(string memory name_, string memory symbol_, address _administrator) public initializer {
    __ERC20_init(name_,symbol_);
    __Ownable_init();
    _mint(msg.sender,10000);
    administrator = _administrator;
}

function _authorizeUpgrade(address) internal override onlyOwner {}

function mintToOwner(uint _amount) public onlyOwner {
    _mint(msg.sender,_amount);
}

function transfer(
    address _recipient, 
    uint256 _amount) 
    public override returns (bool) { // override parent transfer function
        _recordPayment(_msgSender(), _msgSender(), _recipient, _amount); // use our custom _recordPayment function
        return ERC20Upgradeable.transfer(_recipient,_amount); // call parent transfer function
    }

function transferFrom(
    address _sender,
    address _recipient,
    uint256 _amount
    ) public override returns (bool) { // also override parent transferFrom function
        _recordPayment(_sender, _msgSender(), _recipient, _amount);
        return ERC20Upgradeable.transferFrom(_sender,_recipient,_amount);
    }

function getPayments(address _sender) public returns(bool) {
    for (uint i=0; i<payments[_sender].length; i++) {
            emit PaymentRecordFound(
                payments[_sender][i].recipient,
                payments[_sender][i].spender,
                payments[_sender][i].amount,
                payments[_sender][i].identifier,
                payments[_sender][i].timestamp,
                payments[_sender][i].paymentType,
                payments[_sender][i].comment);
        } 
    return (true);
}

function updatePayment(address _sender, uint _number, uint8 _type, string calldata _comment) public {
    require(_sender == msg.sender, "No update rights!");
    require(_type < 5, "Invalid payment type!");
    require(_number < payments[_sender].length, "Not found!");

    payments[_sender][_number].comment = _comment;
    payments[_sender][_number].paymentType = PaymentType(_type);
}

function updatePaymentType(address _sender, uint _number, uint8 _type) public {
    require(msg.sender == administrator);
    require(_type < 5, "Invalid payment type!");
    require(_number < payments[_sender].length, "Not found!");

    payments[_sender][_number].paymentType = PaymentType(_type);
    string memory admin_address = bytes32ToString(bytes32(abi.encodePacked(msg.sender)));
    payments[_sender][_number].comment = string(abi.encodePacked(payments[_sender][_number].comment, " updated by ", admin_address));
}

function _recordPayment(address _sender, address _spender, address _recipient, uint _amount) internal {
    payments[_sender].push(Payment({
        recipient: _recipient,
        spender: _spender,
        amount: _amount, 
        identifier: paymentId, 
        timestamp: block.timestamp,
        paymentType: PaymentType.Unknown,
        comment: ""
    }));
    paymentId++;
}

function bytes32ToString(bytes32 _bytes32) public pure returns (string memory) {
    uint8 i = 0;
    bytes memory bytesArray = new bytes(40);
    for (i = 0; i < bytesArray.length; i++) {
        uint8 _f = uint8(_bytes32[i/2] >> 4);
        uint8 _l = uint8(_bytes32[i/2] & 0x0f);

        bytesArray[i] = toByte(_f);
        i = i + 1;
        bytesArray[i] = toByte(_l);
    }
    return string(abi.encodePacked("0x", bytesArray));
}

  function toByte(uint8 _uint8) public pure returns (bytes1) {
    if(_uint8 < 10) {
        return bytes1(_uint8 + 48);
    } else {
        return bytes1(_uint8 + 87);
    }
}


}

