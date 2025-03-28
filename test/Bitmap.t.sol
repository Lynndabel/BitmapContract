// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.29;

import {Test} from "forge-std/Test.sol";
import {Bitmap} from "../src/Bitmap.sol";

contract BitmapTest is Test {
    Bitmap public bitmap;

    function setUp() public {
        bitmap = new Bitmap();
    }

    function testSetAndGetByte() public {
        bitmap.setByte(0, 0xFF);
        assertEq(bitmap.getByte(0), 0xFF);

        bitmap.setByte(31, 0xAA);
        assertEq(bitmap.getByte(31), 0xAA);
    }

    function testGetAllBytes() public {
        // Set some test values
        bitmap.setByte(0, 0x11);
        bitmap.setByte(1, 0x22);
        bitmap.setByte(31, 0xFF);

        uint8[] memory values = bitmap.getAllBytes();
        
        // Check array length
        assertEq(values.length, 32);
        
        // Verify specific values
        assertEq(values[0], 0x11);
        assertEq(values[1], 0x22);
        assertEq(values[31], 0xFF);
        
        // Middle bytes should be 0
        assertEq(values[15], 0);
    }

    function testSlotOutOfRange() public {
        // Test setting invalid slot
        vm.expectRevert(Bitmap.SlotOutOfRange.selector);
        bitmap.setByte(32, 0xFF);

        // Test getting invalid slot
        vm.expectRevert(Bitmap.SlotOutOfRange.selector);
        bitmap.getByte(32);
    }

    function testOverwriteByte() public {
        bitmap.setByte(5, 0xFF);
        assertEq(bitmap.getByte(5), 0xFF);

        bitmap.setByte(5, 0x00);
        assertEq(bitmap.getByte(5), 0x00);
    }
}
