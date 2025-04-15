import 'dart:async';

import 'package:blue_connect/services/settings_options/controller_options.dart';
import 'package:blue_connect/services/settings_options/theme_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  AppSettings._privateConstructor();
  static final AppSettings _instance =
      AppSettings._privateConstructor();

  factory AppSettings() => _instance;

  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  ControllerOption _controllerOption = ControllerOption.joystick;
  ThemeOption _themeOption = ThemeOption.system;

  StreamController get themeOptionStream =>
      StreamController<ThemeOption>.broadcast();
  StreamController get controllerOptionStream => StreamController.broadcast();

  Future<void> init() async {
    int themeOptionIndex =
        await _prefs.getInt('theme_option') ?? ThemeOption.system.index;
    int controllerOptionIndex =
        await _prefs.getInt('controller_option') ?? ControllerOption.joystick.index;

    _themeOption = ThemeOption.values[themeOptionIndex];
    _controllerOption = ControllerOption.values[controllerOptionIndex];
    themeOptionStream.add(_themeOption);
    controllerOptionStream.add(_controllerOption);
  }

  Future<void> setThemeOption(ThemeOption option) async {
    _themeOption = option;
    await _prefs.setInt('theme_option', option.index);
    themeOptionStream.add(option);
  }

  Future<void> setControllerOption(ControllerOption option) async {
    _controllerOption = option;
    await _prefs.setInt('controller_option', option.index);
    controllerOptionStream.add(option);
  }





}
