import 'dart:typed_data';

enum MessageDirection { sent, received }

class BluetoothMessage {
  final Uint8List message;
  final DateTime timestamp;
  final MessageDirection direction;

  BluetoothMessage({
    required this.message,
    required this.timestamp,
    required this.direction,
  });

  @override
  String toString() {
    return 'BluetoothMessage{message: $message, timestamp: $timestamp, direction: $direction}';
  }

  String get formattedMessage {
    return message
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join(' ');
  }

  String get formattedTimestamp {
    return '${timestamp.hour}:${timestamp.minute}:${timestamp.second}';
  }

  String get formattedDirection {
    return direction == MessageDirection.sent ? 'Sent' : 'Received';
  }

  String get messageEncoded {
    try {
      return String.fromCharCodes(message);
    } catch (e) {
      return 'Binary: ${message.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(' ')}';
    }
  }

  factory BluetoothMessage.fromBytes(Uint8List bytes, {bool isSent = false}) {
    return BluetoothMessage(
      message: bytes,
      timestamp: DateTime.now(),
      direction: isSent ? MessageDirection.sent : MessageDirection.received,
    );
  }
}
