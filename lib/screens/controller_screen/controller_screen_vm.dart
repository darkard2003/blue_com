import 'dart:async';

import 'package:blue_connect/models/bluetooth_connection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ControllerScreenVm extends ChangeNotifier {
  BuildContext context;
  final BluetoothDeviceConnection deviceConnection;

  StreamSubscription? _connectionStateSubscription;
  StreamSubscription? _errorSubscription;
  Timer? _periodicUpdateTimer;

  double _x = 0;
  double _y = 0;
  final List<bool> _buttons = List.generate(8, (index) => false);
  final bool _isLoadingConnection = false;

  double _speed = 0;
  double _angle = 0;

  bool _showStatus = true;
  bool _showButtons = true; // New flag to toggle buttons visibility
  bool _useFixedJoystick = false; // Add property for joystick mode

  bool get isConnected => deviceConnection.isConnected;
  bool get isReady => !_isLoadingConnection && isConnected;
  bool get isLoading => _isLoadingConnection;
  String get deviceName => deviceConnection.deviceName;
  String get deviceAddress => deviceConnection.deviceAddress;
  String get rssi => deviceConnection.rssi;

  int get speed => ((1 - _y) * 127).toInt().clamp(0, 255);
  int get angle => ((1 - _x) * 127).toInt().clamp(0, 255);
  int get buttons => _buttons
      .asMap()
      .entries
      .map((entry) => entry.value ? 1 << entry.key : 0)
      .reduce((a, b) => a | b);

  double get speedPercent => ((_speed / 255) * 100).clamp(0, 100);
  double get anglePercent => (((_angle / 255) * 200) - 100).clamp(-100, 100);

  set x(double value) {
    if (value == _x) return;
    _x = value;
    _angle = ((1 + _x) * 127).clamp(0, 255);
    sendSpeedAngleButtons();
    notifyListeners();
  }

  set y(double value) {
    if (value == _y) return;
    _y = value;
    _speed = ((1 - _y) * 127).clamp(0, 255);
    sendSpeedAngleButtons();
    notifyListeners();
  }

  void setButton(int index, bool value) {
    if (index < 0 || index >= 8) return;
    if (_buttons[index] == value) return;

    _buttons[index] = value;
    sendSpeedAngleButtons();
    notifyListeners();
  }

  bool getButton(int index) {
    if (index < 0 || index >= 8) return false;
    return _buttons[index];
  }

  // Helper methods for button names and icons
  String getButtonName(int index) {
    switch (index) {
      case 0:
        return "A";
      case 1:
        return "B";
      case 2:
        return "C";
      case 3:
        return "D";
      case 4:
        return "E";
      case 5:
        return "F";
      case 6:
        return "G";
      case 7:
        return "H";
      default:
        return "BTN$index";
    }
  }

  IconData getButtonIcon(int index) {
    switch (index) {
      case 0:
        return Icons.looks_one_outlined;
      case 1:
        return Icons.looks_two_outlined;
      case 2:
        return Icons.looks_3_outlined;
      case 3:
        return Icons.looks_4_outlined;
      case 4:
        return Icons.keyboard_arrow_left;
      case 5:
        return Icons.keyboard_arrow_right;
      case 6:
        return Icons.arrow_back;
      case 7:
        return Icons.arrow_forward;
      default:
        return Icons.touch_app;
    }
  }

  bool get showStatus => _showStatus;

  set showStatus(bool value) {
    if (value == _showStatus) return;
    _showStatus = value;
    notifyListeners();
  }

  void toggleStatus() {
    _showStatus = !_showStatus;
    notifyListeners();
  }

  bool get showButtons => _showButtons;

  set showButtons(bool value) {
    if (value == _showButtons) return;
    _showButtons = value;
    notifyListeners();
  }

  void toggleButtons() {
    _showButtons = !_showButtons;
    notifyListeners();
  }

  bool get useFixedJoystick => _useFixedJoystick;

  set useFixedJoystick(bool value) {
    if (value == _useFixedJoystick) return;
    _useFixedJoystick = value;
    notifyListeners();
  }

  void toggleJoystickMode() {
    _useFixedJoystick = !_useFixedJoystick;
    notifyListeners();
  }

  ControllerScreenVm(this.context, this.deviceConnection) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _periodicUpdateTimer = Timer.periodic(const Duration(milliseconds: 200), (
      timer,
    ) {
      notifyListeners();
    });
    _setupSubscriptions();
  }

  void _setupSubscriptions() {
    _connectionStateSubscription = deviceConnection.connectionState.listen((
      isConnected,
    ) {
      notifyListeners();
    });

    _errorSubscription = deviceConnection.errorStream.listen((error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${error.toString()}")));
    });
  }

  void sendSpeedAngleButtons() {
    if (!isConnected) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Not connected to device')),
        );
      }
      return;
    }

    final message = Uint8List.fromList([speed, angle, buttons]);
    debugPrint('Sending: $message');
    deviceConnection.sendData(message);
  }

  void resetControls() {
    _x = 0;
    _y = 0;
    _speed = ((1 - _y) * 127).clamp(0, 255);
    _angle = ((1 + _x) * 127).clamp(0, 255);
    sendSpeedAngleButtons();
    notifyListeners();
  }

  void connect() {
    deviceConnection.connect();
  }

  void disconnect() {
    deviceConnection.disconnect();
  }

  void reconnect() {
    deviceConnection.reconnect();
  }

  @override
  void dispose() async {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _periodicUpdateTimer?.cancel();
    _connectionStateSubscription?.cancel();
    _errorSubscription?.cancel();

    // Don't dispose the deviceConnection here as it might be managed by the parent widget

    super.dispose();
  }
}
