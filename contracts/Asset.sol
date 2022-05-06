// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./Mintable.sol";

contract Asset is ERC721, Mintable {

    // Optional - used for L1-level late reveals, a static string can be used instead (check below)
    string public baseTokenURI;
    
    constructor(
        address _owner,
        string memory _name,
        string memory _symbol,
        address _imx
    ) ERC721(_name, _symbol) Mintable(_owner, _imx) {}

    function _mintFor(
        address user,
        uint256 id,
        bytes memory blueprint
    ) internal override {
        _safeMint(user, id);
        // you may store the blueprint (on-chain metadata) here or implement some logic that relies on the blueprint data passed
        // below is a bare-minimum implementation of a simple mapping, comment it out if you are not storing on-chain metadata
        metadata[id] = blueprint;
    }
    
    // overwrite OpenZeppelin's _baseURI to define the base for tokenURI
    // can be a static value, use a variable if you want the ability to change this (L1 late-reveal)
    function _baseURI() internal view override returns (string memory) {
        return baseTokenURI;
    }

    // optional - change the baseTokenURI for late-reveal purposes
    function setBaseTokenURI(string memory uri) public onlyOwner {
        baseTokenURI = uri;
    }
}
