import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A utility class that provides access to the app's SVG icons.
///
/// Icons created by Neelakshi Das
/// https://github.com/bluecoder2003
class IconProvider {
  // SVG icon asset paths
  static const String _blackIcon =
      'assets/icons/icon_black_without_background.svg';
  static const String _tealIcon =
      'assets/icons/icon_teal_without_background.svg';
  static const String _whiteIcon =
      'assets/icons/icon_white_without_background.svg';
  static const String _withBackgroundIcon =
      'assets/icons/icon_with_background.svg';

  /// Returns the black icon without background as an SvgPicture
  static SvgPicture getBlackIcon({
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Color? color,
  }) {
    return SvgPicture.asset(
      _blackIcon,
      width: width,
      height: height,
      fit: fit,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  /// Returns the teal icon without background as an SvgPicture
  static SvgPicture getTealIcon({
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Color? color,
  }) {
    return SvgPicture.asset(
      _tealIcon,
      width: width,
      height: height,
      fit: fit,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  /// Returns the white icon without background as an SvgPicture
  static SvgPicture getWhiteIcon({
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Color? color,
  }) {
    return SvgPicture.asset(
      _whiteIcon,
      width: width,
      height: height,
      fit: fit,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  /// Returns the icon with background as an SvgPicture
  static SvgPicture getWithBackgroundIcon({
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
  }) {
    return SvgPicture.asset(
      _withBackgroundIcon,
      width: width,
      height: height,
      fit: fit,
    );
  }

  /// Returns the appropriate icon based on the brightness (dark/light mode)
  static SvgPicture getIconForBrightness(
    BuildContext context, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Color? color,
  }) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark
        ? getWhiteIcon(width: width, height: height, fit: fit, color: color)
        : getBlackIcon(width: width, height: height, fit: fit, color: color);
  }
}
