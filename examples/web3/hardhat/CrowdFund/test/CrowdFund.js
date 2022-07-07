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

describe("CrowdSource Test", function () {
  it("Basic Test", async function () {
    const [owner, v1, v2, v3, v4] = await ethers.getSigners();

    // create a ERC20 token. Mint 1 million bogus tokens to play with.
    const totalBogusTokens = 1000000;
    const BogusToken = await ethers.getContractFactory("BogusToken");
    const hardhatBogusTokens = await BogusToken.deploy(totalBogusTokens);

    // Give out tokens
    await hardhatBogusTokens.transfer(v1.address, 250000);
    await hardhatBogusTokens.transfer(v2.address, 250000);
    await hardhatBogusTokens.transfer(v3.address, 250000);
    await hardhatBogusTokens.transfer(v4.address, 250000);

    // Create a CrowdFund contract. CrowdFund contracts allow allow multiple offerings to be
    // launched. Each offering has a goal, a start time, and an end time. (Note. contract time
    // is UNIX time, seconds since epoch, 00:00:00 GMT, 1 Jan 1970).
    const CrowdFund = await ethers.getContractFactory("CrowdFund");
    const hardhatCrowdFund = await CrowdFund.deploy(hardhatBogusTokens.address);

    // Start first offering. 10000 Tokens. Start in an hour. Run for 72 hours.
    const startInSecs = Math.floor(new Date().getTime() / 1000) + 3600;
    const endInSecs = startInSecs + 259200;
    expect(await(hardhatCrowdFund.launch(10000, startInSecs, endInSecs)))
                       .to.emit(hardhatCrowdFund, "Launch");

    // Move time up by an hour so funding can begin.
    await network.provider.send("evm_increaseTime", [3600])
    await network.provider.send("evm_mine")

    // pledge tokens (oversubscribe).
    await hardhatBogusTokens.connect(v1).approve(hardhatCrowdFund.address, 5000);
    await hardhatCrowdFund.connect(v1).pledge(1, 5000);
    await hardhatBogusTokens.connect(v2).approve(hardhatCrowdFund.address, 5000);
    await hardhatCrowdFund.connect(v2).pledge(1, 5000);
    await hardhatBogusTokens.connect(v3).approve(hardhatCrowdFund.address, 5000);
    await hardhatCrowdFund.connect(v3).pledge(1, 5000);

    // Increase time to past end of CrowdFund
    await network.provider.send("evm_increaseTime", [259200])
    await network.provider.send("evm_mine")

    expect(await hardhatBogusTokens.balanceOf(owner.address)).to.equal(0);
    expect(await hardhatCrowdFund.claim(1)).to.emit(hardhatCrowdFund, "Claim").withArgs(1);
    expect(await hardhatBogusTokens.balanceOf(owner.address)).to.equal(15000);
  });
});
