import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/core/assets/_assets.dart';

class CustomTag extends StatelessWidget {
  const CustomTag({
    super.key,
    required this.label,
    this.backgroundColor,
    this.icon,
  });
  final Widget? icon;
  final Widget label;
  final Color? backgroundColor;
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final backgroundColor = this.backgroundColor ?? CupertinoColors.secondarySystemFill.resolveFrom(context);
    return Chip(
      elevation: 0.0,
      side: BorderSide.none,
      shape: const StadiumBorder(),
      backgroundColor: backgroundColor,
      visualDensity: VisualDensity.compact,
      labelPadding: const EdgeInsets.only(left: 2.0),
      avatar: icon,
      label: DefaultTextStyle.merge(
        style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
        child: label,
      ),
    );
  }
}
