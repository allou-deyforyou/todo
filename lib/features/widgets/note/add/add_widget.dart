import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliver_tools/sliver_tools.dart';

import 'package:todo/core/assets/_assets.dart';
import 'package:todo/core/models/_models.dart';
import 'package:todo/features/widgets/_widgets.dart';
import 'package:todo/core/services/_services.dart';

part 'add_screen.dart';

class AddTaskSliverAppBar extends StatelessWidget {
  const AddTaskSliverAppBar({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final localizations = context.localizations;
    return SliverAppBar(
      floating: true,
      titleSpacing: 0.0,
      leadingWidth: 80.0,
      toolbarHeight: 80.0,
      automaticallyImplyLeading: false,
      titleTextStyle: theme.textTheme.headlineSmall!.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
      ),
      leading: const Center(child: CustomFillBackButton()),
      title: Text(localizations.createtasktodo.capitalize()),
    );
  }
}

class AddTaskUpdateSliverAppBar extends StatelessWidget {
  const AddTaskUpdateSliverAppBar({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final localizations = context.localizations;
    return SliverAppBar(
      floating: true,
      titleSpacing: 0.0,
      leadingWidth: 80.0,
      toolbarHeight: 80.0,
      automaticallyImplyLeading: false,
      titleTextStyle: theme.textTheme.headlineSmall!.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
      ),
      leading: const Center(child: CustomFillBackButton()),
      title: Text(localizations.edittask.capitalize()),
    );
  }
}

class AddTaskSliverWrapper extends StatelessWidget {
  const AddTaskSliverWrapper({
    super.key,
    required this.sliver,
  });
  final Widget sliver;
  @override
  Widget build(BuildContext context) {
    return SliverSafeArea(
      top: false,
      bottom: false,
      sliver: SliverCrossAxisConstrained(
        maxCrossAxisExtent: kMaxWidth,
        child: sliver,
      ),
    );
  }
}

class AddTaskPrioritySegmentedButton<T> extends StatelessWidget {
  const AddTaskPrioritySegmentedButton({
    super.key,
    required this.segments,
    required this.selected,
    required this.onChanged,
    required this.selectedBackgroundColor,
  });
  final T selected;
  final ValueChanged<T>? onChanged;
  final List<ButtonSegment<T>> segments;
  final Color selectedBackgroundColor;

  void Function(Set<T>)? _onChanged() {
    if (onChanged == null) return null;
    return (value) => onChanged!(value.first);
  }

  @override
  Widget build(BuildContext context) {
    final selectedForegroundColor = switch (ThemeData.estimateBrightnessForColor(selectedBackgroundColor)) {
      Brightness.dark => Colors.white,
      Brightness.light => Colors.black,
    };
    return ListTile(
      minVerticalPadding: 0.0,
      contentPadding: kTabLabelPadding,
      title: SegmentedButton(
        style: SegmentedButton.styleFrom(
          selectedBackgroundColor: selectedBackgroundColor,
          selectedForegroundColor: selectedForegroundColor,
          padding: EdgeInsets.zero,
        ),
        onSelectionChanged: _onChanged(),
        showSelectedIcon: false,
        selected: {selected},
        segments: segments,
      ),
    );
  }
}

class AddTaskTitleTextField extends StatelessWidget {
  const AddTaskTitleTextField({
    super.key,
    required this.controller,
  });
  final TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final localizations = context.localizations;
    return ListTile(
      minVerticalPadding: 0.0,
      contentPadding: kTabLabelPadding,
      titleTextStyle: theme.textTheme.titleLarge!.copyWith(
        fontWeight: FontWeight.w500,
        letterSpacing: 0.0,
        fontSize: 18.0,
        height: 2.0,
      ),
      title: Text(localizations.title.capitalize()),
      subtitle: TextFormField(
        controller: controller,
        keyboardType: TextInputType.name,
        textCapitalization: TextCapitalization.sentences,
        style: const TextStyle(fontSize: 18.0, letterSpacing: 0.8, height: 1.0),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return localizations.requiredTitle.capitalize();
          }
          if (value.length < 3) {
            return localizations.countTitle.capitalize();
          }
          return null;
        },
        decoration: InputDecoration(
          hintStyle: TextStyle(color: CupertinoColors.tertiaryLabel.resolveFrom(context)),
          hintText: localizations.titleHint.capitalize(),
        ),
      ),
    );
  }
}

