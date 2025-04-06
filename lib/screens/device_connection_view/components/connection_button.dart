import 'package:blue_connect/screens/device_connection_view/device_connectoin_vm.dart';
import 'package:flutter/material.dart';

class ConnectionButton extends StatelessWidget {
  final DeviceConnectoinVm vm;

  const ConnectionButton({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          key: ValueKey(
            vm.isConnected ? 'DisconnectContainer' : 'ConnectContainer',
          ),
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors:
                  vm.isConnected
                      ? [Colors.red.shade400, Colors.red.shade700]
                      : [Colors.blue.shade400, Colors.blue.shade700],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color:
                    vm.isConnected
                        ? Colors.red.withAlpha(77)
                        : Colors.blue.withAlpha(77),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap:
                  vm.isConnecting
                      ? null
                      : () => vm.isConnected ? vm.disconnect() : vm.reconnect(),
              splashColor: Colors.white.withAlpha(51),
              highlightColor: Colors.white.withAlpha(26),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      vm.isConnected
                          ? Icons.bluetooth_disabled
                          : Icons.bluetooth_connected,
                      color:
                          vm.isConnecting
                              ? Colors.white.withAlpha(128)
                              : Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      vm.isConnected ? "Disconnect" : "Connect",
                      style: theme.textTheme.titleMedium?.copyWith(
                        color:
                            vm.isConnecting
                                ? Colors.white.withAlpha(128)
                                : Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 24),
        TextButton.icon(
          onPressed: vm.reconnect,
          icon: Icon(Icons.refresh, size: 18, color: theme.colorScheme.primary),
          label: Text(
            "Retry Connection",
            style: TextStyle(color: theme.colorScheme.primary),
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          ),
        ),
      ],
    );
  }
}
