import 'package:blue_connect/screens/controller_screen/controller_screen_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
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
              Center(
                child: _buildControllerDashboard(vm, theme, size.width * 0.3),
              ),

              Center(
                child: Row(
                  children: [
                    Expanded(
                      child: _buildJoystickArea(
                        context: context,
                        vm: vm,
                        isSpeedJoystick: true,
                        color: colorScheme.primary,
                        stickColor: colorScheme.onPrimary,
                      ),
                    ),
                    Expanded(
                      child: _buildJoystickArea(
                        context: context,
                        vm: vm,
                        isSpeedJoystick: false,
                        color: colorScheme.tertiary,
                        stickColor: colorScheme.onTertiary,
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                top: 0,
                left: 16,
                right: 16,
                child: Column(
                  children: [
                    if (vm.isLoading) LinearProgressIndicator(),
                    Row(
                      children: [
                        _buildDeviceInfo(vm, theme),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close, size: 24),
                          onPressed: () => Navigator.pop(context),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black26,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceInfo(ControllerScreenVm vm, ThemeData theme) {
    final secondaryColor = theme.colorScheme.secondary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          vm.isConnected ? Icons.bluetooth_connected : Icons.bluetooth_disabled,
          color: vm.isConnected ? Colors.green : Colors.red,
        ),
        const SizedBox(width: 8),
        Text(
          vm.deviceName,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (!vm.isConnected)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: IconButton(
              icon: const Icon(Icons.link_off, size: 16),
              onPressed: vm.connect,
              tooltip: 'Reconnect',
              style: IconButton.styleFrom(
                backgroundColor: Colors.red.withAlpha(179), // 0.7 * 255 = 179
                foregroundColor: Colors.white,
                minimumSize: const Size(24, 24),
                padding: const EdgeInsets.all(4),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            icon: const Icon(Icons.refresh, size: 16),
            onPressed: vm.isReady ? vm.resetControls : null,
            tooltip: 'Reset Controls',
            style: IconButton.styleFrom(
              backgroundColor: secondaryColor.withAlpha(179), // 0.7 * 255 = 179
              foregroundColor: Colors.white,
              minimumSize: const Size(24, 24),
              padding: const EdgeInsets.all(4),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildJoystickArea({
    required BuildContext context,
    required ControllerScreenVm vm,
    required bool isSpeedJoystick,
    required Color color,
    required Color stickColor,
  }) {
    final mode =
        isSpeedJoystick ? JoystickMode.vertical : JoystickMode.horizontal;
    final adjustedAlignment =
        isSpeedJoystick
            ? const Alignment(-0.6, 0.0)
            : const Alignment(0.6, 0.0);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: JoystickArea(
        initialJoystickAlignment: adjustedAlignment,
        mode: mode,
        stick: JoystickStick(
          decoration: JoystickStickDecoration(color: stickColor),
        ),
        base: JoystickBase(
          mode: mode,
          decoration: JoystickBaseDecoration(color: color),
        ),
        listener: (details) {
          if (!vm.isReady) return;
          isSpeedJoystick ? vm.y = details.y : vm.x = details.x;
        },
      ),
    );
  }

  Widget _buildControllerDashboard(
    ControllerScreenVm vm,
    ThemeData theme,
    double width,
  ) {
    final colorScheme = theme.colorScheme;

    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow.withAlpha(
          128,
        ), // 0.5 * 255 = 128
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outline.withAlpha(51), // 0.2 * 255 = 51
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26), // 0.1 * 255 = 26
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.speed_outlined, color: colorScheme.primary, size: 16),
              const SizedBox(width: 6),
              Text(
                'STATUS',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildStatusRow('Speed Value', '${vm.speed}', theme),
          _buildStatusRow('Angle Value', '${vm.angle}', theme),
          Divider(
            color: colorScheme.outline.withAlpha(51), // 0.2 * 255 = 51
            thickness: 1,
            height: 16,
          ),
          _buildStatusRow('Signal', vm.rssi, theme),
          _buildStatusRow('Status', vm.isReady ? 'Ready' : 'Waiting', theme),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String value, ThemeData theme) {
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
