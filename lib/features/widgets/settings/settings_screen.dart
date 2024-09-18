part of 'settings_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  static const path = 'settings';
  static const name = 'settings';
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  /// [Assets]
  Stream<bool?>? _notificationsStream;
  bool? _currentNotifications;

  Stream<ThemeMode>? _themeModeStream;
  ThemeMode? _currentThemeMode;

  Stream<Locale?>? _localeStream;
  Locale? _currentLocale;

  ValueChanged<bool>? _onTapNotifs() {
    return (value) {
      if (value) {
        Permission.notification.onGrantedCallback(() {
          HiveConfig.notifications = true;
        }).onDeniedCallback(() {
          if (mounted) {
            showNotificationWarningModal(context: context);
          }
        }).onPermanentlyDeniedCallback(() {
          if (mounted) {
            showNotificationPermissionModal(context: context);
          }
        }).request();
      } else {
        NotificationService.cancelNotification();
        HiveConfig.notifications = false;
      }
    };
  }

  VoidCallback? _onTapTheme(ThemeMode mode) {
    return () {
      showThemeModal(
        context: context,
        mode: mode,
      );
    };
  }

  VoidCallback? _onTapLanguage(Locale? locale) {
    return () async {
      showLanguageModal(
        context: context,
        locale: locale,
      );
    };
  }

  void _onClearPressed() async {
    final data = await showClearTaskModal(context: context);
    if (data != null) {
      _loadTask();
    }
  }

  /// [TaskLogic]
  late final TaskIsarBloc _taskIsarBloc;

  void _listenTaskIsarState(BuildContext context, BlocState state) {
    if (state case SuccessState<ClearTaskIsarEvent, bool>()) {
      final localizations = context.localizations;
      showErrorSnackBar(
        text: localizations.alltasksdeleted.capitalize(),
        context: context,
      );
    }
  }

  void _loadTask() {
    _taskIsarBloc.add(const ClearTaskIsarEvent());
  }

  @override
  void initState() {
    super.initState();

    /// [Assets]
    _currentNotifications = HiveConfig.notifications;
    _notificationsStream = HiveConfig.notificationsStream;

    _currentLocale = HiveConfig.locale;
    _localeStream = HiveConfig.localeStream;

    _currentThemeMode = HiveConfig.themeMode;
    _themeModeStream = HiveConfig.themeModeStream;

    /// [TaskLogic]
    _taskIsarBloc = TaskIsarBloc();
  }

  @override
  void dispose() {
    /// [TaskLogic]
    _taskIsarBloc.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SettingsSliverAppBar(),
          SettingsSliverWrapper(
            sliver: SliverMainAxisGroup(
              slivers: [
                const SliverPadding(
                  padding: kMaterialListPadding,
                ),
                SliverToBoxAdapter(
                  child: SettingsItemWrapper(
                    children: [
                      StreamBuilder(
                        stream: _notificationsStream,
                        initialData: _currentNotifications,
                        builder: (context, snapshot) {
                          return SettingsNotifs(
                            value: snapshot.data ?? false,
                            onChanged: _onTapNotifs(),
                          );
                        },
                      ),
                      StreamBuilder(
                        stream: _themeModeStream,
                        initialData: _currentThemeMode,
                        builder: (context, snapshot) {
                          return SettingsTheme(
                            onTap: _onTapTheme(snapshot.data!),
                            value: snapshot.data!.format(context).capitalize(),
                          );
                        },
                      ),
                      StreamBuilder(
                        stream: _localeStream,
                        initialData: _currentLocale,
                        builder: (context, snapshot) {
                          return SettingsLanguage(
                            onTap: _onTapLanguage(snapshot.data),
                            value: snapshot.data!.format(context).capitalize(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SliverPadding(
                  padding: kMaterialListPadding,
                ),
                SliverToBoxAdapter(
                  child: BlocConsumer(
                    bloc: _taskIsarBloc,
                    listener: _listenTaskIsarState,
                    builder: (context, state) {
                      Widget? child;
                      VoidCallback? onPressed = _onClearPressed;
                      if (state is PendingState<DeleteTaskIsarEvent>) {
                        child = const CupertinoActivityIndicator();
                        onPressed = null;
                      }
                      return SettingsClearButton(
                        onPressed: onPressed,
                        child: child,
                      );
                    },
                  ),
                ),
                const SliverSafeArea(
                  top: false,
                  sliver: SliverPadding(
                    padding: kMaterialListPadding,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
