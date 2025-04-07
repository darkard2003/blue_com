import 'package:blue_connect/screens/device_connection_view/device_connectoin_vm.dart';
import 'package:flutter/material.dart';

class ConnectionButton extends StatelessWidget {
  final DeviceConnectoinVm vm;

  const ConnectionButton({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var connectedColor = theme.colorScheme.error;
    var disconnectedColor = theme.colorScheme.primary;

    var onConnectedColor = theme.colorScheme.onError;
    var onDisconnectedColor = theme.colorScheme.onPrimary;

    return Column(
      children: [
        Container(
          key: ValueKey(
            vm.isConnected ? 'DisconnectContainer' : 'ConnectContainer',
          ),
          height: 56,
          decoration: BoxDecoration(
            color: vm.isConnected ? connectedColor : disconnectedColor,
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
                          vm.isConnected
                              ? onConnectedColor
                              : onDisconnectedColor,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      vm.isConnected ? "Disconnect" : "Connect",
                      style: theme.textTheme.titleMedium?.copyWith(
                        color:
                            vm.isConnected
                                ? onConnectedColor
                                : onDisconnectedColor,
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
      ],
    );
  }
}
