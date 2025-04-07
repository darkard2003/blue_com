import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';

class BluetoothService {
  static final BluetoothService _instance = BluetoothService._internal();
  factory BluetoothService() => _instance;
  BluetoothService._internal();

  final FlutterBlueClassic _bluetooth = FlutterBlueClassic();

  BluetoothConnection? _connection;
  BluetoothDevice? _connectedDevice;
  final StreamController<bool> _connectionStateController =
      StreamController<bool>.broadcast();

  final Map<String, BluetoothDevice> _scanResultsMap = {};
  final StreamController<List<BluetoothDevice>> _scanResultsController =
      StreamController<List<BluetoothDevice>>.broadcast();
  final StreamController<bool> _scanningStateController =
      StreamController<bool>.broadcast();

  bool _isScanning = false;
  Timer? _scanTimeout;
  StreamSubscription? _scanResultsSubscription;
  StreamSubscription? _scanStateSubscription;

  Stream<bool> get connectionState => _connectionStateController.stream;
  Stream<List<BluetoothDevice>> get scanResultsStream =>
      _scanResultsController.stream;
  Stream<bool> get scanningStateStream => _scanningStateController.stream;

  bool get isScanning => _isScanning;
  bool get isConnected => _connection?.isConnected ?? false;
  BluetoothDevice? get connectedDevice => _connectedDevice;
  BluetoothConnection? get connection => _connection;
  List<BluetoothDevice> get scanResults => _scanResultsMap.values.toList();

  Future<bool> connect(BluetoothDevice device) async {
    if (isConnected && _connectedDevice?.address == device.address) {
      return true;
    }

    if (_connection != null) {
      await disconnect();
    }

    try {
      _connection = await _bluetooth.connect(device.address);
      _connectedDevice = device;
      _notifyConnectionState();
      return isConnected;
    } catch (e) {
      debugPrint("Error connecting to device: $e");
      return false;
    }
  }

  Future<void> disconnect() async {
    if (_connection != null) {
      await _connection?.close();
      _connection = null;
      _connectedDevice = null;
      _notifyConnectionState();
    }
  }

  void _notifyConnectionState() {
    _connectionStateController.add(isConnected);
  }

  Future<List<BluetoothDevice>> getBondedDevices() async {
    try {
      return await _bluetooth.bondedDevices ?? [];
    } catch (e) {
      debugPrint("Error getting bonded devices: $e");
      return [];
    }
  }

  void startScan({Duration? timeout}) {
    if (_isScanning) {
      return;
    }

    _initScanSubscriptions();

    _scanResultsMap.clear();
    _notifyScanResults();

    _bluetooth.startScan();
    _isScanning = true;
    _notifyScanningState();

    _scanTimeout?.cancel();
    _scanTimeout = Timer(timeout ?? const Duration(seconds: 10), stopScan);
  }

  void stopScan() {
    if (!_isScanning) {
      return;
    }

    _bluetooth.stopScan();
    _isScanning = false;
    _scanTimeout?.cancel();
    _notifyScanningState();
  }

  void _initScanSubscriptions() {
    _scanResultsSubscription?.cancel();
    _scanStateSubscription?.cancel();

    _scanResultsSubscription = _bluetooth.scanResults.listen((result) {
      _scanResultsMap[result.address] = result;
      _notifyScanResults();
    });

    _scanStateSubscription = _bluetooth.isScanning.listen((scanning) {
      _isScanning = scanning;
      _notifyScanningState();
    });
  }

  void _notifyScanResults() {
    _scanResultsController.add(_scanResultsMap.values.toList());
  }

  void _notifyScanningState() {
    _scanningStateController.add(_isScanning);
  }

  Future<bool> isSupported() async {
    return await _bluetooth.isSupported;
  }

  Future<bool> isEnabled() async {
    return await _bluetooth.isEnabled;
  }

  void dispose() {
    stopScan();
    _scanResultsSubscription?.cancel();
    _scanStateSubscription?.cancel();
    _scanResultsController.close();
    _scanningStateController.close();
    _connection?.dispose();
    _connectionStateController.close();
  }

  Future<bool> sendData(List<int> data) async {
    if (!isConnected) {
      return false;
    }

    try {
      _connection!.output.add(Uint8List.fromList(data));
      return true;
    } catch (e) {
      debugPrint("Error sending data: $e");
      return false;
    }
  }
}
