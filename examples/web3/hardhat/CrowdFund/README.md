This is the wallet example from https://solidity-by-example.org/app/crowd-fund
Steps:

Run these commands
```
npm init --yes
npm install --save-dev hardhat
npx hardhat
```

Use menu to create empty `hardhat.config.js`. Then edit `hardhat.config.js` and add this line to the
top of the file:
```
require("@nomiclabs/hardhat-waffle");
```

And change the solidity compiler version number.
```
module.exports = {
  solidity: "0.8.13",
};
```

Then run this command:
```
npm install --save-dev @nomiclabs/hardhat-ethers ethers @nomiclabs/hardhat-waffle ethereum-waffle chai
npm install --save-dev @openzeppelin/contracts
```

Run the tests:
```
npx hardhat test