class AddTaskDescriptionTextField extends StatelessWidget {
  const AddTaskDescriptionTextField({
    super.key,
    required this.controller,
  });
  final TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final localizations = context.localizations;
    return ListTile(
      minVerticalPadding: 0.0,
      contentPadding: kTabLabelPadding,
      titleTextStyle: theme.textTheme.titleLarge!.copyWith(
        fontWeight: FontWeight.w500,
        letterSpacing: 0.0,
        fontSize: 18.0,
        height: 2.0,
      ),
      title: Text(localizations.description.capitalize()),
      subtitle: TextFormField(
        minLines: 4,
        maxLines: 6,
        controller: controller,
        keyboardType: TextInputType.multiline,
        textCapitalization: TextCapitalization.sentences,
        style: const TextStyle(fontSize: 18.0, letterSpacing: 0.8, height: 1.0),
        decoration: InputDecoration(
          hintStyle: TextStyle(color: CupertinoColors.tertiaryLabel.resolveFrom(context)),
          hintText: localizations.descriptionHint.capitalize(),
        ),
      ),
    );
  }
}

class AddTaskDateTextField extends StatelessWidget {
  const AddTaskDateTextField({
    super.key,
    required this.initialValue,
    required this.onTap,
  });
  final String? initialValue;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final localizations = context.localizations;
    return ListTile(
      minVerticalPadding: 0.0,
      contentPadding: kTabLabelPadding,
      titleTextStyle: theme.textTheme.titleLarge!.copyWith(
        fontWeight: FontWeight.w500,
        letterSpacing: 0.0,
        fontSize: 18.0,
        height: 2.0,
      ),
      title: Text(localizations.date.capitalize()),
      subtitle: TextFormField(
        onTap: onTap,
        readOnly: true,
        initialValue: initialValue,
        keyboardType: TextInputType.multiline,
        style: const TextStyle(fontSize: 18.0, letterSpacing: 0.8, height: 1.0),
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: CupertinoColors.tertiaryLabel.resolveFrom(context)),
          hintText: localizations.dateHint.capitalize(),
          suffixIcon: const Icon(CupertinoIcons.calendar),
        ),
      ),
    );
  }
}

class AddTaskCreateButton extends StatelessWidget {
  const AddTaskCreateButton({
    super.key,
    required this.onPressed,
    this.child,
  });
  final Widget? child;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final localizations = context.localizations;
    return SafeArea(
      top: false,
      minimum: kMaterialListPadding,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 300.0,
          child: FilledButton(
            style: FilledButton.styleFrom(
              foregroundColor: theme.colorScheme.surface,
              backgroundColor: theme.colorScheme.onSurface,
              textStyle: theme.textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.0,
                fontSize: 14.0,
                height: 1.0,
              ),
            ),
            onPressed: onPressed,
            child: child ?? Text(localizations.addtask.toUpperCase()),
          ),
        ),
      ),
    );
  }
}

class AddTaskUpdateButton extends StatelessWidget {
  const AddTaskUpdateButton({
    super.key,
    required this.onPressed,
    this.child,
  });
  final Widget? child;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final localizations = context.localizations;
    return SafeArea(
      top: false,
      minimum: kMaterialListPadding,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 300.0,
          child: FilledButton(
            style: FilledButton.styleFrom(
              foregroundColor: theme.colorScheme.surface,
              backgroundColor: theme.colorScheme.onSurface,
              textStyle: theme.textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.0,
                fontSize: 14.0,
                height: 1.0,
              ),
            ),
            onPressed: onPressed,
            child: child ?? Text(localizations.edittask.toUpperCase()),
          ),
        ),
      ),
    );
  }
}
