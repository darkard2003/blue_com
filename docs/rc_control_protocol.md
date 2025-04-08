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

Each control message is sent as a 2-byte packet:

| Byte Position | Description | Range |
|---------------|-------------|-------|
| 0 | Speed value | 0-255 |
| 1 | Angle value | 0-255 |

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

### Update Frequency

Control values are sent immediately when joystick input changes, ensuring responsive control of the connected device.

## Microcontroller Implementation

For microcontrollers receiving these control packets:

1. Read 2 bytes from the Bluetooth serial interface
2. First byte (index 0) is the speed value (0-255)
3. Second byte (index 1) is the angle value (0-255)
4. Map these values to your motor controller and servo outputs:
   - Speed: Map 0-255 to your motor controller's range
   - Angle: Map 0-255 to your servo's range (typically 0-180 degrees)

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