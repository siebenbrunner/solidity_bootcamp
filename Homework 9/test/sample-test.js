const { expect, use } = require("chai");
const { ethers } = require("hardhat");
const {
  constants, // Common constants, like the zero address and largest integers
  expectRevert, // Assertions for transactions that should fail
} = require("@openzeppelin/test-helpers");

const { solidity } = require("ethereum-waffle");
use(solidity);

// https://www.chaijs.com/guide/styles/
// https://ethereum-waffle.readthedocs.io/en/latest/matchers.html

describe("Volcano Coin", () => {
  let volcanoContract;
  let owner, addr1, addr2, addr3;

  beforeEach(async () => {
    const Volcano = await ethers.getContractFactory("VolcanoCoin");
    volcanoContract = await Volcano.deploy();
    await volcanoContract.deployed();

    [owner, addr1, addr2, addr3] = await ethers.getSigners();
  });

  it("has a name", async () => {
    let contractName = await volcanoContract.name();
    expect(contractName).to.equal("Volcano Coin");
  });

  it("reverts when transferring tokens to the zero address", async () => {
    await expectRevert(
      volcanoContract.transfer(constants.ZERO_ADDRESS, 10),
      "ERC20: transfer to the zero address"
    );
  });

  //homework
  it("has a symbol", async () => {
    let contractSymbol = await volcanoContract.symbol();
    expect(contractSymbol).to.equal("VLC");
  });

  it("has 18 decimals", async () => {
    let decimals = await volcanoContract.decimals();
    expect(decimals).to.equal(18);
  });

  it("assigns initial balance", async () => {
    let balance = await volcanoContract.balanceOf(owner.address);
    expect(balance).to.equal(100000);
  });

  it("increases allowance for address1", async () => {
    let tx = await volcanoContract.increaseAllowance(addr1.address, 10);
    await tx.wait();
    let allowance1 = await volcanoContract.allowance(owner.address, addr1.address);
    expect(allowance1).to.equal(10);
  });

  it("decreases allowance for address1", async () => {
    let tx1 = await volcanoContract.increaseAllowance(addr1.address, 10);
    await tx1.wait();
    let tx2 = await volcanoContract.decreaseAllowance(addr1.address, 1);
    await tx2.wait();
    let allowance1 = await volcanoContract.allowance(owner.address, addr1.address);
    expect(allowance1).to.equal(9);
  });

  it("emits an event when increasing allowance", async () => {
    let tx = await volcanoContract.increaseAllowance(addr1.address, 10);
    await expect(tx).to.emit(volcanoContract, "Approval");
  });

  it("revets decreaseAllowance when trying decrease below 0", async () => {
    await expect(volcanoContract.decreaseAllowance(addr1.address, 1)).to.be.reverted;
  });

  it("updates balances on successful transfer from owner to addr1", async () => {
    let tx = await volcanoContract.connect(owner).transfer(addr1.address, 10);
    await tx.wait();
    expect(await volcanoContract.balanceOf(owner.address)).to.equal(100000-10);
    expect(await volcanoContract.balanceOf(addr1.address)).to.equal(10);
  });

  it("revets transfer when sender does not have enough balance", async () => {
    await expect(
      volcanoContract.connect(addr1).transfer(addr2.address, 10)
      ).to.be.reverted;
  });

  it("reverts transferFrom addr1 to addr2 called by the owner without setting allowance", async () => {
    let tx = await volcanoContract.connect(owner).transfer(addr1.address, 10);
    await tx.wait();
    await expect(
      volcanoContract.connect(owner).transferFrom(addr1.address, addr2.address, 10)
      ).to.be.reverted;
  });
  it("updates balances after transferFrom addr1 to addr2 called by the owner", async () => {
    let tx1 = await volcanoContract.transfer(addr1.address, 10);
    await tx1.wait();
    let tx2 = await volcanoContract.connect(addr1).increaseAllowance(owner.address, 10);
    await tx2.wait();
    let tx3 = await volcanoContract.transferFrom(addr1.address, addr2.address, 10);
    await tx3.wait();
    expect(await volcanoContract.balanceOf(owner.address)).to.equal(100000-10);
    expect(await volcanoContract.balanceOf(addr1.address)).to.equal(0);
    expect(await volcanoContract.balanceOf(addr2.address)).to.equal(10);
  });
});
