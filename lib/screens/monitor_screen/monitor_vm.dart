import 'dart:async';
import 'package:blue_connect/models/bluetooth_connection.dart';
import 'package:blue_connect/models/bluetooth_message.dart';
import 'package:flutter/material.dart';

class MonitorViewModel extends ChangeNotifier {
  final BluetoothDeviceConnection deviceConnection;
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  List<BluetoothMessage> messages = [];
  StreamSubscription? _messagesSubscription;
  StreamSubscription? _connectionSubscription;
  bool _isConnected = false;

  MonitorViewModel({required this.deviceConnection}) {
    _isConnected = deviceConnection.isConnected;

    // Listen to messages
    _messagesSubscription = deviceConnection.messagesStream.listen((
      messageList,
    ) {
      messages = messageList;
      notifyListeners();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });

    // Listen to connection state changes
    _connectionSubscription = deviceConnection.connectionState.listen((
      connected,
    ) {
      _isConnected = connected;
      notifyListeners();
    });

    messages = deviceConnection.messages;
  }

  bool get isConnected => _isConnected;
  String get deviceName => deviceConnection.deviceName;

  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      deviceConnection.sendMessage(messageController.text);
      messageController.clear();
    }
  }

  Future<void> reconnect() async {
    await deviceConnection.reconnect();
  }

  void clearMessages() {
    messages = [];
    notifyListeners();
  }

  @override
  void dispose() {
    _messagesSubscription?.cancel();
    _connectionSubscription?.cancel();
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
