import 'package:blue_connect/models/bluetooth_connection.dart';
import 'package:blue_connect/screens/controller_screen/controller_screen_view.dart';
import 'package:blue_connect/screens/controller_screen/controller_screen_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ControllerScreen extends StatelessWidget {
  const ControllerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    var deviceConnection =
        args['deviceConnection'] as BluetoothDeviceConnection;

    return ChangeNotifierProvider(
      create: (context) => ControllerScreenVm(context, deviceConnection),
      child: const ControllerScreenView(),
    );
  }
}
