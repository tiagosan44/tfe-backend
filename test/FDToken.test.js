const { expect } = require("chai");
const { ethers } = require("hardhat");

const totalSupply = 500000;
const tokenName = "Fumigation drone token";
const tokenSymbol = "FDTK";

describe("FDtoken contract tests", function() {
  before(async function() {
    const availableSigners = await ethers.getSigners();
    this.deployer = availableSigners[0];

    const FDToken = await ethers.getContractFactory("FDToken");
    this.fdtoken = await FDToken.deploy();
    await this.fdtoken.deployed();
  });

  it('Should be named Fumigation drone token', async function() {
    const fetchedTokenName = await this.fdtoken.name();
    expect(fetchedTokenName).to.be.equal(tokenName);
  });

  it('Should have symbol "FDTK"', async function() {
    const fetchedTokenSymbol = await this.fdtoken.symbol();
    expect(fetchedTokenSymbol).to.be.equal(tokenSymbol);
  });

  it('Should have totalSupply passed in during deployment', async function() {
    const [ fetchedTotalSupply, decimals ] = await Promise.all([
      this.fdtoken.totalSupply(),
      this.fdtoken.decimals(),
    ]);
    const expectedTotalSupply = ethers.BigNumber.from(totalSupply).mul(ethers.BigNumber.from(10).pow(decimals));
    expect(fetchedTotalSupply.eq(expectedTotalSupply)).to.be.true;
  });

});