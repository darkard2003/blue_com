import 'package:blue_connect/screens/controller_screen/components/controller_buttons.dart';
import 'package:blue_connect/screens/controller_screen/components/controller_dashboard.dart';
import 'package:blue_connect/screens/controller_screen/components/device_info_bar.dart';
import 'package:blue_connect/screens/controller_screen/components/joystick_area.dart';
import 'package:blue_connect/screens/controller_screen/controller_screen_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ControllerScreenView extends StatelessWidget {
  const ControllerScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    var vm = context.watch<ControllerScreenVm>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.surfaceContainerHighest,
                colorScheme.surfaceContainerLow,
              ],
            ),
          ),
          child: Stack(
            children: [
              // Bottom-most layer: Joysticks
              Center(
                child: Row(
                  children: [
                    Expanded(
                      child: ControllerJoystickArea(
                        viewModel: vm,
                        isSpeedJoystick: true,
                        color: colorScheme.primary,
                        stickColor: colorScheme.onPrimary,
                      ),
                    ),
                    Expanded(
                      child: ControllerJoystickArea(
                        viewModel: vm,
                        isSpeedJoystick: false,
                        color: colorScheme.tertiary,
                        stickColor: colorScheme.onTertiary,
                      ),
                    ),
                  ],
                ),
              ),

              // Middle layer: Dashboard with status
              if (vm.showStatus)
                Center(
                  child: ControllerDashboard(
                    viewModel: vm,
                    width: size.width * 0.3,
                    height: 150,
                  ),
                ),

              // Top layer: Buttons above and below dashboard
              if (vm.showButtons)
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Top buttons (A-D)
                      Container(
                        width: size.width * 0.3,
                        margin: const EdgeInsets.only(bottom: 16),
                        child: ControllerButtons(
                          viewModel: vm,
                          buttonIndices: const [0, 1, 2, 3],
                        ),
                      ),

                      // Space for the dashboard
                      vm.showStatus
                          ? SizedBox(
                            height: 150,
                          ) // Approximate height for dashboard
                          : const SizedBox(height: 20),

                      // Bottom buttons (E-H)
                      Container(
                        width: size.width * 0.3,
                        margin: const EdgeInsets.only(top: 16),
                        child: ControllerButtons(
                          viewModel: vm,
                          buttonIndices: const [4, 5, 6, 7],
                        ),
                      ),
                    ],
                  ),
                ),

              // Top bar with device info and toggles
              Positioned(
                top: 0,
                left: 16,
                right: 16,
                child: Column(
                  children: [
                    if (vm.isLoading) const LinearProgressIndicator(),
                    DeviceInfoBar(viewModel: vm),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
