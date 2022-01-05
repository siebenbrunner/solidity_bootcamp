// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract DeFi {
    Erc20 public DAI;
    CErc20 public cDAI;
    address internal constant ETHPriceContract = 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419;
    AggregatorV3Interface internal priceFeed;

    constructor() {
        DAI = Erc20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
        cDAI = CErc20(0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643);
        priceFeed = AggregatorV3Interface(ETHPriceContract);
    }

    function addToCompound(uint256 amountToAdd) public {
        DAI.approve(address(cDAI), amountToAdd);
        cDAI.mint(amountToAdd);
    }

    function getETHUSDprice() public view returns(int256) {
        (,int256 price, , , ) = priceFeed.latestRoundData();
        return price;
    }
}


interface Erc20 {
function approve(address, uint256) external returns (bool);
function transfer(address, uint256) external returns (bool);
}

interface CErc20 {
function mint(uint256) external returns (uint256);
function exchangeRateCurrent() external returns (uint256);
function supplyRatePerBlock() external returns (uint256);
function redeem(uint) external returns (uint);
function redeemUnderlying(uint) external returns (uint);
}