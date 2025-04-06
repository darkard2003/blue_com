import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  final String label;
  final String? value;
  final Widget? valueWidget;
  final Color? textColor;

  const InfoRow({
    super.key,
    required this.label,
    this.value,
    this.valueWidget,
    this.textColor,
  }) : assert(value != null || valueWidget != null);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        valueWidget != null
            ? valueWidget!
            : Text(
              value!,
              style: theme.textTheme.bodyLarge?.copyWith(color: textColor),
            ),
      ],
    );
  }
}
