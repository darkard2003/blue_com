import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';

class DeviceComVm extends ChangeNotifier {
  BuildContext context;
  BluetoothDevice device;
  final FlutterBlueClassic _bluetooth = FlutterBlueClassic();
  BluetoothConnection? _connection;

  DeviceComVm(this.context, this.device) {
    init();
  }

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool get isConnected {
    if (_connection == null) return false;
    return _connection!.isConnected;
  }

  Future<void> init() async {
    await connect();
    _isLoading = false;
    notifyListeners();
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
