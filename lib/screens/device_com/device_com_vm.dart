import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';

class DeviceComVm extends ChangeNotifier {
  BuildContext context;
  BluetoothDevice device;
  final FlutterBlueClassic _bluetooth = FlutterBlueClassic();
  BluetoothConnection? _connection;

  Timer? _periodicStateUpdateTimer;

  double _x = 0;
  double _y = 0;

  int get speed => ((1 + _y) * 127).toInt().clamp(0, 255);
  int get angle => ((1 + _x) * 127).toInt().clamp(0, 255);

  set x(double value) {
    if (value == _x) return;
    _x = value;
    sendSpeedAndAngle();
    notifyListeners();
  }

  set y(double value) {
    if (value == _y) return;
    _y = value;
    sendSpeedAndAngle();
    notifyListeners();
  }

  DeviceComVm(this.context, this.device) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _periodicStateUpdateTimer = Timer.periodic(const Duration(seconds: 1), (
      timer,
    ) {
      notifyListeners();
    });
    init();
  }

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool get isReady => !isLoading && isConnected;

  bool get isConnected {
    if (_connection == null) return false;
    return _connection!.isConnected;
  }

  Future<void> init() async {
    await connect();
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _connection?.dispose();
    _periodicStateUpdateTimer?.cancel();
    super.dispose();
  }

  void sendMessage(String message) {
    if (_connection == null || !_connection!.isConnected) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Not connected to device')));
      return;
    }
    _connection!.output.add(utf8.encode(message));
  }

  void sendBytes(Uint8List bytes) {
    if (_connection == null || !_connection!.isConnected) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Not connected to device')));
      return;
    }
    _connection!.output.add(bytes);
  }

  void sendSpeedAndAngle() {
    if (_connection == null || !_connection!.isConnected) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Not connected to device')));
      return;
    }
    final message = Uint8List.fromList([speed, angle]);
    debugPrint('Sending: $message');
    _connection!.output.add(message);
  }

  Future<void> connect() async {
    _isLoading = true;
    if (_connection == null) {
      try {
        _connection = await _bluetooth.connect(device.address);
      } catch (e) {
        _isLoading = false;
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to connect to device: $e')),
        );
        return;
      }
      if (_connection == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
    }
    _isLoading = false;
    notifyListeners();
  }
}
