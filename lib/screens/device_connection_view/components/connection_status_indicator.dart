import 'package:blue_connect/screens/device_connection_view/device_connectoin_vm.dart';
import 'package:flutter/material.dart';

class ConnectionStatusIndicator extends StatelessWidget {
  final DeviceConnectoinVm vm;

  const ConnectionStatusIndicator({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Define dynamic colors based on connection state
    final Color primaryColor =
        vm.isConnected ? colorScheme.primary : colorScheme.error;
    final Color containerColor =
        vm.isConnected
            ? colorScheme.primaryContainer.withAlpha(77) // 0.3 * 255 ≈ 77
            : colorScheme.errorContainer.withAlpha(77);
    final Color borderColor =
        vm.isConnected
            ? colorScheme.primary.withAlpha(128) // 0.5 * 255 ≈ 128
            : colorScheme.error.withAlpha(128);
    final Color connectingColor = colorScheme.tertiary;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            vm.isConnected
                ? Icons.bluetooth_connected
                : Icons.bluetooth_disabled,
            color: primaryColor,
            size: 28,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                vm.isConnected ? "Connected" : "Disconnected",
                style: theme.textTheme.titleMedium?.copyWith(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (vm.isConnecting)
                Text(
                  "Connecting...",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: connectingColor,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
