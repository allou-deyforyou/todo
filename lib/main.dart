import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'core/assets/_assets.dart';
import 'core/services/_services.dart';
import 'features/widgets/_widgets.dart';

void main() {
  runService(const MyService()).whenComplete(() => runApp(const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// [Assets]
  ThemeMode? _currentThemeMode;
  Stream<ThemeMode>? _themeModeStream;

  Locale? _currentLocale;
  Stream<Locale?>? _localeStream;

  late final GoRouter _router;

  @override
  void initState() {
    super.initState();

    /// [Assets]
    _currentLocale = HiveConfig.locale;
    _localeStream = HiveConfig.localeStream;

    _currentThemeMode = HiveConfig.themeMode;
    _themeModeStream = HiveConfig.themeModeStream;

    _router = GoRouter(
      routes: [
        GoRoute(
          path: HomeScreen.path,
          name: HomeScreen.name,
          builder: (context, state) {
            return const HomeScreen();
          },
          routes: [
            GoRoute(
              path: AddTaskScreen.path,
              name: AddTaskScreen.name,
              builder: (context, state) {
                final data = state.extra as Map<String, dynamic>?;
                return AddTaskScreen(
                  task: data?[DetailsTaskScreen.taskKey],
                );
              },
            ),
            GoRoute(
              path: DetailsTaskScreen.path,
              name: DetailsTaskScreen.name,
              builder: (context, state) {
                final data = state.extra! as Map<String, dynamic>;
                return DetailsTaskScreen(
                  task: data[DetailsTaskScreen.taskKey],
                );
              },
            ),
            GoRoute(
              path: SettingsScreen.path,
              name: SettingsScreen.name,
              builder: (context, state) {
                return const SettingsScreen();
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    /// [Assets]
    _router.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _localeStream,
      initialData: _currentLocale,
      builder: (context, localeSnapshot) {
        return StreamBuilder<ThemeMode>(
          stream: _themeModeStream,
          initialData: _currentThemeMode,
          builder: (context, themeModeSnapshot) {
            return MaterialApp.router(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              themeAnimationStyle: Themes.themeAnimationStyle,
              themeMode: themeModeSnapshot.data,
              debugShowCheckedModeBanner: false,
              color: Themes.primaryColor,
              locale: localeSnapshot.data,
              darkTheme: Themes.darkTheme,
              routerConfig: _router,
              theme: Themes.theme,
            );
          },
        );
      },
    );
  }
}
