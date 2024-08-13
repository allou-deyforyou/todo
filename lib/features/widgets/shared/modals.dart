import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:todo/core/assets/_assets.dart';

class BottomSheetWrapper extends StatelessWidget {
  const BottomSheetWrapper({
    super.key,
    required this.child,
  }) : _fullScreen = false;
  const BottomSheetWrapper.fullScreen({
    super.key,
    required this.child,
  }) : _fullScreen = true;
  final Widget child;
  final bool _fullScreen;
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarColor: theme.colorScheme.surface,
        statusBarColor: Colors.transparent,
      ),
      child: Material(
        elevation: 0.0,
        color: theme.colorScheme.surface,
        surfaceTintColor: theme.colorScheme.tertiary,
        shadowColor: theme.colorScheme.surfaceContainerHighest,
        child: Visibility(
          visible: _fullScreen,
          replacement: OrientationBuilder(
            builder: (context, orientation) {
              return switch (orientation) {
                Orientation.landscape => SizedBox(
                    height: 500.0,
                    child: child,
                  ),
                Orientation.portrait => SizedBox(
                    height: 360.0,
                    child: child,
                  ),
              };
            },
          ),
          child: child,
        ),
      ),
    );
  }
}

class CustomCupertinoPicker<T> extends StatefulWidget {
  const CustomCupertinoPicker({
    super.key,
    this.onSelectedItemChanged,
    this.initialItem,
    this.itemFormat,
    this.confirm,
    required this.title,
    required this.items,
  });
  final Widget title;
  final Widget? confirm;
  final List<T> items;
  final T? initialItem;
  final ValueChanged<T?>? onSelectedItemChanged;
  final String Function(BuildContext context, T value)? itemFormat;
  @override
  State<CustomCupertinoPicker<T>> createState() => _CustomCupertinoPickerState<T>();
}

class _CustomCupertinoPickerState<T> extends State<CustomCupertinoPicker<T>> {
  /// Assets
  FixedExtentScrollController? _scrollController;
  late List<T> _items;
  T? _currentValue;

  String _defaultitemFormat(T value) {
    return widget.itemFormat?.call(context, value) ?? value.toString();
  }

  void _onSelectedItemChanged(int index) {
    HapticFeedback.selectionClick();
    _currentValue = _items[index];
    widget.onSelectedItemChanged?.call(_currentValue);
  }

  void _setupitems() {
    _items = widget.items;
    _currentValue = widget.initialItem;
    if (_currentValue != null) {
      final index = _items.indexOf(_currentValue as T);
      _scrollController = FixedExtentScrollController(initialItem: index);
    }
    _currentValue ??= _items.firstOrNull;
  }

  @override
  void initState() {
    super.initState();

    /// Assets
    _setupitems();
  }

