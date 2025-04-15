import 'package:flutter/material.dart';
import 'package:blue_connect/screens/controller_screen/controller_screen_vm.dart';
import 'package:flutter_joystick/flutter_joystick.dart' as flutter_joystick;

class ControllerJoystickArea extends StatelessWidget {
  final ControllerScreenVm viewModel;
  final bool isSpeedJoystick;
  final Color color;
  final Color stickColor;

  const ControllerJoystickArea({
    super.key,
    required this.viewModel,
    required this.isSpeedJoystick,
    required this.color,
    required this.stickColor,
  });

  @override
  Widget build(BuildContext context) {
    final mode =
        isSpeedJoystick
            ? flutter_joystick.JoystickMode.vertical
            : flutter_joystick.JoystickMode.horizontal;
    final adjustedAlignment =
        isSpeedJoystick
            ? const Alignment(-0.6, 0.0)
            : const Alignment(0.6, 0.0);

    final fixedJoystickAlignment =
        isSpeedJoystick
            ? const Alignment(-0.9, 0.0)
            : const Alignment(0.9, 0.0);

    if (viewModel.useFixedJoystick) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Align(
          alignment: fixedJoystickAlignment,
          child: flutter_joystick.Joystick(
            mode: mode,
            stick: flutter_joystick.JoystickStick(
              decoration: flutter_joystick.JoystickStickDecoration(
                color: stickColor,
              ),
            ),
            base: flutter_joystick.JoystickBase(
              mode: mode,
              decoration: flutter_joystick.JoystickBaseDecoration(color: color),
            ),
            listener: (details) {
              if (!viewModel.isReady) return;
              isSpeedJoystick
                  ? viewModel.y = details.y
                  : viewModel.x = details.x;
            },
            includeInitialAnimation: false,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: flutter_joystick.JoystickArea(
        initialJoystickAlignment: adjustedAlignment,
        mode: mode,
        stick: flutter_joystick.JoystickStick(
          decoration: flutter_joystick.JoystickStickDecoration(
            color: stickColor,
          ),
        ),
        base: flutter_joystick.JoystickBase(
          mode: mode,
          decoration: flutter_joystick.JoystickBaseDecoration(color: color),
        ),
        listener: (details) {
          if (!viewModel.isReady) return;
          isSpeedJoystick ? viewModel.y = details.y : viewModel.x = details.x;
        },
        includeInitialAnimation: false,
      ),
    );
  }
}
