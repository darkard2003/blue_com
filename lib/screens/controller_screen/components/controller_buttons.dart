import 'package:flutter/material.dart';
import 'package:blue_connect/screens/controller_screen/controller_screen_vm.dart';

class ControllerButtons extends StatelessWidget {
  final ControllerScreenVm viewModel;
  final List<int> buttonIndices;

  const ControllerButtons({
    super.key,
    required this.viewModel,
    required this.buttonIndices,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Define a list of colors for the buttons
    final List<Color> buttonColors = [
      colorScheme.primary, // A - Primary
      colorScheme.secondary, // B - Secondary
      colorScheme.tertiary, // C - Tertiary
      colorScheme.error, // D - Error color
      colorScheme.primary, // E - Same as A
      colorScheme.secondary, // F - Same as B
      colorScheme.tertiary, // G - Same as C
      colorScheme.error, // H - Same as D
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:
          buttonIndices.map((index) {
            final isPressed = viewModel.getButton(index);
            final name = viewModel.getButtonName(index);
            final icon = viewModel.getButtonIcon(index);
            final buttonColor = buttonColors[index];

            return GestureDetector(
              onTapDown: (_) => viewModel.setButton(index, true),
              onTapUp: (_) => viewModel.setButton(index, false),
              onTapCancel: () => viewModel.setButton(index, false),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isPressed ? buttonColor : buttonColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: buttonColor, width: 1),
                  boxShadow: [
                    if (!isPressed)
                      BoxShadow(
                        color: Colors.black.withAlpha(26),
                        blurRadius: 4,
                        spreadRadius: 0,
                        offset: const Offset(0, 2),
                      ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icon,
                        size: 16,
                        color:
                            isPressed
                                ? theme.colorScheme.onPrimary
                                : buttonColor,
                      ),
                      Text(
                        name,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color:
                              isPressed
                                  ? theme.colorScheme.onPrimary
                                  : buttonColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }
}
