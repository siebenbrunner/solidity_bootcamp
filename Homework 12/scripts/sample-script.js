// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const { version } = require("chai");
const { ethers, upgrades } = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  const Volcano = await ethers.getContractFactory("VolcanoCoin");
  volcanoContract = await upgrades.deployProxy(Volcano, ["VolcanoCoin","VLC","0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"] , {kind: 'uups'});
  await volcanoContract.deployed();
  console.log(volcanoContract.address);
  let version_number = await volcanoContract.version();
  console.log(version_number);
  const VolcanoV2 = await ethers.getContractFactory("VolcanoCoinV2");
  await upgrades.upgradeProxy(volcanoContract, VolcanoV2);
  let version_number2 = await volcanoContract.version();
  console.log(version_number2);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
