const deploy = async () => {
  const [ deployer ] = await ethers.getSigners();
  console.log("Deploying contract with the account: ", deployer.address);

  const Core = await ethers.getContractFactory("Core");
  const deployedCore = await Core.deploy();
  console.log(`Core is deployed at: https://rinkeby.etherscan.io/address/${deployedCore.address}`);

  const FDToken = await ethers.getContractFactory("FDToken");
  const deployedToken = await FDToken.deploy();
  console.log(`FDToken is deployed at: https://rinkeby.etherscan.io/address/${deployedToken.address}`);

}

deploy()
    .then(() => process.exit(0))
    .catch((error) => {
        console.log(error);
        process.exit(1);
    });