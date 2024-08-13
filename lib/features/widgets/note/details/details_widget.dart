import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliver_tools/sliver_tools.dart';

import 'package:todo/core/assets/_assets.dart';
import 'package:todo/core/models/_models.dart';
import 'package:todo/features/widgets/_widgets.dart';
import 'package:todo/core/services/_services.dart';

part 'details_screen.dart';

class DetailsTaskSliverAppBar extends StatelessWidget {
  const DetailsTaskSliverAppBar({
    super.key,
    required this.trailing,
  });
  final Widget trailing;
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final localizations = context.localizations;
    return SliverAppBar(
      pinned: true,
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
      title: Text(localizations.taskdetails.capitalize()),
      actions: [
        trailing,
        Padding(padding: kTabLabelPadding / 2.0),
      ],
    );
  }
}

class DetailsTaskSliverWrapper extends StatelessWidget {
  const DetailsTaskSliverWrapper({
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

class DetailsTaskEditButton extends StatelessWidget {
  const DetailsTaskEditButton({
    super.key,
    this.onPressed,
  });
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;
    return CustomFillButton(
      onPressed: onPressed,
      tooltip: localizations.edittask.capitalize(),
      child: const Icon(CupertinoIcons.pen),
    );
  }
}

class DetailsTaskTitleAndDescription extends StatelessWidget {
  const DetailsTaskTitleAndDescription({
    super.key,
    required this.title,
    required this.description,
  });
  final Widget title;
  final Widget? description;
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return ListTile(
      minTileHeight: 16.0,
      minVerticalPadding: 0.0,
      contentPadding: kTabLabelPadding,
      visualDensity: VisualDensity.compact,
      titleTextStyle: theme.textTheme.displaySmall!.copyWith(
        color: theme.colorScheme.onSurface,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.0,
      ),
      subtitleTextStyle: theme.textTheme.titleLarge,
      title: DefaultTextStyle.merge(
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        child: title,
      ),
      subtitle: description != null
          ? DefaultTextStyle.merge(
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              child: description!,
            )
          : null,
    );
  }
}

class DetailsTaskDate extends StatelessWidget {
  const DetailsTaskDate({
    super.key,
    required this.date,
  });
  final Widget date;
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return ListTile(
      minTileHeight: 24.0,
      minVerticalPadding: 0.0,
      titleTextStyle: theme.textTheme.titleLarge!.copyWith(fontSize: 18.0),
      leading: const Icon(CupertinoIcons.calendar_today),
      title: date,
    );
  }
}

class DetailsTaskPriority extends StatelessWidget {
  const DetailsTaskPriority({
    super.key,
    required this.color,
    required this.priority,
  });
  final Color color;
  final Widget priority;
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return ListTile(
      textColor: color,
      iconColor: color,
      minTileHeight: 24.0,
      minVerticalPadding: 0.0,
      titleTextStyle: theme.textTheme.titleLarge!.copyWith(fontSize: 18.0),
      leading: const Icon(CupertinoIcons.tag),
      title: priority,
    );
  }
}

class DetailsTaskDone extends StatelessWidget {
  const DetailsTaskDone({
    super.key,
    required this.done,
  });
  final Widget done;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      minTileHeight: 24.0,
      minVerticalPadding: 0.0,
      title: Align(
        alignment: Alignment.centerLeft,
        child: done,
      ),
    );
  }
}

class DetailsTaskDeleteButton extends StatelessWidget {
  const DetailsTaskDeleteButton({
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
    final color = CupertinoColors.destructiveRed.resolveFrom(context);
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 300.0,
        child: FilledButton(
          style: FilledButton.styleFrom(
            foregroundColor: color,
            backgroundColor: theme.colorScheme.surfaceContainer,
            textStyle: theme.textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.0,
              fontSize: 14.0,
              height: 1.0,
            ),
          ),
          onPressed: onPressed,
          child: child ?? Text(localizations.deletetask.toUpperCase()),
        ),
      ),
    );
  }
}
