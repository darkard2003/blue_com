import 'package:blue_connect/screens/device_com/device_com.dart';
import 'package:blue_connect/screens/device_connection_view/device_connection.dart';
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
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      routes: {
        '/': (context) => DeviceList(),
        '/com': (context) => DeviceCom(),
        '/connection': (context) => DeviceConnection(),
      },
      initialRoute: '/',
    );
  }
}
