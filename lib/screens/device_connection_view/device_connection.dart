import 'package:blue_connect/screens/device_connection_view/device_connection_view.dart';
import 'package:blue_connect/screens/device_connection_view/device_connectoin_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:provider/provider.dart';

class DeviceConnection extends StatelessWidget {
  const DeviceConnection({super.key});

  @override
  Widget build(BuildContext context) {
    var args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    var device = args['device'] as BluetoothDevice;
    return ChangeNotifierProvider(
      create: (context) => DeviceConnectoinVm(context, device),
      child: DeviceConnectionView(),
    );
  }
}
