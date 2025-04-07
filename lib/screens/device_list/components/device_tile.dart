import 'package:blue_connect/screens/device_list/device_list_vm.dart';
import 'package:blue_connect/screens/shared/rssi_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:provider/provider.dart';

class DeviceTile extends StatelessWidget {
  final BluetoothDevice device;
  final VoidCallback? onTap;
  const DeviceTile({super.key, required this.device, this.onTap});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DeviceListVm>();
    final isScannedDevice = vm.view == DeviceTypeView.scan;
    final colorScheme = Theme.of(context).colorScheme;
    final hasName = device.name != null && device.name!.isNotEmpty;

    return ListTile(
      title: Text(
        hasName ? device.name! : 'Unknown Device',
        style: TextStyle(
          color: colorScheme.onSurface,
          fontWeight: hasName ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        device.address,
        style: TextStyle(color: colorScheme.onSurfaceVariant),
      ),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.bluetooth, color: colorScheme.onPrimaryContainer),
      ),
      trailing:
          isScannedDevice && device.rssi != null
              ? RssiIndicator(rssi: device.rssi.toString(), isCompact: true)
              : Icon(
                Icons.arrow_forward_ios,
                color: colorScheme.primary,
                size: 16,
              ),
      onTap: onTap,
    );
  }
}
