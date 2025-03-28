// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Counter.sol";

contract TOKENSIGNERTest is Test {
    TOKENSIGNER token;
    address originalSigner;
    address fakeSigner;
    uint256 amount = 100;
    uint256 originalSignerPrivateKey = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80; // Private key for 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266

    function setUp() public {
        token = new TOKENSIGNER();
        originalSigner = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266; // Original signer
        fakeSigner = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8; // Fake signer
    }

    function testMintWithCorrectSignature() public {
        bytes32 message = keccak256(abi.encodePacked(originalSigner, amount));
        bytes32 ethSignedMessageHash = keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", message)
        );
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(originalSignerPrivateKey, ethSignedMessageHash);
        bytes memory signature = abi.encodePacked(r, s, v);

        token.mintWithSignature(originalSigner, amount, signature);
        assertEq(token.balanceOf(originalSigner), amount);
    }

    function testMintWithIncorrectSignature() public {
        bytes32 message = keccak256(abi.encodePacked(fakeSigner, amount));
        bytes32 ethSignedMessageHash = keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", message)
        );
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(1, ethSignedMessageHash);
        bytes memory signature = abi.encodePacked(r, s, v);

        vm.expectRevert("NOMINT");
        token.mintWithSignature(fakeSigner, amount, signature);
    }
}