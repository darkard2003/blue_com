import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:permission_handler/permission_handler.dart';

enum DeviceTypeView { scan, bonded }

extension DeviceTypeViewTitle on DeviceTypeView {
  String get name => switch (this) {
    DeviceTypeView.bonded => "Bonded Devices",
    DeviceTypeView.scan => "Scan Results",
  };
}

class DeviceListVm extends ChangeNotifier {
  BuildContext context;
  DeviceListVm(this.context) {
    init();
  }

  final FlutterBlueClassic _bluetooth = FlutterBlueClassic();

  bool _isInitializing = true;
  bool _isSupported = false;
  bool _isEnabled = false;
  bool _scanning = false;
  bool _bluetoothPermissionGranted = false;

  bool get isInitializing => _isInitializing;
  bool get isSupported => _isInitializing || _isSupported;
  bool get isEnabled => _isInitializing || _isEnabled;
  bool get scanning => _scanning;

  List<BluetoothDevice> _bondedDevices = [];
  // Using a Map with address as key to ensure uniqueness of devices
  final Map<String, BluetoothDevice> _scanResultsMap = {};

  List<BluetoothDevice> get bondedDevices => _bondedDevices;
  List<BluetoothDevice> get scanResults => _scanResultsMap.values.toList();

  StreamSubscription<BluetoothDevice>? _scanResultsSubscription;
  StreamSubscription<bool>? _scanStateSubscription;
  Timer? _scanTimeout;

  DeviceTypeView _view = DeviceTypeView.scan;
  DeviceTypeView get view => _view;
  set view(DeviceTypeView value) {
    _view = value;
    notifyListeners();
  }

  List<BluetoothDevice> get devices {
    if (_view == DeviceTypeView.bonded) {
      return _bondedDevices;
    } else {
      final sortedResults = scanResults;
      sortedResults.sort((a, b) {
        final aRssi = a.rssi ?? -100;
        final bRssi = b.rssi ?? -100;
        return bRssi.compareTo(aRssi);
      });
      return sortedResults;
    }
  }

  Future<void> init() async {
    _isSupported = await _bluetooth.isSupported;
    _isEnabled = await _bluetooth.isEnabled;

    await _getDevices();

    _scanResultsSubscription = _bluetooth.scanResults.listen((result) {
      _scanResultsMap[result.address] = result;
      notifyListeners();
    });

    _scanStateSubscription = _bluetooth.isScanning.listen((scanning) {
      _scanning = scanning;
      notifyListeners();
    });

    _isInitializing = false;
    notifyListeners();
    startScan();
  }

  Future<void> _checkBluetoothPermission() async {
    _bluetoothPermissionGranted = await Permission.bluetooth.isGranted;
    if (_bluetoothPermissionGranted) {
      return;
    }
    final status = await Permission.bluetooth.request();
    if (status.isGranted) {
      _bluetoothPermissionGranted = true;
      notifyListeners();
    } else {}
  }

  void startScan() {
    view = DeviceTypeView.scan;
    _checkBluetoothPermission();
    _scanResultsMap.clear();
    _bluetooth.startScan();
    _scanning = true;
    _scanTimeout = Timer(const Duration(seconds: 10), () {
      stopScan();
    });
    notifyListeners();
  }

  void stopScan() {
    _bluetooth.stopScan();
    notifyListeners();
  }

  @override
  void dispose() {
    _scanResultsSubscription?.cancel();
    _scanStateSubscription?.cancel();
    super.dispose();
  }

  Future<void> _getDevices() async {
    _bondedDevices = await _bluetooth.bondedDevices ?? [];
    _scanTimeout?.cancel();
    notifyListeners();
  }
}
