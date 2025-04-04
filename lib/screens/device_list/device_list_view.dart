import 'package:blue_connect/screens/device_list/device_list_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:provider/provider.dart';

class DeviceListView extends StatelessWidget {
  const DeviceListView({super.key});

  @override
  Widget build(BuildContext context) {
    var vm = context.watch<DeviceListVm>();
    if (!vm.isSupported) {
      return const ErrorScreen(errorMessage: 'Bluetooth is not supported');
    }
    if (!vm.isEnabled) {
      return const ErrorScreen(errorMessage: 'Bluetooth is not enabled');
    }
    if (vm.isLoading) {
      return const LoadingScreen();
    }

    return BluetoothList();
  }
}

class BluetoothList extends StatelessWidget {
  const BluetoothList({super.key});

  @override
  Widget build(BuildContext context) {
    var vm = context.watch<DeviceListVm>();
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Bluetooth Devices'),
            floating: true,
            actions: [],
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Bonded Devices (${vm.bondedDevices.length})',
                style: const TextStyle(fontSize: 22),
              ),
            ),
          ),
          SliverList.builder(
            itemCount: vm.bondedDevices.length,
            itemBuilder: (context, index) {
              var device = vm.bondedDevices[index];
              return DeviceTile(
                device: device,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/com',
                    arguments: {'device': device},
                  );
                },
              );
            },
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Available Devices (${vm.scanResults.length})',
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child:
                        vm.scanning
                            ? IconButton(
                              key: const ValueKey('stop'),
                              icon: const Icon(Icons.stop),
                              onPressed: () {
                                vm.stopScan();
                              },
                            )
                            : IconButton(
                              key: const ValueKey('start'),
                              icon: const Icon(Icons.refresh),
                              onPressed: () {
                                vm.startScan();
                              },
                            ),
                  ),
                ],
              ),
            ),
          ),
          SliverList.builder(
            itemCount: vm.scanResults.length,
            itemBuilder: (context, index) {
              var result = vm.scanResults[index];
              return DeviceTile(
                device: result,
                onTap: () {
                  // vm.connect(result.device);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class DeviceTile extends StatelessWidget {
  final BluetoothDevice device;
  final VoidCallback? onTap;
  const DeviceTile({super.key, required this.device, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(device.name ?? 'Unknown Device'),
      subtitle: Text(device.address),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Loading')),
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  final String errorMessage;
  const ErrorScreen({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Text(errorMessage, style: const TextStyle(fontSize: 24)),
      ),
    );
  }
}
