// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "./Mintable.sol";

contract PeaceKoalasTest is ERC721, ERC721Enumerable, ERC721URIStorage, Mintable {
    string private _baseUrl;

    constructor(
        address _owner,
        string memory _name,
        string memory _symbol,
        address _imx
    ) ERC721(_name, _symbol) Mintable(_owner, _imx) {
        _baseUrl = "https://nft-for-ukraine-five.vercel.app/api/metadata/";
    }

    function _mintFor(
        address user,
        uint256 id,
        bytes memory
    ) internal override {
        _safeMint(user, id);
    }

    function setBaseAddress(string memory baseUrl)
        public
        onlyOwner
        returns (string memory)
    {
        require(
            bytes(baseUrl).length > 0,
            "Cannot set base address with an invalid 'url'."
        );

        _baseUrl = baseUrl;
        emit BaseUrlChanged(_baseUrl, baseUrl);
        return _baseUrl;
    }

    // The following functions are overrides required by Solidity.
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    /**
     * @dev Emitted when `baseUrl` changed `oldUrl` to `newUrl`.
     */
    event BaseUrlChanged(string indexed oldUrl, string indexed newUrl);
}