  @override
  void didUpdateWidget(covariant CustomCupertinoPicker<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialItem != widget.initialItem || oldWidget.items != widget.items) {
      _setupitems();
    }
  }

  @override
  void dispose() {
    /// Assets
    _scrollController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxHeight.clamp(350.0, 400.0),
          child: Material(
            color: theme.colorScheme.surface,
            child: CustomScrollView(
              shrinkWrap: true,
              controller: PrimaryScrollController.maybeOf(context),
              slivers: [
                SliverAppBar(
                  pinned: true,
                  centerTitle: true,
                  toolbarHeight: 80.0,
                  automaticallyImplyLeading: false,
                  backgroundColor: theme.colorScheme.surface,
                  titleTextStyle: theme.textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.5,
                  ),
                  title: widget.title,
                  actions: [
                    if (widget.confirm != null) widget.confirm!,
                    if (widget.confirm != null) Padding(padding: kTabLabelPadding / 2.0),
                  ],
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: SafeArea(
                    top: false,
                    minimum: const EdgeInsets.only(bottom: 16.0),
                    child: CupertinoPicker.builder(
                      squeeze: 1.25,
                      magnification: 2.35 / 2.1,
                      childCount: _items.length,
                      scrollController: _scrollController,
                      itemExtent: kMinInteractiveDimension,
                      onSelectedItemChanged: _onSelectedItemChanged,
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        return Center(
                          child: DefaultTextStyle(
                            style: theme.textTheme.titleLarge!.copyWith(fontSize: 18.0),
                            child: Text(_defaultitemFormat(item)),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar({
  required BuildContext context,
  required VoidCallback? onTry,
  required String text,
  ScaffoldMessengerState? scaffoldMessenger,
  Color? backgroundColor,
  Color? foregroundColor,
}) {
  scaffoldMessenger ??= ScaffoldMessenger.of(context);
  backgroundColor ??= CupertinoColors.secondarySystemBackground.resolveFrom(context);
  foregroundColor ??= switch (ThemeData.estimateBrightnessForColor(backgroundColor)) {
    Brightness.light => Colors.black,
    Brightness.dark => Colors.white,
  };
  SnackBarAction? action;
  if (onTry != null) {
    action = SnackBarAction(
      label: "Réessayer".capitalize(),
      onPressed: onTry,
    );
  }
  return scaffoldMessenger.showSnackBar(SnackBar(
    elevation: 0.8,
    action: action,
    showCloseIcon: true,
    closeIconColor: foregroundColor,
    backgroundColor: backgroundColor,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24.0),
    ),
    content: DefaultTextStyle.merge(
      style: TextStyle(
        fontWeight: FontWeight.w500,
        color: foregroundColor,
        letterSpacing: 0.0,
        fontSize: 16.0,
      ),
      child: Text(text),
    ),
  ));
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showInfoSnackBar({
  required BuildContext context,
  required String text,
}) {
  return showSnackBar(
    backgroundColor: CupertinoColors.activeBlue.resolveFrom(context),
    context: context,
    onTry: null,
    text: text,
  );
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSuccessSnackBar({
  required BuildContext context,
  required String text,
}) {
  return showSnackBar(
    backgroundColor: CupertinoColors.activeGreen.resolveFrom(context),
    context: context,
    onTry: null,
    text: text,
  );
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showErrorSnackBar({
  required BuildContext context,
  required String text,
}) {
  return showSnackBar(
    backgroundColor: CupertinoColors.destructiveRed.resolveFrom(context),
    context: context,
    onTry: null,
    text: text,
  );
}

Future<DateTime?> showCustomDatePicker({
  CupertinoDatePickerMode mode = CupertinoDatePickerMode.date,
  required BuildContext context,
  DateTime? initialDateTime,
  DateTime? minimumDate,
  DateTime? maximumDate,
  String? label,
}) {
  return showModalBottomSheet<DateTime>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (context) {
      return CustomDatePicker(
        initialDateTime: initialDateTime,
        minimumDate: minimumDate,
        maximumDate: maximumDate,
        label: label,
        mode: mode,
      );
    },
  );
}

class CustomDatePicker extends StatefulWidget {
  const CustomDatePicker({
    super.key,
    required this.initialDateTime,
    required this.mode,
    this.minimumDate,
    this.maximumDate,
    this.label,
  });
  final String? label;
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final DateTime? initialDateTime;
  final CupertinoDatePickerMode mode;

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime? _currentDate;

  @override
  void initState() {
    super.initState();

    _currentDate = widget.initialDateTime ?? DateTime.now();
  }

  @override
  void didUpdateWidget(covariant CustomDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialDateTime != widget.initialDateTime) {
      _currentDate = widget.initialDateTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final localizations = context.localizations;
    return BottomSheetWrapper(
      child: MediaQuery.removeViewPadding(
        removeTop: true,
        context: context,
        child: CustomScrollView(
          shrinkWrap: true,
          controller: PrimaryScrollController.of(context),
          slivers: [
            SliverAppBar(
              pinned: true,
              automaticallyImplyLeading: false,
              backgroundColor: theme.colorScheme.surface,
              titleTextStyle: theme.textTheme.titleLarge,
              title: widget.label != null ? Text(widget.label!) : null,
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: theme.textTheme.titleLarge!.copyWith(fontSize: 18.0),
                  ),
                  onPressed: () => Navigator.pop(context, _currentDate),
                  child: Text(localizations.done.capitalize()),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 300.0,
                child: CupertinoDatePicker(
                  onDateTimeChanged: (value) => _currentDate = value,
                  initialDateTime: widget.initialDateTime ?? widget.maximumDate,
                  maximumDate: widget.maximumDate,
                  minimumDate: widget.minimumDate,
                  use24hFormat: true,
                  mode: widget.mode,
                ),
              ),
            ),
            const SliverSafeArea(
              top: false,
              sliver: SliverToBoxAdapter(),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    super.key,
    this.icon,
    this.title,
    this.content,
    this.actions,
  });
  final Widget? icon;
  final Widget? title;
  final Widget? content;
  final List<Widget>? actions;
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return AlertDialog(
      elevation: 1.0,
      insetPadding: kTabLabelPadding,
      backgroundColor: theme.colorScheme.surface,
      actionsAlignment: MainAxisAlignment.spaceBetween,
      titleTextStyle: theme.textTheme.headlineMedium!.copyWith(
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: theme.textTheme.titleLarge!.copyWith(
        fontSize: 16.0,
      ),
      icon: icon,
      title: SizedBox(
        width: 450.0,
        child: title,
      ),
      content: content,
      actions: actions,
    );
  }
}

class CustomCancelAction extends StatelessWidget {
  const CustomCancelAction({
    super.key,
    this.text,
    this.onPressed,
    this.foregroundColor,
  });
  final String? text;
  final Color? foregroundColor;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final localizations = context.localizations;
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: foregroundColor ?? theme.colorScheme.onSurfaceVariant,
        textStyle: theme.textTheme.titleLarge!.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.0,
          fontSize: 14.0,
        ),
      ),
      onPressed: onPressed ?? Navigator.of(context).pop,
      child: DefaultTextStyle.merge(
        child: Text(text ?? localizations.cancel.toUpperCase()),
      ),
    );
  }
}

class CustomConfirmAction extends StatelessWidget {
  const CustomConfirmAction({
    super.key,
    this.text,
    this.onPressed,
    this.foregroundColor,
  });
  final String? text;
  final Color? foregroundColor;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final localizations = context.localizations;
    return TextButton(
      onPressed: onPressed ?? () => Navigator.pop(context, true),
      style: TextButton.styleFrom(
        foregroundColor: foregroundColor ?? theme.colorScheme.primary,
        textStyle: theme.textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 1.0,
          fontSize: 14.0,
        ),
      ),
      child: Text(text ?? localizations.confirm.toUpperCase()),
    );
  }
}

Future<bool?> showClearTaskModal({
  required BuildContext context,
}) {
  return showCupertinoModalPopup<bool>(
    builder: (context) => const ClearTaskModal(),
    context: context,
  );
}

class ClearTaskModal extends StatelessWidget {
  const ClearTaskModal({super.key});
  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;
    return CustomAlertDialog(
      title: Text(localizations.deletealltasksQuestion.capitalize()),
      content: Text(localizations.deletealltasksMessage.capitalize()),
      actions: [
        CustomCancelAction(
          text: localizations.cancel.toUpperCase(),
        ),
        CustomConfirmAction(
          foregroundColor: CupertinoColors.destructiveRed.resolveFrom(context),
          text: localizations.delete.toUpperCase(),
        ),
      ],
    );
  }
}

Future<bool?> showDeleteTaskModal({
  required BuildContext context,
}) {
  return showCupertinoModalPopup<bool>(
    builder: (context) => const DeleteTaskModal(),
    context: context,
  );
}

class DeleteTaskModal extends StatelessWidget {
  const DeleteTaskModal({super.key});
  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;
    return CustomAlertDialog(
      title: Text(localizations.deletetaskQuestion.capitalize()),
      content: Text(localizations.deletetaskMessage.capitalize()),
      actions: [
        CustomCancelAction(
          text: localizations.cancel.toUpperCase(),
        ),
        CustomConfirmAction(
          foregroundColor: CupertinoColors.destructiveRed.resolveFrom(context),
          text: localizations.delete.toUpperCase(),
        ),
      ],
    );
  }
}

Future<bool?> showExitModal({
  required BuildContext context,
}) {
  return showCupertinoModalPopup<bool>(
    builder: (context) => const ExitModal(),
    context: context,
  );
}

class ExitModal extends StatelessWidget {
  const ExitModal({super.key});
  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;
    return CustomAlertDialog(
      title: Text(localizations.leavePageQuestion.capitalize()),
      content: Text(localizations.leavePageMessage.capitalize()),
      actions: [
        CustomCancelAction(
          text: localizations.stay.toUpperCase(),
        ),
        CustomConfirmAction(
          foregroundColor: CupertinoColors.destructiveRed.resolveFrom(context),
          text: localizations.leave.toUpperCase(),
        ),
      ],
    );
  }
}

Future<bool?> showNotificationWarningModal({
  required BuildContext context,
}) {
  return showCupertinoModalPopup<bool>(
    builder: (context) => const NotificationWarningModal(),
    context: context,
  );
}

class NotificationWarningModal extends StatelessWidget {
  const NotificationWarningModal({super.key});
  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;
    return CustomAlertDialog(
      title: Text(localizations.enablenotification.toUpperCase()),
      content: Text(localizations.enablenotificationmessage.capitalize()),
      actions: [
        const SizedBox.shrink(),
        CustomConfirmAction(text: localizations.ok.toUpperCase()),
      ],
    );
  }
}

Future<bool?> showNotificationPermissionModal({
  required BuildContext context,
}) {
  return showCupertinoModalPopup<bool>(
    builder: (context) => const NotificationPermissionModal(),
    context: context,
  );
}

class NotificationPermissionModal extends StatelessWidget {
  const NotificationPermissionModal({super.key});
  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;
    return CustomAlertDialog(
      title: Text(localizations.enablenotification.toUpperCase()),
      content: Text(localizations.opennotificationmessage.capitalize()),
      actions: [
        const CustomCancelAction(),
        CustomConfirmAction(
          text: localizations.opensettings.toUpperCase(),
        ),
      ],
    );
  }
}
