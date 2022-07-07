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
const web3 = require("web3");

const nameYes = web3.utils.padRight(web3.utils.asciiToHex("yes"), 64);
const nameNo = web3.utils.padRight(web3.utils.asciiToHex("no"), 64);

describe("Create Ballot", function () {
  it("Chairman should be able to create a ballot", async function () {
    const [chairman, v1] = await ethers.getSigners();

    const Ballot = await ethers.getContractFactory("Ballot");

    const hardhatBallot = await Ballot.deploy([nameYes, nameNo]);
  });
});

describe("Perform Vote", function () {
  it("Perform a vote", async function () {
    const [chairman, v1, v2, v3] = await ethers.getSigners();

    const Ballot = await ethers.getContractFactory("Ballot");

    const hardhatBallot = await Ballot.deploy([nameYes, nameNo]);
    await hardhatBallot.giveRightToVote(v1.address);
    await hardhatBallot.giveRightToVote(v2.address);
    await hardhatBallot.giveRightToVote(v3.address);

    await hardhatBallot.connect(v1).vote(1);
    await hardhatBallot.connect(v2).vote(0);
    await hardhatBallot.connect(v3).vote(1);
    expect(await hardhatBallot.winningProposal()).to.equal(1);
    expect(await hardhatBallot.winnerName()).to.equal(nameNo);
  });
});

describe("Delegate Vote", function () {
  it("Delegate a vote", async function () {
    const [chairman, v1, v2, v3] = await ethers.getSigners();

    const Ballot = await ethers.getContractFactory("Ballot");

    const hardhatBallot = await Ballot.deploy([nameYes, nameNo]);
    await hardhatBallot.giveRightToVote(v1.address);
    await hardhatBallot.giveRightToVote(v2.address);
    await hardhatBallot.giveRightToVote(v3.address);

    await hardhatBallot.connect(v1).delegate(v3.address);
    await hardhatBallot.connect(v2).vote(0);
    await hardhatBallot.connect(v3).vote(1);
    expect(await hardhatBallot.winningProposal()).to.equal(1);
    expect(await hardhatBallot.winnerName()).to.equal(nameNo);
  });
});

describe("Improper Delegate Vote", function () {
  it("Try to cheat a vote", async function () {
    const [chairman, v1, v2, v3] = await ethers.getSigners();

    const Ballot = await ethers.getContractFactory("Ballot");

    const hardhatBallot = await Ballot.deploy([nameYes, nameNo]);
    await hardhatBallot.giveRightToVote(v1.address);
    await hardhatBallot.giveRightToVote(v2.address);
    await hardhatBallot.giveRightToVote(v3.address);

    await hardhatBallot.connect(v1).delegate(v3.address);
    await expect(hardhatBallot.connect(v1).vote(1)).to.be.revertedWith("Already voted.");
    await expect(hardhatBallot.connect(v1).delegate(v2.address)).to.be.revertedWith("You already voted.");
  });
});

describe("No Vote", function () {
  it("Delegate a vote", async function () {
    const [chairman, v1, v2, v3] = await ethers.getSigners();

    const Ballot = await ethers.getContractFactory("Ballot");

    // This is actually a problem. There have been no votes, yet a winner is
    // chosen.
    const hardhatBallot = await Ballot.deploy([nameYes, nameNo]);
    winner = await hardhatBallot.winningProposal();
    console.log(winner);
  });
});
