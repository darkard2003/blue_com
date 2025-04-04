import 'package:blue_connect/screens/device_com/device_com_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeviceComView extends StatelessWidget {
  const DeviceComView({super.key});

  @override
  Widget build(BuildContext context) {
    var vm = context.watch<DeviceComVm>();
    return Scaffold(
      appBar: AppBar(title: Text(vm.device.name ?? vm.device.address)),
      body: Builder(
        builder: (context) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!vm.isConnected) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Not connected'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    vm.connect();
                  },
                  child: Text('Connect'),
                ),
              ],
            );
          }
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Connected to ${vm.device.name}'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    vm.sendMessage('ON');
                  },
                  child: Text('ON'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    vm.sendMessage('OFF');
                  },
                  child: Text('OFF'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
