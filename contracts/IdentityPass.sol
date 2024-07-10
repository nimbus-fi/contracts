// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract IdentityPassNFT is ERC721 {
    uint256 public tokenCounter;

    struct Patient {
        string name;
        uint256 age;
        string country;
        string gender;
        string category;
        string uniqueId;
    }

    mapping(uint256 => Patient) public patients;
    mapping(address => bool) public addressMinted;

    constructor() ERC721("IdentityPassNFT", "IPN") {
        tokenCounter = 0;
    }

    function mintIdentityNFT(
        string memory name,
        uint256 age,
        string memory country,
        string memory gender,
        string memory category,
        string memory uniqueId
    ) public {
        require(!addressMinted[msg.sender], "Address has already minted an NFT");

        uint256 tokenId = tokenCounter + 1;
        _safeMint(msg.sender, tokenId);
        patients[tokenId] = Patient(name, age, country, gender, category, uniqueId);
        addressMinted[msg.sender] = true;
        tokenCounter++;
    }

    function getTokenIdByAddress(address user) public view returns (uint256) {
        require(addressMinted[user], "Address has not minted an NFT");
        for (uint256 i = 1; i <= tokenCounter; i++) {
            if (ownerOf(i) == user) {
                return i;
            }
        }
        revert("NFT not found for the address");
    }
}

