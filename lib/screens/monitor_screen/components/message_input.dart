import 'package:flutter/material.dart';

class MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isEnabled;

  const MessageInput({
    super.key,
    required this.controller,
    required this.onSend,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Terminal themed colors based on the theme
    final terminalBackground =
        colorScheme.brightness == Brightness.dark
            ? colorScheme.surface.withAlpha(230)
            : colorScheme.surfaceContainerHighest.withAlpha(230);
    final terminalInputBackground =
        colorScheme.brightness == Brightness.dark
            ? colorScheme.surfaceContainerHighest.withAlpha(179)
            : colorScheme.surfaceContainerHighest.withAlpha(128);
    final activeTextColor =
        colorScheme.brightness == Brightness.dark
            ? colorScheme.primary
            : colorScheme.primary;
    final disabledTextColor = colorScheme.onSurface.withAlpha(128);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: terminalBackground,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(51),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              enabled: isEnabled,
              decoration: InputDecoration(
                hintText: isEnabled ? 'Type a command...' : 'Not connected',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: terminalInputBackground,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                hintStyle: TextStyle(
                  fontFamily: 'monospace',
                  color: disabledTextColor,
                ),
              ),
              style: TextStyle(
                fontFamily: 'monospace',
                color: isEnabled ? activeTextColor : disabledTextColor,
              ),
              onSubmitted: isEnabled ? (_) => onSend() : null,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: isEnabled ? onSend : null,
            icon: Icon(
              Icons.send,
              color: isEnabled ? colorScheme.primary : disabledTextColor,
            ),
            splashRadius: 24,
            tooltip: 'Send command',
            padding: const EdgeInsets.all(8),
          ),
        ],
      ),
    );
  }
}
