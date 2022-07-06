const { expect } = require("chai"); 

describe("Create Wallet", function () {
  it("owner can create", async function () {
    // Create a wallet
    const [owner, other] = await ethers.getSigners();
    const Wallet = await ethers.getContractFactory("EtherWallet");
    const hardhatWallet = await Wallet.deploy();

    // Add an ether and make sure it appears in the wallet.
    const expectedBalance = ethers.utils.parseEther("1.0");
    const transactionHash = await owner.sendTransaction({
        to: hardhatWallet.address,
        value: expectedBalance,
    });
    expect(await hardhatWallet.getBalance()).to.be.equal(expectedBalance);


    // make sure others can't withdraw from wallet
    //expect(await hardhatWallet.connect(other).withdraw(1)).to.be.reverted;
  });
});
