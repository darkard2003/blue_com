import 'package:blue_connect/screens/device_connection_view/device_connectoin_vm.dart';
import 'package:flutter/material.dart';

class ConnectionStatusIndicator extends StatelessWidget {
  final DeviceConnectoinVm vm;

  const ConnectionStatusIndicator({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color:
            vm.isConnected
                ? Colors.green.withAlpha(26)
                : Colors.red.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: vm.isConnected ? Colors.green.shade300 : Colors.red.shade300,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            vm.isConnected
                ? Icons.bluetooth_connected
                : Icons.bluetooth_disabled,
            color: vm.isConnected ? Colors.green : Colors.red,
            size: 28,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                vm.isConnected ? "Connected" : "Disconnected",
                style: theme.textTheme.titleMedium?.copyWith(
                  color: vm.isConnected ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (vm.isConnecting)
                Text(
                  "Connecting...",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.orange,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
