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
      body: SafeArea(
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(width: 20),
                Expanded(
                  child: JoystickArea(
                    listener: (details) {
                      if (!vm.isReady) return;
                      vm.y = details.y;
                    },
                    mode: JoystickMode.vertical,
                    initialJoystickAlignment: Alignment.centerLeft,
                  ),
                ),
                Expanded(
                  child: JoystickArea(
                    listener: (details) {
                      if (!vm.isReady) return;
                      vm.x = details.x;
                    },
                    initialJoystickAlignment: Alignment.centerRight,
                    mode: JoystickMode.horizontal,
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
            Column(
              children: [
                if (vm.isLoading) LinearProgressIndicator(),
                Row(
                  children: [
                    Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(vm.device.name ?? "Unknown Device"),
                      Text("${vm.device.rssi}"),
                      Text(vm.device.address),
                      const SizedBox(height: 20),
                      vm.isReady ? Text('Connected') : Text('Not Connected'),
                      if (!vm.isConnected)
                        TextButton(
                          onPressed: vm.connect,
                          child: Text("Connect"),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
