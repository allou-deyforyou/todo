part of 'widget_theme.dart';

Future<T?> showThemeModal<T>({
  required BuildContext context,
  required  ThemeMode? mode,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return SettingsThemeScreen(
        mode: mode,
      );
    },
  );
}

class SettingsThemeScreen extends StatefulWidget {
  const SettingsThemeScreen({
    super.key,
    required this.mode,
  });
  final ThemeMode? mode;
  @override
  State<SettingsThemeScreen> createState() => _SettingsThemeScreenState();
}

class _SettingsThemeScreenState extends State<SettingsThemeScreen> {
  /// [Assets]
  late ThemeMode? _mode;

  void _onSelectedThemeModeChanged(ThemeMode? mode) {
    HiveConfig.themeMode = mode!;
    _mode = mode;
  }

  String _themeModeFormat(BuildContext context, ThemeMode mode) {
    return mode.format(context).capitalize();
  }

  @override
  void initState() {
    super.initState();

    /// [Assets]
    _mode = widget.mode;
  }

  @override
  void didUpdateWidget(covariant SettingsThemeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.mode != widget.mode) {
      _mode = widget.mode;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;
    return BottomSheetWrapper(
      child: CustomCupertinoPicker(
        onSelectedItemChanged: _onSelectedThemeModeChanged,
        title: Text(localizations.theme.toUpperCase()),
        confirm: const CustomFillCloseButton(),
        itemFormat: _themeModeFormat,
        items: ThemeMode.values,
        initialItem: _mode,
      ),
    );
  }
}
