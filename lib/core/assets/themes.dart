import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';

import '_assets.dart';

class Themes {
  const Themes._();

  static const primaryColor = Color(0xFF176BEF);
  static const tertialColor = Color(0xFFFF0000);
  static const _appBarTheme = AppBarTheme(
    centerTitle: false,
  );
  static const _floatingActionButtonTheme = FloatingActionButtonThemeData(
    shape: StadiumBorder(),
    elevation: 0.0,
  );
  static const _bottomSheetTheme = BottomSheetThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(24.0),
      ),
    ),
    clipBehavior: Clip.antiAlias,
    elevation: 2.0,
  );
  static const _dividerTheme = DividerThemeData(
    thickness: 0.8,
    space: 0.8,
  );
  static final _filledButtonTheme = FilledButtonThemeData(
    style: FilledButton.styleFrom(
      shape: const StadiumBorder(),
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 16.0,
      ),
    ),
  );
  static final _textButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      shape: const StadiumBorder(),
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 12.0,
      ),
    ),
  );
  static final _outlineButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: const StadiumBorder(),
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 20.0,
      ),
    ),
  );
  static const _inputDecorationTheme = InputDecorationTheme(
    floatingLabelBehavior: FloatingLabelBehavior.always,
    contentPadding: EdgeInsets.symmetric(
      horizontal: 16.0,
      vertical: 18.0,
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(
        Radius.circular(30.0),
      ),
    ),
    labelStyle: TextStyle(fontSize: 18.0),
    isDense: true,
    filled: true,
  );
  static const _listTileTheme = ListTileThemeData(
    visualDensity: VisualDensity(
      horizontal: VisualDensity.minimumDensity,
      vertical: VisualDensity.minimumDensity,
    ),
    contentPadding: EdgeInsets.symmetric(
      horizontal: 16.0,
      vertical: 8.0,
    ),
    horizontalTitleGap: 24.0,
  );

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        dividerTheme: _dividerTheme,
        listTileTheme: _listTileTheme,
        fontFamily: FontFamily.gilroy,
        textButtonTheme: _textButtonTheme,
        bottomSheetTheme: _bottomSheetTheme,
        filledButtonTheme: _filledButtonTheme,
        outlinedButtonTheme: _outlineButtonTheme,
        scaffoldBackgroundColor: CupertinoColors.white,
        floatingActionButtonTheme: _floatingActionButtonTheme,
        inputDecorationTheme: _inputDecorationTheme.copyWith(
          // enabledBorder: _inputDecorationTheme.border?.copyWith(
          //   borderSide: const BorderSide(color: CupertinoColors.systemGrey2),
          // ),
        ),
        appBarTheme: _appBarTheme.copyWith(
          backgroundColor: CupertinoColors.white,
          systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
            systemNavigationBarColor: CupertinoColors.white,
            statusBarColor: Colors.transparent,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(
          primaryContainer: CupertinoColors.systemFill,
          secondaryContainer: const Color(0xFF8CC6F0),
          tertiaryContainer: const Color(0xFFF1E4E4),
          brightness: Brightness.light,
          seedColor: primaryColor,
          tertiary: tertialColor,
          primary: primaryColor,
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        dividerTheme: _dividerTheme,
        listTileTheme: _listTileTheme,
        fontFamily: FontFamily.gilroy,
        textButtonTheme: _textButtonTheme,
        bottomSheetTheme: _bottomSheetTheme,
        filledButtonTheme: _filledButtonTheme,
        outlinedButtonTheme: _outlineButtonTheme,
        inputDecorationTheme: _inputDecorationTheme,
        scaffoldBackgroundColor: CupertinoColors.black,
        floatingActionButtonTheme: _floatingActionButtonTheme,
        appBarTheme: _appBarTheme.copyWith(
          backgroundColor: CupertinoColors.black,
          systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
            systemNavigationBarColor: CupertinoColors.black,
            statusBarColor: Colors.transparent,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(
          primaryContainer: CupertinoColors.systemFill,
          tertiaryContainer: const Color(0xFF593F3F),
          brightness: Brightness.dark,
          onPrimary: Colors.white,
          seedColor: primaryColor,
          tertiary: tertialColor,
          primary: primaryColor,
        ),
      );

  static Widget buildTextScaler(BuildContext context, Widget? child) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: const TextScaler.linear(0.9),
      ),
      child: child!,
    );
  }

  static AnimationStyle get themeAnimationStyle => AnimationStyle(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInSine,
      );
}
