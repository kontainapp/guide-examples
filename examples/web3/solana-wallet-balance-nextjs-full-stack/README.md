# Description
This example leverages NextJS and Solana's web3.js libraries to start up an app that has a front-end UI and an API that can return the balance of a Solana wallet address.

The UI calls the API to get the balance.  The API uses NextJS routes to invoke Solana's "devnet" connection to get the balance of the wallet.

# ref of webapp and github basis for this
https://soldev.app/course/intro-to-reading-data
https://github.com/Unboxed-Software/solana-intro-frontend/tree/challenge-solution

## Additional references
This examples shows how to use Docker with Next.js based on the [deployment documentation](https://nextjs.org/docs/deployment#docker-image). Additionally, it contains instructions for deploying to Google Cloud Run. However, you can use any container-based deployment host.

https://github.com/vercel/next.js/tree/canary/examples/with-docker

additional reference:
https://github.com/vercel/next.js/tree/canary/examples/api-routes-rest

# to run
```shell
# to install packages
$ yarn install

# to run in dev mode
$ yarn dev

# to build and run
$ yarn build
$ yarn start
```

# to use with kontain
```shell
# build
$ make build_image
# docker build -t kontainguide/solana-wallet-balance:1.0 .

# run
$ make run_image
# docker run --runtime=krun -p 3000:3000 kontainguide/solana-wallet-balance:1.0

# in another terminal, test APIs
```shell
# to get the recent block
$ curl http://20.69.99.60:3000/api/block

# to get your Solana wallet balance
$ curl http://20.69.99.60:3000/api/balance?address=<your-wallet>
an example wallet (temporarily available) is: EDNEQ7mYxsHAXPBiKPMPWJYaJBXR363jNxstrGs2CRdn
```

# UI
In browser navigate to [](http://localhost:3000/)
- enter your wallet address
- click to check the balance in the wallet