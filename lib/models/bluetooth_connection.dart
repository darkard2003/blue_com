import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:blue_connect/models/bluetooth_message.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';

class BluetoothDeviceConnection {
  final BluetoothDevice device;
  final FlutterBlueClassic _bluetooth = FlutterBlueClassic();
  BluetoothConnection? connection;

  final List<BluetoothMessage> _messages = [];

  Timer? _periodicUpdateTimer;

  StreamSubscription? _inputSubscription;

  BluetoothDeviceConnection({required this.device, this.connection}) {
    _periodicUpdateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _connectionStateController.add(isConnected);
    });
  }

  final StreamController<bool> _connectionStateController =
      StreamController<bool>.broadcast();

  final StreamController<Exception> _errorController =
      StreamController<Exception>.broadcast();

  final StreamController<List<BluetoothMessage>> _messagesController =
      StreamController<List<BluetoothMessage>>.broadcast();

  Stream<List<BluetoothMessage>> get messagesStream =>
      _messagesController.stream;

  List<BluetoothMessage> get messages {
    var sortedMessages = List<BluetoothMessage>.from(_messages);
    sortedMessages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return sortedMessages;
  }

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
      _inputSubscription?.cancel();
      _inputSubscription = null;
      connection = await _bluetooth.connect(device.address);
      _inputSubscription = connection?.input?.listen((data) {
        final message = BluetoothMessage.fromBytes(data);
        _messages.add(message);
        _messagesController.add(_messages);
      });
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
        await connection?.output.allSent; 
      } catch (e) {
        _errorController.add(Exception("Failed to send data"));
      }
    }
  }

  Future<void> sendMessage(String message) async {
    if (isConnected) {
      try {
        var messageBytes = utf8.encode(message);
        var data = Uint8List.fromList(messageBytes);
        BluetoothMessage bluetoothMessage = BluetoothMessage.fromBytes(
          data,
          isSent: true,
        );
        connection?.output.add(data);
        await connection?.output.allSent;
        _messages.add(bluetoothMessage);
        _messagesController.add(_messages);
      } catch (e) {
        _errorController.add(Exception("Failed to send message"));
      }
    }
  }

  Future<void> dispose() async {
    _periodicUpdateTimer?.cancel();
    _inputSubscription?.cancel();

    await disconnect();

    _connectionStateController.close();
    _errorController.close();
    _messagesController.close();
  }
}
