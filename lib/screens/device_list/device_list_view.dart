import 'package:blue_connect/screens/device_list/device_list_vm.dart';
import 'package:blue_connect/screens/shared/error_screen.dart';
import 'package:blue_connect/screens/device_list/components/device_tile.dart';
import 'package:blue_connect/screens/device_list/components/skeleton_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:shimmer/shimmer.dart';

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

    return BluetoothList(isLoading: vm.isInitializing);
  }
}

class BluetoothList extends StatelessWidget {
  final bool isLoading;

  const BluetoothList({super.key, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    var vm = context.watch<DeviceListVm>();
    var devices = vm.devices;
    final colorScheme = Theme.of(context).colorScheme;

    final showSkeleton =
        isLoading || (vm.scanning && vm.view == DeviceTypeView.scan);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              snap: false,
              expandedHeight: 120,
              collapsedHeight: kToolbarHeight,
              flexibleSpace: FlexibleSpaceBar(
                expandedTitleScale: 1.5,
                centerTitle: false,
                titlePadding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
                title: Text(
                  'Available Devices',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Container(color: colorScheme.surface),
              ),
            ),
            SliverPinnedHeader(
              child: Container(
                color: colorScheme.surface,
                padding: const EdgeInsets.all(12.0),
                child:
                    isLoading
                        ?
                        Shimmer.fromColors(
                          baseColor: colorScheme.surfaceContainerLowest,
                          highlightColor: colorScheme.surfaceContainerLow,
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        )
                        : SegmentedButton(
                          onSelectionChanged: (s) {
                            vm.view = s.first;
                          },
                          segments:
                              DeviceTypeView.values
                                  .map(
                                    (d) => ButtonSegment(
                                      value: d,
                                      label: Text(d.name),
                                    ),
                                  )
                                  .toList(),
                          selected: {vm.view},
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.resolveWith<Color>((
                                  Set<WidgetState> states,
                                ) {
                                  if (states.contains(WidgetState.selected)) {
                                    return colorScheme.primaryContainer;
                                  }
                                  return colorScheme.surfaceContainerHighest;
                                }),
                          ),
                        ),
              ),
            ),
            SliverAnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                sliver: SliverList.builder(
                  key: ValueKey("${vm.view.name}_${vm.scanning}"),
                  itemCount:
                      vm.devices.isEmpty && !vm.scanning
                          ? 1
                          : vm.devices.length +
                              (showSkeleton ? 3 : 0) +
                              (vm.devices.isEmpty ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (vm.devices.isEmpty && !vm.scanning) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.bluetooth_disabled,
                                size: 48,
                                color: colorScheme.secondary,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "No Devices",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              if (!vm.scanning)
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: FilledButton.icon(
                                    icon: const Icon(Icons.search),
                                    label: const Text('Start Scanning'),
                                    onPressed: () => vm.startScan(),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    }

                    // Show real devices first
                    if (index < devices.length) {
                      var result = devices[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 2,
                        ),
                        color: colorScheme.surface,
                        surfaceTintColor: colorScheme.surfaceTint,
                        child: DeviceTile(
                          device: result,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/connection',
                              arguments: {'device': result},
                            );
                          },
                        ),
                      );
                    }
                    // Then show skeleton items if scanning
                    else if (showSkeleton) {
                      return const SkeletonCard();
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton:
          isLoading || vm.view != DeviceTypeView.scan
              ? null
              : (vm.scanning
                  ? FloatingActionButton(
                    onPressed: () => vm.stopScan(),
                    backgroundColor: colorScheme.errorContainer,
                    foregroundColor: colorScheme.onErrorContainer,
                    child: const Icon(Icons.stop),
                  )
                  : FloatingActionButton(
                    onPressed: () => vm.startScan(),
                    backgroundColor: colorScheme.primaryContainer,
                    foregroundColor: colorScheme.onPrimaryContainer,
                    child: const Icon(Icons.bluetooth_searching),
                  )),
    );
  }
}
