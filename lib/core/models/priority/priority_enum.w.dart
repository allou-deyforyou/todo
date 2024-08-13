part of 'priority_enum.dart';

extension PriorityExtension on Priority {
  Widget titleWidget(BuildContext context) {
    final localizations = context.localizations;
    return switch (this) {
      Priority.high => Text(localizations.high.capitalize()),
      Priority.normal => Text(localizations.normal.capitalize()),
      Priority.low => Text(localizations.low.capitalize()),
    };
  }

  ButtonSegment<Priority> buttonSegment(BuildContext context) {
    return ButtonSegment(
      label: DefaultTextStyle.merge(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 15.0),
        child: titleWidget(context),
      ),
      value: this,
    );
  }

  Color color(BuildContext context) {
    return switch (this) {
      Priority.high => CupertinoColors.destructiveRed.resolveFrom(context),
      Priority.normal => CupertinoColors.activeGreen.resolveFrom(context),
      Priority.low => CupertinoColors.systemGrey2.resolveFrom(context),
    };
  }
}
