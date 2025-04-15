import 'package:flutter/material.dart';
import 'package:blue_connect/screens/controller_screen/controller_screen_vm.dart';

class StatusPanel extends StatelessWidget {
  final ControllerScreenVm viewModel;

  const StatusPanel({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
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
        _buildStatusRow('Speed Value', '${viewModel.speed}', theme),
        _buildStatusRow('Angle Value', '${viewModel.angle}', theme),
        Divider(
          color: colorScheme.outline.withAlpha(51), // 0.2 * 255 = 51
          thickness: 1,
          height: 16,
        ),
        _buildStatusRow(
          'Buttons',
          '${_getButtonsStatusText(viewModel)} (${viewModel.buttons})',
          theme,
        ),
      ],
    );
  }

  String _getButtonsStatusText(ControllerScreenVm viewModel) {
    List<String> pressedButtons = [];
    for (int i = 0; i < 8; i++) {
      if (viewModel.getButton(i)) {
        pressedButtons.add(viewModel.getButtonName(i));
      }
    }

    if (pressedButtons.isEmpty) {
      return "None";
    }

    return pressedButtons.join(", ");
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
