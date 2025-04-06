import 'package:flutter/material.dart';

class RssiIndicator extends StatelessWidget {
  final String rssi;
  final bool isCompact;

  const RssiIndicator({super.key, required this.rssi, this.isCompact = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    int? rssiValue = int.tryParse(rssi);

    if (rssiValue == null) {
      return Text('N/A', style: theme.textTheme.bodyLarge);
    }

    return isCompact
        ? _buildCompactIndicator(rssiValue, theme)
        : _buildFullIndicator(rssiValue, theme);
  }

  Widget _buildFullIndicator(int rssiValue, ThemeData theme) {
    final (signalColor, signalText, signalBars) = _getSignalInfo(rssiValue);

    return Row(
      children: [
        Text('$rssiValue dBm', style: theme.textTheme.bodyLarge),
        const SizedBox(width: 8),
        _buildSignalBars(signalBars, signalColor),
        const SizedBox(width: 4),
        Text(
          signalText,
          style: theme.textTheme.bodySmall?.copyWith(color: signalColor),
        ),
      ],
    );
  }

  Widget _buildCompactIndicator(int rssiValue, ThemeData theme) {
    final (signalColor, _, signalBars) = _getSignalInfo(rssiValue);

    return SizedBox(
      width: 60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
                _buildSignalBars(
                  signalBars,
                  signalColor,
                  compact: true,
                ).children,
          ),
          const SizedBox(height: 4),
          Text(
            '$rssiValue dBm',
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 10,
              color: theme.textTheme.bodySmall?.color?.withAlpha(204),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  (Color, String, int) _getSignalInfo(int rssiValue) {
    Color signalColor;
    String signalText;
    int signalBars;

    if (rssiValue > -60) {
      signalColor = Colors.green;
      signalText = "Excellent";
      signalBars = 4;
    } else if (rssiValue > -70) {
      signalColor = Colors.lightGreen;
      signalText = "Good";
      signalBars = 3;
    } else if (rssiValue > -80) {
      signalColor = Colors.orange;
      signalText = "Fair";
      signalBars = 2;
    } else {
      signalColor = Colors.red;
      signalText = "Poor";
      signalBars = 1;
    }

    return (signalColor, signalText, signalBars);
  }

  Row _buildSignalBars(
    int signalBars,
    Color signalColor, {
    bool compact = false,
  }) {
    final double baseHeight = compact ? 10 : 12;
    final double heightIncrement = compact ? 2 : 3;
    final double width = compact ? 4 : 5;

    return Row(
      children: List.generate(4, (index) {
        return Container(
          margin: const EdgeInsets.only(right: 2),
          height: baseHeight + (index * heightIncrement),
          width: width,
          decoration: BoxDecoration(
            color: index < signalBars ? signalColor : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(compact ? 1 : 2),
          ),
        );
      }),
    );
  }
}
