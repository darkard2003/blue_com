import 'dart:async';
import 'dart:typed_data'; // Add this import for Uint8List

import 'package:flutter/material.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import '../../models/bluetooth_connection.dart';

class DeviceConnectoinVm extends ChangeNotifier {
  final BuildContext context;
  final BluetoothDevice device;

  late BluetoothDeviceConnection _deviceConnection;

  BluetoothDeviceConnection get deviceConnection => _deviceConnection;
  StreamSubscription? _connectionStateSubscription;
  StreamSubscription? _errorSubscription;
  bool isConnecting = false;

  DeviceConnectoinVm(this.context, this.device) {
    _deviceConnection = BluetoothDeviceConnection(device: device);
    _setupSubscriptions();
    _periodicUpdatetimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      notifyListeners();
    });
  }

  void _setupSubscriptions() {
    _connectionStateSubscription = _deviceConnection.connectionState.listen((
      isConnected,
    ) {
      notifyListeners();
    });

    _errorSubscription = _deviceConnection.errorStream.listen((error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${error.toString()}")));
    });
  }

  bool get isConnected => _deviceConnection.isConnected;
  String get deviceName => _deviceConnection.deviceName;
  String get deviceAddress => _deviceConnection.deviceAddress;
  String get rssi => _deviceConnection.rssi;

  Timer? _periodicUpdatetimer;

  Future<void> init() async {
    connect();
    notifyListeners();
  }

  Future<void> disconnect() async {
    isConnecting = true;
    notifyListeners();

    await _deviceConnection.disconnect();

    isConnecting = false;
    notifyListeners();
  }

  Future<void> reconnect() async {
    await _deviceConnection.reconnect();
    notifyListeners();
  }

  Future<void> connect() async {
    isConnecting = true;
    notifyListeners();

    try {
      await _deviceConnection.connect();
      if (!_deviceConnection.isConnected && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to connect to ${deviceName}")),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to connect to ${deviceName}")),
      );
      debugPrint("$e");
    } finally {
      isConnecting = false;
      notifyListeners();
    }
  }

  Future<void> sendData(List<int> data) async {
    if (isConnected) {
      await _deviceConnection.sendData(Uint8List.fromList(data));
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Not connected to device")),
        );
      }
    }
  }

  @override
  void dispose() {
    _periodicUpdatetimer?.cancel();
    _connectionStateSubscription?.cancel();
    _errorSubscription?.cancel();
    _deviceConnection.dispose();
    super.dispose();
  }
}
