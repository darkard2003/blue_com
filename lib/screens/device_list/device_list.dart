import 'package:blue_connect/screens/device_list/device_list_view.dart';
import 'package:blue_connect/screens/device_list/device_list_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeviceList extends StatelessWidget {
  const DeviceList({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DeviceListVm(context),
      child: const DeviceListView(),
    );
  }
}
