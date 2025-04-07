import 'package:blue_connect/screens/controller_screen/controller_screen.dart';
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
        var primaryColor = Colors.cyan;
        ColorScheme lightColorScheme = ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.light,
        );

        ColorScheme darkColorScheme = ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.dark,
        );

        if (lightDynamic != null) {
          lightDynamic = lightDynamic.copyWith(primary: primaryColor);
          lightColorScheme = lightDynamic.harmonized();
        }

        if (darkDynamic != null) {
          darkDynamic = darkDynamic.copyWith(primary: primaryColor);
          darkColorScheme = darkDynamic.harmonized();
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
            '/controller': (context) => ControllerScreen(),
            '/connection': (context) => DeviceConnection(),
          },
          initialRoute: '/',
        );
      },
    );
  }
}
