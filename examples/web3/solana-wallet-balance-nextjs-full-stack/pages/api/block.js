// Next.js API route support: https://nextjs.org/docs/api-routes/introduction
import * as Web3 from '@solana/web3.js'
import nc from "next-connect"

// sample: $ curl http://20.69.99.60:3000/api/block
export default async function block(req, res) {
  try {
    // const rpcUrl = "https://api.devnet.solana.com";
    // connection = new solanaWeb3.Connection(rpcUrl, 'confirmed');

    const connection = new Web3.Connection(Web3.clusterApiUrl('devnet'))
    let blockInfo = await connection.getEpochInfo();

    res.setHeader('Content-Type', 'application/json');
    res.status(200).json({ 'blockInfo': blockInfo })
  } catch (err) {
    res.status(500).json({ error: 'failed to load data' })
  }
}
