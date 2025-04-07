import 'dart:async';
import 'dart:typed_data';

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
  final bool _isLoadingConnection = false;

  double _speed = 0;
  double _angle = 0;

  bool get isConnected => deviceConnection.isConnected;
  bool get isReady => !_isLoadingConnection && isConnected;
  bool get isLoading => _isLoadingConnection;
  String get deviceName => deviceConnection.deviceName;
  String get deviceAddress => deviceConnection.deviceAddress;
  String get rssi => deviceConnection.rssi;

  int get speed => ((1 - _y) * 127).toInt().clamp(0, 255);
  int get angle => ((1 + _x) * 127).toInt().clamp(0, 255);

  double get speedPercent => ((_speed / 255) * 100).clamp(0, 100);
  double get anglePercent => (((_angle / 255) * 200) - 100).clamp(-100, 100);

  set x(double value) {
    if (value == _x) return;
    _x = value;
    _angle = ((1 + _x) * 127).clamp(0, 255);
    sendSpeedAndAngle();
    notifyListeners();
  }

  set y(double value) {
    if (value == _y) return;
    _y = value;
    _speed = ((1 - _y) * 127).clamp(0, 255);
    sendSpeedAndAngle();
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

  void sendSpeedAndAngle() {
    if (!isConnected) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Not connected to device')),
        );
      }
      return;
    }

    final message = Uint8List.fromList([speed, angle]);
    debugPrint('Sending: $message');
    deviceConnection.sendData(message);
  }

  void resetControls() {
    _x = 0;
    _y = 0;
    _speed = ((1 - _y) * 127).clamp(0, 255);
    _angle = ((1 + _x) * 127).clamp(0, 255);
    sendSpeedAndAngle();
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
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _periodicUpdateTimer?.cancel();
    _connectionStateSubscription?.cancel();
    _errorSubscription?.cancel();
    super.dispose();
  }
}
