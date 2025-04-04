import 'package:blue_connect/screens/device_com/device_com_view.dart';
import 'package:blue_connect/screens/device_com/device_com_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:provider/provider.dart';

class DeviceCom extends StatelessWidget {
  const DeviceCom({super.key});

  @override
  Widget build(BuildContext context) {
    var args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    var device = args['device'] as BluetoothDevice;

    return ChangeNotifierProvider(
      create: (context) => DeviceComVm(context, device),
      child: DeviceComView(),
    );
  }
}
