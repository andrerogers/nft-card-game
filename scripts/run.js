const main = async () => {
  const gameContractFactory = await hre.ethers.getContractFactory('Character');

    let characters = [];
    let fenrir = {
	props: {
	    id: 1,
	    name: "Fenrir",
	    imageURI: "https://i.imgur.com/Qp1jPj5.jpeg",
	},
	attr: {
	    hp: 100,
	    armour: 120,
	    damage: 5
	}
    };

    let boss = {
	props: {
	    id: 1,
	    name: "Zeus",
	    imageURI: "https://i.imgur.com/fHjih2f.jpeg",
	},
	attr: {
	    hp: 200,
	    armour: 120,
	    damage: 5
	}
    };

    characters.push(fenrir);
    characters.push(boss);
  
    const gameContract = await gameContractFactory.deploy(characters);
    await gameContract.deployed();
    console.log("Contract deployed to:", gameContract.address);
    let c = await gameContract.getAllDefaultCharacters(); 

    let txn;
    txn = await gameContract.mintCharacter(0, 1);
    await txn.wait();

    // Get the value of the NFT's URI.
    let returnedTokenUri = await gameContract.tokenURI(1);
    console.log("Token URI:", returnedTokenUri);

    let result = await gameContract.turn();
    // await result.wait();
    let state = await gameContract.getCurrentState();
    console.log(state.enemy.attr.hp);
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
