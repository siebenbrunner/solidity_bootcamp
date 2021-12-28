const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("VolcanoCoin", function () {

  it("should have a version number", async function () {
    const Volcano = await ethers.getContractFactory("VolcanoCoin");
    volcanoContract = await upgrades.deployProxy(Volcano, ["VolcanoCoin","VLC","0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"] , {kind: 'uups'});
    await volcanoContract.deployed();
    let version_number = await volcanoContract.version();
    expect(version_number).to.equal(1);
  });

  it("upgrades to v2", async function () {
    const Volcano = await ethers.getContractFactory("VolcanoCoin");
    volcanoContract = await upgrades.deployProxy(Volcano, ["VolcanoCoin","VLC","0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"] , {kind: 'uups'});
    await volcanoContract.deployed();
    const VolcanoV2 = await ethers.getContractFactory("VolcanoCoinV2");
    await upgrades.upgradeProxy(volcanoContract, VolcanoV2);
    let version_number = await volcanoContract.version();
    expect(version_number).to.equal(2);
  });

  it("downgrades back to v1", async function () {
    const Volcano = await ethers.getContractFactory("VolcanoCoin");
    volcanoContract = await upgrades.deployProxy(Volcano, ["VolcanoCoin","VLC","0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"] , {kind: 'uups'});
    await volcanoContract.deployed();
    const VolcanoV2 = await ethers.getContractFactory("VolcanoCoinV2");
    await upgrades.upgradeProxy(volcanoContract, VolcanoV2);
    await upgrades.upgradeProxy(volcanoContract, Volcano);
    let version_number = await volcanoContract.version();
    expect(version_number).to.equal(1);
  });
});
