const { expect } = require("chai");

const maxHigh = 5; 
const minHigh = 5;
const flightCost = 2; 
const listPesticides = [1, 2, 3];

describe('DroneNFT contract tests', () => {
    const setup = async ({ maxSupply = 10000 }) => {
        const [ owner ] = await ethers.getSigners();
        const DroneNFT = await ethers.getContractFactory("DroneNFT");
        const deployed = await DroneNFT.deploy(maxSupply);
        return {
            owner, 
            deployed,
        };
    };

    describe('Deployment', () => {
        it('Should have totalSupply passed in during deployment', async () => {
            const maxSupply = 4000;
            const { deployed } = await setup({ maxSupply });
            const returnedMaxSupply = await deployed.maxSupply();
            expect(maxSupply).to.equal(returnedMaxSupply);
        });
    });

    describe("Minting", () => {
        it('Should mint a new token and assings it to owner', async () => {
            const { owner, deployed } = await setup({  });
            await deployed.mint(maxHigh, minHigh, flightCost, listPesticides);
            const ownerOfMinted = await deployed.ownerOf(0);
            expect(ownerOfMinted).to.equal(owner.address);
        });

        it('Should have a minting limit', async () => {
            const maxSupply = 2;
            const { deployed } = await setup({ maxSupply });
            await Promise.all([deployed.mint(maxHigh, minHigh, flightCost, listPesticides), 
                               deployed.mint(maxHigh, minHigh, flightCost, listPesticides)]);
            await expect(deployed.mint(maxHigh, minHigh, flightCost, listPesticides))
            .to.be.revertedWith("No drones left"); 
        });
    });
});