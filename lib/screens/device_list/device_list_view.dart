import 'package:blue_connect/screens/device_list/device_list_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:provider/provider.dart';
import 'package:sliver_tools/sliver_tools.dart';

class DeviceListView extends StatelessWidget {
  const DeviceListView({super.key});

  @override
  Widget build(BuildContext context) {
    var vm = context.watch<DeviceListVm>();
    if (vm.isLoading) {
      return const LoadingScreen();
    }
    if (!vm.isSupported) {
      return const ErrorScreen(errorMessage: 'Bluetooth is not supported');
    }
    if (!vm.isEnabled) {
      return const ErrorScreen(errorMessage: 'Bluetooth is not enabled');
    }
    return BluetoothList();
  }
}

class BluetoothList extends StatelessWidget {
  const BluetoothList({super.key});

  @override
  Widget build(BuildContext context) {
    var vm = context.watch<DeviceListVm>();
    var devices = vm.devices;
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: const Text('Available Devices'),
              floating: true,
              actions: [
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
            SliverPinnedHeader(
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                padding: const EdgeInsets.all(12.0),
                child: SegmentedButton(
                  onSelectionChanged: (s) {
                    vm.view = s.first;
                  },
                  segments:
                      DeviceTypeView.values
                          .map(
                            (d) => ButtonSegment(value: d, label: Text(d.name)),
                          )
                          .toList(),
                  selected: {vm.view},
                ),
              ),
            ),
            SliverAnimatedSwitcher(
              duration: Duration(milliseconds: 250),
              child: SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                sliver:
                    vm.devices.isNotEmpty
                        ? SliverList.builder(
                          key: ValueKey(vm.view.name),
                          itemCount: vm.devices.length,
                          itemBuilder: (context, index) {
                            var result = devices[index];
                            return Card(
                              child: DeviceTile(
                                device: result,
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/com',
                                    arguments: {'device': result},
                                  );
                                },
                              ),
                            );
                          },
                        )
                        : SliverFillRemaining(
                          key: const ValueKey('noDevices'),
                          child: Center(child: Text("No Devices")),
                        ),
              ),
            ),
          ],
        ),
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
