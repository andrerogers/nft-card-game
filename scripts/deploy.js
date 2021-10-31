const main = async () => {
  const gameContractFactory = await hre.ethers.getContractFactory('Game');
const gameContract = await gameContractFactory.deploy(                        
  ["Deadpool", "Wolverine", "Cable"],       
  ["https://i.imgur.com/R076K0l.jpeg", 
  "https://i.imgur.com/1CVwaj9.jpeg", 
  "https://i.imgur.com/y4ZZCum.jpeg"],
  [100, 200, 300],                    
  [100, 50, 25],
  "Apocalypse", // Boss name
  "https://i.imgur.com/veRAJUg.png", // Boss image
  10000, // Boss hp
  50 // Boss attack damage
);
    await gameContract.deployed();
  console.log("Contract deployed to:", gameContract.address);

let txn;
txn = await gameContract.mintCharacterNFT(2);
await txn.wait();

txn = await gameContract.attackBoss();
await txn.wait();

txn = await gameContract.attackBoss();
await txn.wait();

  // Get the value of the NFT's URI.
  let returnedTokenUri = await gameContract.tokenURI(1);
  console.log("Token URI:", returnedTokenUri);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
