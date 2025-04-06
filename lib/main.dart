import 'package:blue_connect/screens/device_com/device_com.dart';
import 'package:blue_connect/screens/device_connection_view/device_connection.dart';
import 'package:blue_connect/screens/device_list/device_list.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        // Fallback color schemes if dynamic colors are not available
        ColorScheme lightColorScheme = ColorScheme.fromSeed(
          seedColor: Colors.cyan,
          brightness: Brightness.light,
        );

        ColorScheme darkColorScheme = ColorScheme.fromSeed(
          seedColor: Colors.cyan,
          brightness: Brightness.dark,
        );

        // Use dynamic color scheme if available
        if (lightDynamic != null) {
          lightColorScheme = lightDynamic;
        }

        if (darkDynamic != null) {
          darkColorScheme = darkDynamic;
        }

        return MaterialApp(
          theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: darkColorScheme,
          ),
          routes: {
            '/': (context) => DeviceList(),
            '/com': (context) => DeviceCom(),
            '/connection': (context) => DeviceConnection(),
          },
          initialRoute: '/',
        );
      },
    );
  }
}
