import 'package:blue_connect/screens/device_com/device_com_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:provider/provider.dart';

class DeviceComView extends StatelessWidget {
  const DeviceComView({super.key});

  @override
  Widget build(BuildContext context) {
    var vm = context.watch<DeviceComVm>();
    return Scaffold(
      appBar: AppBar(title: Text(vm.device.name ?? vm.device.address)),
      body: Stack(
        children: [
          Column(
            children: [
              if (vm.isLoading) LinearProgressIndicator(),
              Expanded(
                child: Center(
                  child: vm.isReady ? Text('Connected') : Text('Connecting...'),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: JoystickArea(
                  listener: (details) {
                    if (!vm.isReady) return;
                    vm.y = details.y;
                  },
                  mode: JoystickMode.vertical,
                ),
              ),
              Expanded(
                child: JoystickArea(
                  listener: (details) {
                    if (!vm.isReady) return;
                    vm.x = details.x;
                  },
                  mode: JoystickMode.horizontal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
