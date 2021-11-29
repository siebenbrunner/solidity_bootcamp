// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.4/contracts/token/ERC721/ERC721.sol"; // specify template version
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.4/contracts/access/Ownable.sol";

contract VolcanoToken is ERC721("Volcano Token", "VCT"), Ownable {

    uint256 internal tokenId;
    mapping (address => TokenData[]) public owners;

    struct TokenData {
        uint256 timestamp;
        uint256 tokenId;
        string tokenURI;
    }

    function mint() public {
        _safeMint(msg.sender, tokenId);
        TokenData memory newTokenData = TokenData({
            timestamp: block.timestamp,
            tokenId: tokenId,
            tokenURI: tokenURI(tokenId)
        });
        owners[msg.sender].push(newTokenData);
        ++tokenId;
    }

    function burn(uint256 _tokenId) public {
        require(msg.sender == ownerOf(_tokenId), "Token can only be burnt by owner!");
        _burn(_tokenId);
        _removeBurntToken(msg.sender, _tokenId);
    }

    function _removeBurntToken(address owner, uint256 _tokenId) internal {
        for (uint i=0; i<owners[owner].length; i++) {
            if (owners[owner][i].tokenId == _tokenId) {
                //owners[owner][i].pop; why does this not work?
                owners[owner][i] = owners[owner][owners[owner].length-1];
                delete owners[owner][owners[owner].length-1];
                break;
            }
        }
    }

}