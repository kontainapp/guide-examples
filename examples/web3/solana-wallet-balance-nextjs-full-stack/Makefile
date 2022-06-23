build:
	yarn build

dev:
	yarn dev

build_image:
	docker build -t sm/solana-wallet-balance:1.0 .

run_image:
	docker run --runtime=krun -p 3000:3000 sm/solana-wallet-balance:1.0
