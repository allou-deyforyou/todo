import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todo/core/assets/_assets.dart';
import 'package:todo/core/models/_models.dart';
import 'package:todo/features/widgets/_widgets.dart';
import 'package:todo/core/services/_services.dart';

part 'home_screen.dart';

class HomeSliverAppBar extends StatelessWidget {
  const HomeSliverAppBar({
    super.key,
    required this.leading,
    required this.trailing,
  });
  final Widget leading;
  final Widget trailing;
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return SliverAppBar.large(
      pinned: true,
      floating: true,
      titleSpacing: 0.0,
      leadingWidth: 80.0,
      toolbarHeight: 80.0,
      automaticallyImplyLeading: false,
      titleTextStyle: theme.textTheme.displaySmall!.copyWith(
        color: theme.colorScheme.onSurface,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.0,
        height: 1.2,
      ),
      leading: Center(child: leading),
      title: const SafeArea(
        top: false,
        bottom: false,
        child: Text("To Do"),
      ),
      actions: [
        trailing,
        Padding(padding: kTabLabelPadding / 2.0),
      ],
    );
  }
}

class HomeMenuButton extends StatelessWidget {
  const HomeMenuButton({
    super.key,
    this.onPressed,
  });
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return CustomFillButton(
      onPressed: onPressed,
      tooltip: MaterialLocalizations.of(context).showMenuTooltip,
      child: const Icon(CupertinoIcons.gear),
    );
  }
}

class HomeAddButton extends StatelessWidget {
  const HomeAddButton({
    super.key,
    this.onPressed,
  });
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final localizations = context.localizations;
    return CustomFillButton(
      onPressed: onPressed,
      foregroundColor: theme.colorScheme.surface,
      backgroundColor: theme.colorScheme.onSurface,
      tooltip: localizations.addtasks.capitalize(),
      child: const Icon(CupertinoIcons.add),
    );
  }
}

class HomeSliverWrapper extends StatelessWidget {
  const HomeSliverWrapper({
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

class HomeDateListView extends StatelessWidget {
  const HomeDateListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
  });
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  @override
  Widget build(BuildContext context) {
    EdgeInsets padding = MediaQuery.paddingOf(context);
    return SizedBox(
      height: kMinInteractiveDimension,
      child: TabBar.secondary(
        isScrollable: true,
        dividerHeight: 0.0,
        tabAlignment: TabAlignment.start,
        indicatorSize: TabBarIndicatorSize.label,
        labelPadding: const EdgeInsets.symmetric(horizontal: 6.0),
        indicator: const UnderlineTabIndicator(borderSide: BorderSide.none),
        padding: EdgeInsets.only(left: 8.0 + padding.left, right: 8.0 + padding.right),
        tabs: List.generate(itemCount, (index) {
          return itemBuilder(context, index);
        }),
      ),
    );
  }
}

class HomeDateChip extends StatelessWidget {
  const HomeDateChip({
    super.key,
    this.selected = false,
    required this.dateTime,
    required this.onSelected,
  });
  final bool selected;
  final DateTime dateTime;
  final ValueChanged<bool>? onSelected;

  VoidCallback? get _onPressed {
    if (onSelected == null) return null;
    return () {
      onSelected!.call(!selected);
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    Color? backgroundColor = theme.colorScheme.surface;
    Color? foregroundColor = theme.colorScheme.onSurfaceVariant;
    if (selected) {
      backgroundColor = theme.colorScheme.primary;
      foregroundColor = theme.colorScheme.onPrimary;
    }
    return OutlinedButton(
      onPressed: _onPressed,
      style: OutlinedButton.styleFrom(
        shape: const StadiumBorder(),
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        side: BorderSide(color: foregroundColor),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
      ),
      child: Text(DateFormat.MMMd().format(dateTime).pascal()),
    );
  }
}

class HomeTaskSliverListView extends StatelessWidget {
  const HomeTaskSliverListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
  });
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  @override
  Widget build(BuildContext context) {
    return SliverSafeArea(
      top: false,
      bottom: false,
      sliver: SliverPadding(
        padding: kTabLabelPadding,
        sliver: SliverList.separated(
          separatorBuilder: (context, index) {
            return const SizedBox(height: 8.0);
          },
          itemBuilder: itemBuilder,
          itemCount: itemCount,
        ),
      ),
    );
  }
}

class HomeTaskCard extends StatelessWidget {
  const HomeTaskCard({
    super.key,
    required this.value,
    required this.title,
    required this.trailing,
    required this.onChanged,
    required this.onPressed,
    required this.color,
  });
  final bool value;
  final Widget title;
  final Widget trailing;
  final VoidCallback? onPressed;
  final ValueChanged<bool?>? onChanged;
  final Color color;
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final foregroundColor = switch (ThemeData.estimateBrightnessForColor(color)) {
      Brightness.dark => Colors.white,
      Brightness.light => Colors.black,
    };
    return ListTile(
      onTap: onPressed,
      minTileHeight: 64.0,
      horizontalTitleGap: 12.0,
      textColor: foregroundColor,
      iconColor: foregroundColor,
      tileColor: color.withOpacity(0.8),
      // theme.colorScheme.surfaceContainer,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
      leadingAndTrailingTextStyle: theme.textTheme.titleLarge!.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
        fontSize: 14.0,
      ),
      titleTextStyle: theme.textTheme.titleLarge!.copyWith(
        color: theme.colorScheme.onSurface,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.0,
        fontSize: 24.0,
        height: 1.2,
      ),
      leading: Transform.scale(
        scale: 1.5,
        child: Checkbox(
          value: value,
          splashRadius: 30.0,
          onChanged: onChanged,
          shape: const CircleBorder(),
          activeColor: CupertinoColors.systemFill.resolveFrom(context),
          side: BorderSide(
            color: theme.colorScheme.outline,
            width: 1.0,
          ),
        ),
      ),
      title: DefaultTextStyle.merge(
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        child: title,
      ),
      trailing: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: trailing,
      ),
    );
  }
}

class HomeTaskEmptyMessage extends StatelessWidget {
  const HomeTaskEmptyMessage({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final localizations = context.localizations;
    return ListTile(
      titleTextStyle: theme.textTheme.titleLarge!.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
      title: Center(
        child: Text(
          localizations.notasks.capitalize(),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class HomeAddTaskButton extends StatelessWidget {
  const HomeAddTaskButton({
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
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 300.0,
        child: FilledButton(
          style: FilledButton.styleFrom(
            foregroundColor: theme.colorScheme.onSurface,
            backgroundColor: theme.colorScheme.surfaceContainer,
            textStyle: theme.textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.0,
              fontSize: 14.0,
              height: 1.0,
            ),
          ),
          onPressed: onPressed,
          child: child ?? Text(localizations.addtasks.toUpperCase()),
        ),
      ),
    );
  }
}
