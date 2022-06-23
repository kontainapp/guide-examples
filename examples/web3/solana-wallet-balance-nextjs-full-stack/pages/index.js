import Head from 'next/head'
import { useState } from 'react'
import styles from '../styles/Home.module.css'
import AddressForm from '../components/AddressForm.tsx'
import Spinner from '../components/Spinner.js'
import * as Web3 from '@solana/web3.js'


export default function Home() {
  const [balance, setBalance] = useState(0)
  const [address, setAddress] = useState('')

  const addressSubmittedHandler = async (address) => {
    console.log(`address:${address}`)
    const balanceResponse = await fetch(`/api/balance?address=${address}`)
    const balanceJson = await balanceResponse.json()
    setBalance(balanceJson['balance'])

    // below snippet is if you wish to call Solana devnet directly from website
    // try {
    //   setAddress(address)
    //   const key = new Web3.PublicKey(address)
    //   const connection = new Web3.Connection(Web3.clusterApiUrl('devnet'))

    //   console.log(connection)

    //   connection.getBalance(key).then(balance => {
    //     setBalance(balance / Web3.LAMPORTS_PER_SOL)
    //   })
    // } catch (error) {
    //   setAddress('')
    //   setBalance(0)
    //   alert(error)
    // }
  }

  return (
    <div className={styles.App}>
      <header className={styles.AppHeader}>
        <p>
          Start Your Solana Journey
        </p>
        <AddressForm handler={addressSubmittedHandler} />
        <p>{`Address: ${address}`}</p>
        <p>{`Balance: ${balance} SOL`}</p>
      </header>
    </div>
  )
}
