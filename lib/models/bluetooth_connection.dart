import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';

class BluetoothDeviceConnection {
  final BluetoothDevice device;
  final FlutterBlueClassic _bluetooth = FlutterBlueClassic();
  BluetoothConnection? connection;

  Timer? _periodicUpdateTimer;

  BluetoothDeviceConnection({required this.device, this.connection}) {
    _periodicUpdateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _connectionStateController.add(isConnected);
    });
    _init();
  }

  void _init() {
    _bluetooth.isEnabled.then((isEnabled) {
      if (isEnabled) {
        connect();
      } else {}
    });
  }

  final StreamController<bool> _connectionStateController =
      StreamController<bool>.broadcast();

  final StreamController<Exception> _errorController =
      StreamController<Exception>.broadcast();

  Stream<bool> get connectionState => _connectionStateController.stream;
  Stream<Exception> get errorStream => _errorController.stream;

  bool get isConnected => connection?.isConnected ?? false;
  String get deviceName => device.name ?? "Unknown Device";
  String get deviceAddress => device.address;
  String get rssi => device.rssi?.toString() ?? "N/A";

  Future<void> connect() async {
    if (isConnected) {
      return;
    }

    try {
      connection = await _bluetooth.connect(device.address);
      _connectionStateController.add(true);
    } catch (e) {
      _connectionStateController.add(false);
      _errorController.add(Exception("Failed to connect to device"));
    }
  }

  Future<void> disconnect() async {
    if (connection != null) {
      await connection?.close();
      connection = null;
      _connectionStateController.add(false);
    }
  }

  Future<void> reconnect() async {
    if (isConnected) {
      await disconnect();
    }
    await connect();
  }

  Future<void> sendData(Uint8List data) async {
    if (isConnected) {
      try {
        connection?.output.add(data);
      } catch (e) {
        _errorController.add(Exception("Failed to send data"));
      }
    }
  }

  void dispose() {
    _periodicUpdateTimer?.cancel();
    _connectionStateController.close();
    disconnect();
  }
}
