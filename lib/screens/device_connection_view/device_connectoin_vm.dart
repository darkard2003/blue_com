import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';

class DeviceConnectoinVm extends ChangeNotifier {
  final BuildContext context;
  final BluetoothDevice device;
  DeviceConnectoinVm(this.context, this.device) {
    _periodicUpdatetimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      notifyListeners();
    });
  }

  final FlutterBlueClassic _bluetooth = FlutterBlueClassic();

  BluetoothConnection? _connection;
  bool isConnecting = false;

  bool get isConnected => _connection?.isConnected ?? false;
  String get deviceName => device.name ?? "Unknown Device";
  String get deviceAddress => device.address;
  String get rssi => device.rssi?.toString() ?? "N/A";

  Timer? _periodicUpdatetimer;

  Future<void> init() async {
    connect();
    notifyListeners();
  }

  Future<void> disconnect() async {
    if (_connection != null) {
      await _connection?.close();
      _connection = null;
      notifyListeners();
    }
  }

  Future<void> reconnect() async {
    if (isConnected) {
      await disconnect();
    }
    await connect();
  }

  Future<void> connect() async {
    isConnecting = true;
    notifyListeners();
    try {
      _connection = await _bluetooth.connect(device.address);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Failed to connect to ${device.name ?? device.address}",
          ),
        ),
      );
      debugPrint("$e");
    } finally {
      isConnecting = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _periodicUpdatetimer?.cancel();
    _connection?.dispose();
    super.dispose();
  }
}
