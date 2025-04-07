import 'package:blue_connect/models/bluetooth_message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageItem extends StatelessWidget {
  final BluetoothMessage message;

  const MessageItem({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm:ss');
    final formattedTime = timeFormat.format(message.timestamp);
    final isSent = message.direction == MessageDirection.sent;
    final colorScheme = Theme.of(context).colorScheme;

    // Define terminal colors based on theme
    final terminalBackground =
        colorScheme.brightness == Brightness.dark
            ? colorScheme.surface.withAlpha(230)
            : colorScheme.surfaceContainerHighest.withAlpha(230);
    final sentColor = colorScheme.primary;
    final receivedColor = colorScheme.secondary;
    final messageTextColor = colorScheme.onSurface.withAlpha(217);
    final timeColor = colorScheme.onSurface.withAlpha(153);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      decoration: BoxDecoration(
        color: terminalBackground,
        border:
            isSent
                ? Border.all(color: sentColor.withAlpha(77), width: 1)
                : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Terminal prompt-like prefix
          Text(
            isSent ? '> ' : '< ',
            style: TextStyle(
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
              color: isSent ? sentColor : receivedColor,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '[${message.formattedDirection}]',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        color: isSent ? sentColor : receivedColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '[$formattedTime]',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: timeColor,
                      ),
                    ),
                  ],
                ),
                Text(
                  message.messageEncoded,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    color: messageTextColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
