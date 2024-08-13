part of 'widget_language.dart';

Future<T?> showLanguageModal<T>({
  required BuildContext context,
  required Locale? locale,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return SettingsLanguageSheet(
        locale: locale,
      );
    },
  );
}

class SettingsLanguageSheet extends StatefulWidget {
  const SettingsLanguageSheet({
    super.key,
    required this.locale,
  });
  final Locale? locale;
  @override
  State<SettingsLanguageSheet> createState() => _SettingsLanguageSheetState();
}

class _SettingsLanguageSheetState extends State<SettingsLanguageSheet> {
  /// [Assets]
  late Locale? _locale;

  void _onSelectedLocaleChanged(Locale? locale) {
    HiveConfig.locale = locale!;
    _locale = locale;
  }

  String _localeFormat(BuildContext context, Locale locale) {
    return locale.format(context).capitalize();
  }

  @override
  void initState() {
    super.initState();

    /// [Assets]
    _locale = widget.locale;
  }

  @override
  void didUpdateWidget(covariant SettingsLanguageSheet oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.locale != widget.locale) {
      _locale = widget.locale;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;
    return BottomSheetWrapper(
      child: CustomCupertinoPicker(
        onSelectedItemChanged: _onSelectedLocaleChanged,
        title: Text(localizations.language.toUpperCase()),
        items: AppLocalizations.supportedLocales,
        confirm: const CustomFillCloseButton(),
        itemFormat: _localeFormat,
        initialItem: _locale,
      ),
    );
  }
}
