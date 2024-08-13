import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:todo/core/assets/_assets.dart';
import 'package:todo/features/widgets/_widgets.dart';
import 'package:todo/core/services/_services.dart';

part 'settings_screen.dart';

class SettingsSliverAppBar extends StatelessWidget {
  const SettingsSliverAppBar({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final localizations = context.localizations;
    return SliverAppBar(
      floating: true,
      titleSpacing: 0.0,
      leadingWidth: 80.0,
      toolbarHeight: 80.0,
      automaticallyImplyLeading: false,
      titleTextStyle: theme.textTheme.headlineSmall!.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
      ),
      leading: const Center(child: CustomFillBackButton()),
      title: Text(localizations.settings.capitalize()),
    );
  }
}

class SettingsSliverWrapper extends StatelessWidget {
  const SettingsSliverWrapper({
    super.key,
    required this.sliver,
  });
  final Widget sliver;
  @override
  Widget build(BuildContext context) {
    return SliverSafeArea(
      top: false,
      bottom: false,
      sliver: SliverCrossAxisConstrained(
        maxCrossAxisExtent: kMaxWidth,
        child: sliver,
      ),
    );
  }
}

class SettingsItemWrapper extends StatelessWidget {
  const SettingsItemWrapper({
    super.key,
    required this.children,
  });
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Padding(
      padding: kTabLabelPadding,
      child: Material(
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24.0)),
        ),
        color: theme.colorScheme.surfaceContainer,
        child: Column(
          children: children,
        ),
      ),
    );
  }
}

class SettingsItemWidget extends StatelessWidget {
  const SettingsItemWidget({
    super.key,
    this.onTap,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.textColor,
  });
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final Color? textColor;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return ListTile(
      onTap: onTap,
      horizontalTitleGap: 24.0,
      textColor: textColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      titleTextStyle: theme.textTheme.titleLarge!.copyWith(
        fontWeight: FontWeight.w500,
        fontSize: 16.0,
      ),
      subtitleTextStyle: const TextStyle(fontSize: 16.0),
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
    );
  }
}

class SettingsNotifs extends StatelessWidget {
  const SettingsNotifs({
    super.key,
    required this.value,
    required this.onChanged,
  });
  final bool value;
  final ValueChanged<bool>? onChanged;
  VoidCallback? _onTap() {
    if (onChanged == null) return null;
    return () => onChanged!(!value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final localizations = context.localizations;
    return SettingsItemWidget(
      onTap: _onTap(),
      leading: const Icon(CupertinoIcons.bell),
      title: Text(localizations.notifications.capitalize()),
      trailing: Switch(
        activeTrackColor: theme.colorScheme.onSurface,
        activeColor: theme.colorScheme.surface,
        onChanged: onChanged,
        value: value,
      ),
    );
  }
}

class SettingsTheme extends StatelessWidget {
  const SettingsTheme({
    super.key,
    this.onTap,
    required this.value,
  });
  final String value;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;
    return SettingsItemWidget(
      onTap: onTap,
      leading: const Icon(CupertinoIcons.paintbrush),
      title: Text(localizations.theme.capitalize()),
      trailing: Text(value),
    );
  }
}

class SettingsLanguage extends StatelessWidget {
  const SettingsLanguage({
    super.key,
    this.onTap,
    required this.value,
  });
  final String value;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;
    return SettingsItemWidget(
      onTap: onTap,
      leading: const Icon(CupertinoIcons.globe),
      title: Text(localizations.language.capitalize()),
      trailing: Text(value),
    );
  }
}

class SettingsClearButton extends StatelessWidget {
  const SettingsClearButton({
    super.key,
    required this.onPressed,
    this.child,
  });
  final Widget? child;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final localizations = context.localizations;
    final color = CupertinoColors.destructiveRed.resolveFrom(context);
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 300.0,
        child: FilledButton(
          style: FilledButton.styleFrom(
            foregroundColor: color,
            backgroundColor: theme.colorScheme.surfaceContainer,
            textStyle: theme.textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.0,
              fontSize: 14.0,
              height: 1.0,
            ),
          ),
          onPressed: onPressed,
          child: child ?? Text(localizations.deletealltasks.toUpperCase()),
        ),
      ),
    );
  }
}
