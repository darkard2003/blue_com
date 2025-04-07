import 'package:blue_connect/screens/monitor_screen/monitor_vm.dart';
import 'package:blue_connect/screens/monitor_screen/components/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MonitorView extends StatelessWidget {
  const MonitorView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MonitorViewModel>(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Define terminal themed colors based on the theme
    final terminalBackground =
        colorScheme.brightness == Brightness.dark
            ? colorScheme.surface.withAlpha(230)
            : colorScheme.surfaceContainerHighest.withAlpha(230);
    final statusConnected = colorScheme.primary;
    final statusDisconnected = colorScheme.error;
    final statusTextColor = colorScheme.onSurface.withAlpha(217);
    final noDataColor = colorScheme.onSurface.withAlpha(153);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Terminal Monitor'),
            Text(
              vm.deviceName,
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          if (!vm.isConnected)
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Reconnect',
              onPressed: vm.reconnect,
            ),
        ],
      ),
      body: Column(
        children: [
          // Connection status indicator
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            color: terminalBackground,
            child: Row(
              children: [
                Icon(
                  vm.isConnected
                      ? Icons.bluetooth_connected
                      : Icons.bluetooth_disabled,
                  color: vm.isConnected ? statusConnected : statusDisconnected,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  vm.isConnected
                      ? 'CONNECTION ESTABLISHED'
                      : 'CONNECTION FAILED',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    color:
                        vm.isConnected ? statusConnected : statusDisconnected,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (!vm.isConnected)
                  TextButton.icon(
                    onPressed: vm.reconnect,
                    icon: Icon(
                      Icons.refresh,
                      color: colorScheme.primary,
                      size: 16,
                    ),
                    label: Text(
                      'RECONNECT',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: colorScheme.surfaceContainerHighest
                          .withAlpha(179),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Messages list
          Expanded(
            child: Container(
              color: terminalBackground,
              child:
                  vm.messages.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.terminal, size: 64, color: noDataColor),
                            const SizedBox(height: 16),
                            Text(
                              '[ NO DATA RECEIVED ]',
                              style: TextStyle(
                                fontFamily: 'monospace',
                                color: noDataColor,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                      : ListView.builder(
                        controller: vm.scrollController,
                        padding: const EdgeInsets.only(top: 8, bottom: 16),
                        itemCount: vm.messages.length,
                        itemBuilder: (context, index) {
                          return MessageItem(message: vm.messages[index]);
                        },
                      ),
            ),
          ),

          // Message input
          MessageInput(
            controller: vm.messageController,
            onSend: vm.sendMessage,
            isEnabled: vm.isConnected,
          ),
        ],
      ),
    );
  }
}
