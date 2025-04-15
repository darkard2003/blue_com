import 'package:flutter/material.dart';
import 'package:blue_connect/screens/controller_screen/controller_screen_vm.dart';
import 'package:blue_connect/screens/controller_screen/components/status_panel.dart';

class ControllerDashboard extends StatelessWidget {
  final ControllerScreenVm viewModel;
  final double width;
  final double height;

  const ControllerDashboard({
    super.key,
    required this.viewModel,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: width,
      height: height,
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
      child: StatusPanel(viewModel: viewModel),
    );
  }
}
