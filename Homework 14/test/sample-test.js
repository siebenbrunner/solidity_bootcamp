const { expect, use } = require("chai");
const { ethers } = require("hardhat");

const { solidity } = require("ethereum-waffle");
use(solidity);

const DAIAddress = "0x6b175474e89094c44da98b954eedeac495271d0f";
const cDAIAddress = "0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643";

describe("DeFi", () => {
  let owner;
  let DAI_TokenContract;
  let cDAI_TokenContract;
  let DeFi;
  const AMOUNT = 999999999000000;
  before(async function () {
    [owner, addr1, addr2, addr3, addr4, addr5] = await ethers.getSigners();
    const whale = await ethers.getSigner(
      "0x503828976D22510aad0201ac7EC88293211D23Da"
    );
    console.log("owner account is ", owner.address);

    DAI_TokenContract = await ethers.getContractAt("ERC20", DAIAddress);
    cDAI_TokenContract = await ethers.getContractAt("ERC20", cDAIAddress);

    const symbol = await DAI_TokenContract.symbol();
    console.log(symbol);
    const DeFiFactory = await ethers.getContractFactory("DeFi");
    await DAI_TokenContract.connect(whale).transfer(
      owner.address,
      BigInt(AMOUNT)
    );

    DeFi = await DeFiFactory.deploy();

  });

  it("should turn DAI into cDAI", async () => {
    tx1 = await DAI_TokenContract.connect(owner).transfer(
      DeFi.address,
      AMOUNT
    );
    await tx1.wait();

    tx2 = await DeFi.connect(owner).addToCompound(AMOUNT);
    await tx2.wait();
    expect(await cDAI_TokenContract.balanceOf(DeFi.address)).to.be.at.least(1);
    expect(await DAI_TokenContract.balanceOf(DeFi.address)).to.equal(0);
  });

  it("should get ETH USD price", async () => {
    price = await DeFi.getETHUSDprice();
    console.log("ETH price: ", price/10**8);
    expect(price).to.be.at.least(1);
  });
});
