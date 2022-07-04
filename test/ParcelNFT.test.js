const { expect } = require("chai");

const to = '0x9EBF6734eBf95efFB99DBE6dC5fAF086EC394d94'; 
const maxHigh = 5; 
const minHigh = 5;
const pesticide = 2;

describe('ParcelNFT contract tests', () => {
    const setup = async ({ maxSupply = 10000 }) => {
        const [ owner ] = await ethers.getSigners();
        const ParcelNFT = await ethers.getContractFactory("ParcelNFT");
        const deployed = await ParcelNFT.deploy(maxSupply);
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
        it('Should mint a new token and assings it to receiver', async () => {
            const { deployed } = await setup({  });
            await deployed.mint(to, maxHigh, minHigh, pesticide);
            const ownerOfMinted = await deployed.ownerOf(0);
            expect(ownerOfMinted).to.equal(to);
        });

        it('Should have a minting limit', async () => {
            const maxSupply = 2;
            const { deployed } = await setup({ maxSupply });
            await Promise.all([deployed.mint(to, maxHigh, minHigh, pesticide), 
                               deployed.mint(to, maxHigh, minHigh, pesticide)]);
            await expect(deployed.mint(to, maxHigh, minHigh, pesticide))
            .to.be.revertedWith("No parcels left"); 
        });
    });
});