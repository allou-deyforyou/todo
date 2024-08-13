import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

extension BuildContextExtension on BuildContext {
  MediaQueryData get mediaQuery {
    return MediaQuery.of(this);
  }

  ThemeData get theme {
    return Theme.of(this);
  }

  CupertinoThemeData get cupertinoTheme {
    return CupertinoTheme.of(this);
  }

  AppLocalizations get localizations {
    return AppLocalizations.of(this)!;
  }
}

extension StringExtension on String {
  int get fastHash {
    int i = 0;
    int hash = 0xcbf29ce484222325;
    while (i < length) {
      final codeUnit = codeUnitAt(i++);
      hash ^= codeUnit >> 8;
      hash *= 0x100000001b3;
      hash ^= codeUnit & 0xFF;
      hash *= 0x100000001b3;
    }
    return hash;
  }

  String capitalize() {
    if (isNotEmpty) {
      return '${this[0].toUpperCase()}${substring(1)}';
    }
    return this;
  }

  String pascal() => replaceAll(RegExp(' +'), ' ').split(' ').map((value) => value.capitalize()).join(' ');

  String trimSpace() {
    return replaceAll(RegExp(r'\s+'), '');
  }

  String toFlag() {
    return String.fromCharCodes(
      List.of(toUpperCase().codeUnits.map((code) => code + 127397)),
    );
  }
}

extension ListExtension<T> on List<T> {
  List<List<T>> group(bool Function(T a, T b) combine) {
    final oldList = List<T>.of(this);
    final result = List<List<T>>.empty(growable: true);
    for (var i = 0; i < oldList.length; i++) {
      final element = oldList.elementAt(i);
      final items = [element];
      for (var j = oldList.length - 1; j > i; j--) {
        final value = oldList.elementAt(j);
        if (combine(element, value)) {
          items.add(value);
          oldList.removeAt(j);
        }
      }
      result.add(items);
    }
    return result;
  }
}

extension LocaleExtension on Locale {
  String format(BuildContext context) {
    return switch (languageCode) {
      'en' => 'english',
      _ => 'français',
    };
  }
}

extension ThemeModeExtension on ThemeMode {
  String format(BuildContext context) {
    final localizations = context.localizations;
    return switch (this) {
      ThemeMode.system => localizations.themeSystem,
      ThemeMode.light => localizations.themeLight,
      ThemeMode.dark => localizations.themeDark,
    };
  }
}

extension DateTimeExtension on DateTime {
  String get format {
    return DateFormat('dd MMMM y HH:mm').format(this);
  }

  ({DateTime start, DateTime end}) monthRange() {
    DateTime startDate = DateTime(year, month, 1);
    DateTime endDate = DateTime(year, month + 1, 1);

    return (start: startDate, end: endDate);
  }

  static DateTime? tryParseFormat(String value, {required String format}) {
    try {
      return DateFormat(format).parse(value);
    } catch (e) {
      return null;
    }
  }
}

extension DurationExtension on Duration {
  TimeOfDay toTimeOfDay() {
    return TimeOfDay.fromDateTime(DateTime(1).add(this));
  }

  String format() {
    var microseconds = inMicroseconds;

    var minutes = microseconds ~/ Duration.microsecondsPerMinute;
    microseconds = microseconds.remainder(Duration.microsecondsPerMinute);

    var minutesPadding = minutes < 10 ? "0" : "";

    var seconds = microseconds ~/ Duration.microsecondsPerSecond;
    microseconds = microseconds.remainder(Duration.microsecondsPerSecond);

    var secondsPadding = seconds < 10 ? "0" : "";

    return "$minutesPadding$minutes:"
        "$secondsPadding$seconds";
  }
}
