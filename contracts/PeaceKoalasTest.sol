// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/utils/Strings.sol';
import '@imtbl/imx-contracts/contracts/IMintable.sol';
import '@imtbl/imx-contracts/contracts/Mintable.sol';

contract PeaceKoalasTest is ERC721, Ownable, IMintable{
    // Events
    event AssetMinted(address to, uint256 id, bytes blueprint);
    event UpdatedBaseURI(string URI);
    event UpdatedImxURI(address imx);

    // Addresses
    address public imx;

    // String
    string public baseURI;

    // Mappings
    mapping(uint256 => string) private _tokenURI;
    mapping(uint256 => bytes) public blueprints;

    modifier onlyIMX() {
        require(msg.sender == imx, "PeaceKoalasTest: Function can only be called by IMX");
        _;
    }

    constructor(address _imx) ERC721("PeaceKoalasTest", "PKT") {
        require(_imx != address(0x0), 'PeaceKoalasTest: Treasury address cannot be the 0x0 address');
        imx = _imx;

        setBaseURI('https://nft-for-ukraine-five.vercel.app/api/metadata/');
    }

    function mintFor(address user, uint256 quantity, bytes calldata mintingBlob) external override onlyIMX {
        require(quantity == 1, "PeaceKoalasTest: invalid quantity");
        (uint256 id, bytes memory blueprint) = Minting.split(mintingBlob);
        _mintFor(user, id);
        blueprints[id] = blueprint;
        emit AssetMinted(user, id, blueprint);
    }

    function _mintFor(address to, uint256 id) internal virtual {
        require(!_exists(id), "PeaceKoalasTest: Token ID Has Been Used");
        _mint(to, id);
    }

    function setBaseURI(string memory _URI) public onlyOwner{
        baseURI = _URI;
        emit UpdatedBaseURI(_URI);
    }

    function setIMXAddress(address _imx) public onlyOwner{
        imx = _imx;
        emit UpdatedImxURI(_imx);
    }

    /** OVERRIDES */
    function _baseURI() internal view override virtual returns (string memory) {
        return baseURI;
    }
}