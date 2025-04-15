# RC Control Protocol

This document details the communication protocol used by Blue Connect for RC (Remote Control) functionality.

## Overview

Blue Connect sends control data over Bluetooth to compatible microcontrollers (like ESP32) to control the movement of RC cars or similar projects. The controller interface provides joystick-based control with continuous updates as user input changes.

## Joystick Interface

The controller screen implements a virtual joystick with:
- X-axis: Controls steering/angle
- Y-axis: Controls speed/throttle

Both axes are normalized to values between -1 and 1, where:
- For Y-axis: -1 is maximum forward, 0 is stop, 1 is maximum reverse
- For X-axis: -1 is full left, 0 is center, 1 is full right

## Communication Protocol

### Packet Structure

Each control message is sent as a 3-byte packet:

| Byte Position | Description | Range |
|---------------|-------------|-------|
| 0 | Speed value | 0-255 |
| 1 | Angle value | 0-255 |
| 2 | Buttons bitmap | 0-255 |

### Value Mapping

#### Speed (Byte 0)
- Value Range: 0-255
- Mapping: 
  - 0: Maximum forward
  - 127: Stop/Neutral
  - 255: Maximum reverse
- Formula: `speed = ((1 - y) * 127).toInt().clamp(0, 255)`
  - Where `y` is the joystick's Y position (-1 to 1)

#### Angle (Byte 1)
- Value Range: 0-255
- Mapping:
  - 0: Full right
  - 127: Center/Straight
  - 255: Full left
- Formula: `angle = ((1 - x) * 127).toInt().clamp(0, 255)`
  - Where `x` is the joystick's X position (-1 to 1)

#### Buttons (Byte 2)
- Value Range: 0-255 (8-bit bitmap)
- Each bit represents one button's state (1=pressed, 0=released)
- Bit mapping:
  - Bit 0 (value 1): Button A
  - Bit 1 (value 2): Button B
  - Bit 2 (value 4): Button C
  - Bit 3 (value 8): Button D
  - Bit 4 (value 16): Button E
  - Bit 5 (value 32): Button F
  - Bit 6 (value 64): Button G
  - Bit 7 (value 128): Button H
- Formula: Combined bitwise OR of all pressed buttons
  - Example: If buttons A and C are pressed, byte value = 5 (binary 00000101)

### Update Frequency

Control values are sent immediately when joystick input or button states change, ensuring responsive control of the connected device.

## Microcontroller Implementation

For microcontrollers receiving these control packets:

1. Read 3 bytes from the Bluetooth serial interface
2. First byte (index 0) is the speed value (0-255)
3. Second byte (index 1) is the angle value (0-255)
4. Third byte (index 2) is the buttons bitmap (0-255)
5. Map these values to your motor controller and servo outputs:
   - Speed: Map 0-255 to your motor controller's range
   - Angle: Map 0-255 to your servo's range (typically 0-180 degrees)
   - Buttons: Check individual bits to detect which buttons are pressed
     ```c
     // Example button checking in C
     bool isButtonAPressed = (buttonsValue & 0x01) > 0;
     bool isButtonBPressed = (buttonsValue & 0x02) > 0;
     bool isButtonCPressed = (buttonsValue & 0x04) > 0;
     // etc.
     ```

## Example Implementation

For a reference implementation, see the companion ESP32 code at:
[https://github.com/darkard2003/blueSpeedControl.git](https://github.com/darkard2003/blueSpeedControl.git)

## Display Feedback

The controller interface displays feedback to the user:
- Speed percentage: 0-100% (derived from speed value)
- Angle percentage: -100% to +100% (derived from angle value)
  - -100%: Full left
  - 0%: Center
  - +100%: Full right

## Connection Management

The controller includes functionality for:
- Establishing Bluetooth connection
- Monitoring connection status
- Reconnecting when connection is lost
- Displaying device information (name, address, signal strength)