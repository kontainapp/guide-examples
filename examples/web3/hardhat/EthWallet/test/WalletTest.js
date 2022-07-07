// Copyright 2022 Kontain Inc
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
