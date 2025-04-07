import 'package:blue_connect/models/bluetooth_connection.dart';
import 'package:blue_connect/screens/monitor_screen/monitor_view.dart';
import 'package:blue_connect/screens/monitor_screen/monitor_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MonitorScreen extends StatelessWidget {
  const MonitorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final deviceConnection =
        args?['deviceConnection'] as BluetoothDeviceConnection?;

    if (deviceConnection == null) {
      // If no device connection was provided, navigate back to the devices list
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/');
      });
      return const Center(child: CircularProgressIndicator());
    }

    return ChangeNotifierProvider(
      create: (_) => MonitorViewModel(deviceConnection: deviceConnection),
      child: const MonitorView(),
    );
  }
}
