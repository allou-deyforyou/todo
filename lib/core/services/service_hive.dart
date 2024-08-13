import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class HiveConfig {
  const HiveConfig._();

  static Future<void> development() async {
    final dir = await getApplicationDocumentsDirectory();

    _settingsBox = await Hive.openBox(
      collection: '/4690bfc45b',
      path: dir.path,
      _settingsBoxKey,
    );
  }

  static Future<void> production() async {
    return development();
  }

  static const _settingsBoxKey = 'settings';
  static Box<dynamic>? _settingsBox;
  static Box<dynamic> get settingsBox => _settingsBox!;

  /// Notifications
  static const _notificationsKey = 'notifications';

  static Stream<bool?> get notificationsStream {
    return HiveConfig.settingsBox.watch(key: _notificationsKey).asyncMap(
          (event) => event.value,
        );
  }

  static bool? get notifications {
    return HiveConfig.settingsBox.get(_notificationsKey);
  }

  static set notifications(bool? value) {
    HiveConfig.settingsBox.put(_notificationsKey, value);
  }

  /// Locale
  static const _localeKey = 'locale';

  static Stream<Locale?> get localeStream {
    return HiveConfig.settingsBox.watch(key: _localeKey).asyncMap(
          (event) => HiveConfig.locale,
        );
  }

  static Locale get locale {
    final language = HiveConfig.settingsBox.get(
      defaultValue: PlatformDispatcher.instance.locale.languageCode,
      _localeKey,
    );

    Intl.defaultLocale = language;
    return Locale(language);
  }

  static set locale(Locale value) {
    Intl.defaultLocale = value.languageCode;
    HiveConfig.settingsBox.put(_localeKey, value.languageCode);
  }

  /// ThemeMode
  static const _themeModeKey = 'theme_mode';

  static Stream<ThemeMode> get themeModeStream {
    return HiveConfig.settingsBox.watch(key: _themeModeKey).asyncMap(
          (event) => HiveConfig.themeMode,
        );
  }

  static ThemeMode get themeMode {
    return _parseThemeMode(HiveConfig.settingsBox.get(
      defaultValue: ThemeMode.system.name,
      _themeModeKey,
    ));
  }

  static set themeMode(ThemeMode value) {
    HiveConfig.settingsBox.put(_themeModeKey, value.name);
  }

  static ThemeMode _parseThemeMode(String value) {
    return switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }
}
