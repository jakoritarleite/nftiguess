import { ethers } from 'hardhat';
import * as dotenv from 'dotenv';

dotenv.config();

async function main() {
  if (!process.env.CONTRACT_BASE_URI)
    throw Error('ContractBaseUri is not set on .env');

  const nftIGuessContractFactory = await ethers.getContractFactory('NFTIGuess');
  const nftIGuessContract = await nftIGuessContractFactory.deploy(
    process.env.CONTRACT_BASE_URI,
    10
  );

  await nftIGuessContract.deployed();

  console.log('NFTIGuess deployed to:', nftIGuessContract.address);

  let txn = await nftIGuessContract.mintNFT();
  await txn.wait();

  txn = await nftIGuessContract.mintNFT();
  await txn.wait();
}

main().catch(error => {
  console.error(error);
  process.exitCode = 1;
});
