// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract ARCnft is ERC721, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("ARCnft", "ARC") {}

    struct Verification {
        bytes32 matchId;
        uint cycle;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "https://cdn-icons-png.flaticon.com/512/6233/6233931.png";
    }

    function safeMint(address to, uint cycle) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        require(cycle <= 2, "Not eligible for token");
    }
}
