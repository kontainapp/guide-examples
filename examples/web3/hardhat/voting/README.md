This is the voting example from https://docs.soliditylang.org/en/latest/solidity-by-example.html

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

Then run this command:
```
npm install --save-dev @nomiclabs/hardhat-ethers ethers @nomiclabs/hardhat-waffle ethereum-waffle chai @nomiclabs/hardhat-web3 web3
```

Run the tests:
```
npx hardhat test
```
