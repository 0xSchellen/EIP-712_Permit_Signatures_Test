# EIP-712 Permit

Testing EIP-712 Signatures
Intro
EIP-712 introduced the ability to sign transactions off-chain which other users can later execute on-chain. A common example is EIP-2612 gasless token approvals.

Traditionally, setting a user or contract allowance to transfer ERC-20 tokens from an owner's balance required the owner to submit an approval on-chain. As this proved to be poor UX, DAI introduced ERC-20 permit (later standardized as EIP-2612) allowing the owner to sign the approval off-chain which the spender (or anyone else!) can submit on-chain prior to the transferFrom.

This guide will cover testing this pattern in Solidity using Foundry.

Based on the foundry/forge/anvil book: 
https://book.getfoundry.sh/tutorials/testing-eip712.html

Install Foundry Program : ""https://github.com/foundry-rs/foundry

Install on Linux
curl -L https://foundry.paradigm.xyz | bash;
foundryup

Install on Windows
open bash
cd C:\Users\carlo
delete foundry directory 
rm -r foundry

git clone https://github.com/foundry-rs/foundry
cd foundry

cargo install --path ./cli --bins --locked --force

cargo install --path ./anvil --locked --force

Foundry Basic initalization
cd into project directory

forge init --force
forge install foundry-rs/forge-std
forge install Openzeppelin/openzeppelin-contracts
forge install Rari-Capital/solmate 


Create file remappings.txt on the project´s root directory

forge-std/=lib/forge-std/src/
ds-test/=lib/forge-std/lib/ds-test/src/
openzeppelin-contracts/=lib/openzeppelin-contracts/contracts/
solmate/=lib/solmate/src/
gnosis/=lib/safe-contracts/contracts/


Forge Commands
forge build
forge test
forge test --match-test testExploit --match-contract Unstoppable

Compile & deploy
export RPC_URL=https://rinkeby.arbitrum.io/rpc
export PRIVATE_KEY=0x6b...d36a11d2dc
export name=myNFT
export symbol=MNFT
forge create NFT --rpc-url=$RPC_URL --private-key=$PRIVATE_KEY --constructor-args <name> <symbol> 