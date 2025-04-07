import 'package:blue_connect/screens/device_connection_view/device_connectoin_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/index.dart';

class DeviceConnectionView extends StatelessWidget {
  const DeviceConnectionView({super.key});

  @override
  Widget build(BuildContext context) {
    var vm = context.watch<DeviceConnectoinVm>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(vm.deviceName), elevation: 2),
      body: ListView(
        children: [
          if (vm.isConnecting)
            LinearProgressIndicator(
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              color: theme.colorScheme.primary,
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DeviceInfoCard(vm: vm),
                const SizedBox(height: 32),
                ConnectionStatusIndicator(vm: vm),
                const SizedBox(height: 24),
                ConnectionButton(vm: vm),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ActionButton(
                        icon: Icons.gamepad,
                        label: "Controller",
                        color: Colors.green,
                        isEnabled: vm.isConnected,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/controller',
                            arguments: {
                              'deviceConnection': vm.deviceConnection,
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ActionButton(
                        icon: Icons.terminal,
                        label: "Monitor",
                        color: Colors.orange,
                        isEnabled: vm.isConnected,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/monitor',
                            arguments: {
                              'deviceConnection': vm.deviceConnection,
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ActionButton(
                        icon: Icons.radar,
                        label: "Ping Test",
                        color: Colors.purple,
                        isEnabled: vm.isConnected,
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
