// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract TOKENSIGNER is ERC20 {
    constructor() ERC20("TokenSigner", "TSGN") {}

    function mintWithSignature(address signer, uint256 amount, bytes memory signature) public {
        cverify(signer, amount, signature);
        _mint(signer, amount);
    }

    function cverify(address signer, uint256 amount, bytes memory sig) internal pure {
        bytes32 h = keccak256(abi.encodePacked(signer, amount));
        h = keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", h)
        );
        if (ECDSA.recover(h, sig) != signer) revert("NOMINT");
    }
}