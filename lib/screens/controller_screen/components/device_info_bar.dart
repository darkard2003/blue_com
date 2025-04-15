import 'package:flutter/material.dart';
import 'package:blue_connect/screens/controller_screen/controller_screen_vm.dart';

class DeviceInfoBar extends StatelessWidget {
  final ControllerScreenVm viewModel;

  const DeviceInfoBar({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        _buildDeviceInfo(theme),
        const Spacer(),
        // Toggle buttons for status and control buttons
        IconButton(
          icon: Icon(
            viewModel.showStatus ? Icons.analytics : Icons.analytics_outlined,
            size: 24,
          ),
          onPressed: viewModel.toggleStatus,
          tooltip: 'Toggle Status',
          style: IconButton.styleFrom(
            backgroundColor:
                viewModel.showStatus
                    ? colorScheme.primaryContainer
                    : Colors.black26,
            foregroundColor:
                viewModel.showStatus
                    ? colorScheme.onPrimaryContainer
                    : Colors.white,
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: Icon(
            viewModel.showButtons ? Icons.grid_view : Icons.grid_view_outlined,
            size: 24,
          ),
          onPressed: viewModel.toggleButtons,
          tooltip: 'Toggle Buttons',
          style: IconButton.styleFrom(
            backgroundColor:
                viewModel.showButtons
                    ? colorScheme.secondaryContainer
                    : Colors.black26,
            foregroundColor:
                viewModel.showButtons
                    ? colorScheme.onSecondaryContainer
                    : Colors.white,
          ),
        ),
        const SizedBox(width: 8),
        // Add joystick mode toggle button
        IconButton(
          icon: Icon(
            viewModel.useFixedJoystick ? Icons.lock : Icons.lock_open,
            size: 24,
          ),
          onPressed: viewModel.toggleJoystickMode,
          tooltip:
              viewModel.useFixedJoystick ? 'Fixed Joystick' : 'Area Joystick',
          style: IconButton.styleFrom(
            backgroundColor:
                viewModel.useFixedJoystick
                    ? colorScheme.tertiaryContainer
                    : Colors.black26,
            foregroundColor:
                viewModel.useFixedJoystick
                    ? colorScheme.onTertiaryContainer
                    : Colors.white,
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.close, size: 24),
          onPressed: () => Navigator.pop(context),
          style: IconButton.styleFrom(
            backgroundColor: Colors.black26,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildDeviceInfo(ThemeData theme) {
    final secondaryColor = theme.colorScheme.secondary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          viewModel.isConnected
              ? Icons.bluetooth_connected
              : Icons.bluetooth_disabled,
          color: viewModel.isConnected ? Colors.green : Colors.red,
        ),
        const SizedBox(width: 8),
        Text(
          viewModel.deviceName,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (!viewModel.isConnected)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: IconButton(
              icon: const Icon(Icons.link_off, size: 16),
              onPressed: viewModel.connect,
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
            onPressed: viewModel.isReady ? viewModel.resetControls : null,
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
}
