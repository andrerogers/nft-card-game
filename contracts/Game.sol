// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// NFT contract to inherit from.
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// Helper functions OpenZeppelin provides.
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "hardhat/console.sol";

import "../libraries/Gameplay.sol";

contract Character is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    Gameplay.Character[] characters;

    mapping(uint256 => Gameplay.Character) public nftHolderCharacters;
    mapping(address => uint256) public nftHolders;

    event CharacterMinted(address sender, uint256 tokenId, uint256 characterIndex);
    event AttackComplete(Gameplay.GameState state);

    constructor(Gameplay.Character[] memory _characters) ERC721("Elementals", "ELEMENTALS") {
	for(uint i = 0; i < _characters.length; i += 1) {
	    characters.push(_characters[i]);

	    Gameplay.Character memory c = characters[i];

	    console.log("Done initializing %s w/ HP %s, img %s", c.props.name, c.attr.hp, c.props.imageURI);
	}

	// I increment tokenIds here so that my first NFT has an ID of 1.
	// More on this in the lesson!
	_tokenIds.increment();
    }

    function checkIfUserHasNFT() public view returns (Gameplay.Character memory) {
	// Get the tokenId of the user's character NFT
	uint256 userNftTokenId = nftHolders[msg.sender];

	// If the user has a tokenId in the map, return their character.
	if (userNftTokenId > 0) {
	    return nftHolderCharacters[userNftTokenId];
	}
	else {
	    revert("No characters found!!");
	}
    }

    function turn(Gameplay.GameState memory _currentState) public {
	emit AttackComplete(Gameplay.attack(_currentState));
    }


    function getAllDefaultCharacters() public view returns (Gameplay.Character[] memory) {
	return characters;
    }

    function mintCharacter(uint _characterIndex) external {
	// Get current tokenId (starts at 1 since we incremented in the constructor).
	uint256 newItemId = _tokenIds.current();

	// Assigns the tokenId to the caller's wallet address, does the minting.
	_safeMint(msg.sender, newItemId);

	Gameplay.Properties memory mintedProps = Gameplay.Properties({
	    id: _characterIndex,
	    name: characters[_characterIndex].props.name,
	    imageURI: characters[_characterIndex].props.imageURI
	}); 

	Gameplay.Attributes memory mintedAttributes = Gameplay.Attributes({
	    hp: characters[_characterIndex].attr.hp,
	    armour: characters[_characterIndex].attr.armour,
	    damage: characters[_characterIndex].attr.damage
	});

	nftHolderCharacters[newItemId] = Gameplay.Character({
	    props: mintedProps,
	    attr: mintedAttributes
	});

	console.log("Minted NFT w/ tokenId %s and characterIndex %s", newItemId, _characterIndex);
    
	// Keep an easy way to see who owns what NFT.
	nftHolders[msg.sender] = newItemId;

	// Increment the tokenId for the next person that uses it.
	_tokenIds.increment();

	emit CharacterMinted(msg.sender, newItemId, _characterIndex);
    }
}
