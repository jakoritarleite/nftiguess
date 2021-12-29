// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import {Base64} from "./libraries/Base64.sol";

contract NFTIGuess is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string private contractBaseURI;
    uint256 public tokenLimit;

    constructor(string memory _contractBaseURI, uint256 _tokenLimit)
        ERC721("nftiguess", "NFTIGUESS")
    {
        contractBaseURI = _contractBaseURI;
        tokenLimit = _tokenLimit;
        console.log("Deploying NFTIGuess contract.");
    }

    modifier checkLimit() {
        require(_tokenIds.current() < tokenLimit, "Reached token limit");
        _;
    }

    function createNFTMetadata(uint256 currentTokenId)
        private
        view
        returns (string memory json)
    {
        json = Base64.encode(
            abi.encodePacked(
                '{"name": "NFT I Guess #',
                uint2str(currentTokenId),
                '",',
                '"description": "A glassmorphism NFT collection",',
                '"image":"',
                contractBaseURI,
                uint2str(currentTokenId),
                ".png",
                '"}'
            )
        );

        return json;
    }

    function uint2str(uint256 _i) internal pure returns (string memory str) {
        if (_i == 0) return "0";

        uint256 j = _i;
        uint256 length;
        while (j != 0) {
            length++;
            j /= 10;
        }

        bytes memory bstr = new bytes(length);
        uint256 k = length;
        j = _i;
        while (j != 0) {
            bstr[--k] = bytes1(uint8(48 + (j % 10)));
            j /= 10;
        }
        str = string(bstr);
        return str;
    }

    function mintNFT() public checkLimit {
        uint256 tokenId = _tokenIds.current();

        string memory json = createNFTMetadata(tokenId);
        string memory tokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("The final token URI is %s", tokenUri);

        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, tokenUri);

        console.log(
            "An NFT w/ ID %s has been minted to %s",
            tokenId,
            msg.sender
        );

        _tokenIds.increment();
    }
}
