'use strict';

const express = require('express');
const solanaWeb3 = require('@solana/web3.js');

// App
const app = express();

// globals
let keypair;
let connection;

// Constants
const PORT = 8080;
const HOST = '0.0.0.0';
//const rpcUrl = "https://api.devnet.solana.com";
const rpcUrl = "https://localhost:8899";


// estalish connection
const establishConnection = async () => {
  connection = new solanaWeb3.Connection(rpcUrl, 'confirmed');
  console.log('Connection to cluster established:', rpcUrl);
}


// get recent block
const getRecentBlock = async () => {
  let blockInfo;
  blockInfo = await connection.getEpochInfo();
  return blockInfo;
}


const connectWallet = async () => {

  let secretKey = Uint8Array.from([195, 80, 72, 67, 69, 185, 173, 63, 197, 2, 7, 57, 26, 114, 117, 39, 38, 244, 192, 175, 88, 98, 45, 98, 31, 16, 83, 178, 254, 92, 29, 18, 89, 100, 117, 77, 219, 232, 204, 45, 57, 89, 33, 204, 164, 252, 25, 254, 124, 63, 209, 17, 211, 255, 134, 196, 246, 143, 232, 221, 33, 60, 223, 180]
  );

  keypair = solanaWeb3.Keypair.fromSecretKey(secretKey);
}


const getBalance = async () => {
  let balance = await connection.getBalance(keypair.publicKey);
  return balance;
}


// get balance from wallet
app.get('/balance', (req, res) => {

  connectWallet();
  getBalance()
    .then(balance => {
      res.statusCode = 200;
      res.setHeader('Content-Type', 'application/json');
      res.send(JSON.stringify({balance: balance}));
    }).catch(err => {
      console.log(err);
    });

});


// get recent block
app.get('/block', (req, res) => {
  getRecentBlock()
    .then(blockInfo => {
      res.statusCode = 200;
      res.setHeader('Content-Type', 'application/json');
      res.send(JSON.stringify(blockInfo));
    })
    .catch(err => {
      console.log(err);
    });

});


// hello world json
app.get('/hello', (req, res) => {
  res.statusCode = 200;

  res.setHeader('Content-Type', 'application/json');
  res.json({ key: ["hello", "jason"] });
});


app.get('/', (req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');

  res.send('Hello!');
});

// Trap CTRL-C
process.on('SIGINT', function (code) {
  console.log('SIGINT received');
  process.exit();
});

establishConnection();

app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}`);
