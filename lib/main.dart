import 'package:blue_connect/screens/device_com/device_com.dart';
import 'package:blue_connect/screens/device_list/device_list.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => DeviceList(),
        '/com': (context) => DeviceCom(),
      },
      initialRoute: '/',
    );
  }
}
