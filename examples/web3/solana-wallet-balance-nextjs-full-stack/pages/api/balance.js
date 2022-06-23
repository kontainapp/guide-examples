// Next.js API route support: https://nextjs.org/docs/api-routes/introduction
import * as Web3 from '@solana/web3.js'
import nc from "next-connect"

// sample: $ curl http://20.69.99.60:3000/api/balance?address=EDNEQ7mYxsHAXPBiKPMPWJYaJBXR363jNxstrGs2CRdn
export default async function balance(req, res) {
  try {
    const address = req.query['address']
    console.log(address)

    const key = new Web3.PublicKey(address)
    // const rpcUrl = "https://api.devnet.solana.com";
    // connection = new solanaWeb3.Connection(rpcUrl, 'confirmed');
    const connection = new Web3.Connection(Web3.clusterApiUrl('devnet'))
    let balance = 0
    balance = await connection.getBalance(key);
    // or if using .then()
    // connection.getBalance(key).then(balance => {
    //   balance = balance / Web3.LAMPORTS_PER_SOL

    //   res.setHeader('Content-Type', 'application/json');
    //   res.status(200).json({ balance: balance })
    // })

    balance = balance / Web3.LAMPORTS_PER_SOL
    res.setHeader('Content-Type', 'application/json');
    res.status(200).json({ balance: balance })
  } catch (err) {
    res.status(500).json({ error: 'failed to load data' })
  }
}
