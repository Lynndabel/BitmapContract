//SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract Bitmap {
    // Custom error for invalid slot
    error SlotOutOfRange();

    // Single uint256 to store all 32 bytes
    uint256 private bitmap;

    // Store a byte in a specific slot (0-31)
    function setByte(uint8 slot, uint8 value) public {
        if (slot >= 32) revert SlotOutOfRange();
        
        // Calculate bit position
        uint256 position = slot * 8;
        
        // Create a mask to clear the existing byte
        uint256 mask = ~(uint256(0xFF) << position);
        
        // Clear the existing byte and set the new value
        bitmap = (bitmap & mask) | (uint256(value) << position);
    }

    // Get all values from all slots
    function getAllBytes() public view returns (uint8[] memory) {
        uint8[] memory values = new uint8[](32);
        
        for(uint8 i = 0; i < 32; i++) {
            // Shift right to get to the desired byte and mask with 0xFF
            values[i] = uint8((bitmap >> (i * 8)) & 0xFF);
        }
        
        return values;
    }

    // Get value from a specific slot
    function getByte(uint8 slot) public view returns (uint8) {
        if (slot >= 32) revert SlotOutOfRange();
        
        // Shift right to get to the desired byte and mask with 0xFF
        return uint8((bitmap >> (slot * 8)) & 0xFF);
    }
}