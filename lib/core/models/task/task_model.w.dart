part of 'task_model.dart';

extension TaskExtension on Task {
  Widget titleWidget(BuildContext context) {
    TextStyle? titleStyle;
    if (done) {
      titleStyle = const TextStyle(decoration: TextDecoration.lineThrough);
    }
    return DefaultTextStyle.merge(
      style: titleStyle,
      child: Text(title),
    );
  }

  Widget? descriptionWidget(BuildContext context) {
    if (description == null) return null;
    return Text(description!);
  }

  Widget monthDateWidget(BuildContext context) {
    return Text(deadline.format);
  }

  Widget dateWidget(BuildContext context) {
    return Text(deadline.format.pascal());
  }

  Widget timeWidget(BuildContext context) {
    return Text(TimeOfDay.fromDateTime(deadline).format(context));
  }

  Widget priorityWidget(BuildContext context) {
    return priority.titleWidget(context);
  }

  Widget doneWidget(BuildContext context) {
    final localizations = context.localizations;
    if (done) {
      return CustomTag(
        backgroundColor: CupertinoColors.activeBlue.resolveFrom(context),
        label: DefaultTextStyle.merge(
          style: const TextStyle(color: CupertinoColors.white),
          child: Text(localizations.done.capitalize()),
        ),
      );
    }
    return CustomTag(
      backgroundColor: CupertinoColors.systemFill.resolveFrom(context),
      label: DefaultTextStyle.merge(
        style: TextStyle(color: CupertinoColors.label.resolveFrom(context)),
        child: Text(localizations.todo.capitalize()),
      ),
    );
  }
}
