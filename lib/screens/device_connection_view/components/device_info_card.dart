import 'package:blue_connect/screens/device_connection_view/device_connectoin_vm.dart';
import 'package:blue_connect/screens/shared/rssi_indicator.dart';
import 'package:flutter/material.dart';
import 'info_row.dart';

class DeviceInfoCard extends StatelessWidget {
  final DeviceConnectoinVm vm;

  const DeviceInfoCard({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                'Device Information',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            InfoRow(label: "Device Name", value: vm.deviceName),
            const Divider(height: 24),
            InfoRow(label: "Device Address", value: vm.deviceAddress),
            const Divider(height: 24),
            InfoRow(
              label: "Signal Strength",
              valueWidget: RssiIndicator(rssi: vm.rssi),
            ),
            const Divider(height: 24),
            InfoRow(
              label: "Connection Status",
              value: vm.isConnected ? "Connected" : "Disconnected",
              textColor: vm.isConnected ? Colors.green : Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
