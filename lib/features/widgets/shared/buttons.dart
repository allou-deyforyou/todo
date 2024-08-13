import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo/core/assets/_assets.dart';

class CustomFillButton extends StatelessWidget {
  const CustomFillButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.shape = const StadiumBorder(),
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
    this.backgroundColor,
    this.foregroundColor,
    this.tooltip,
  });
  final String? tooltip;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? disabledBackgroundColor;
  final Color? disabledForegroundColor;
  final OutlinedBorder? shape;
  final VoidCallback? onPressed;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final size = MediaQuery.textScalerOf(context).scale(28.0);
    return IconButton.filled(
      iconSize: size,
      tooltip: tooltip,
      onPressed: onPressed,
      constraints: const BoxConstraints.tightFor(
        height: kToolbarHeight,
        width: kToolbarHeight,
      ),
      style: IconButton.styleFrom(
        shape: shape,
        padding: EdgeInsets.zero,
        disabledForegroundColor: disabledForegroundColor,
        disabledBackgroundColor: disabledBackgroundColor,
        foregroundColor: foregroundColor ?? theme.colorScheme.onSurface,
        backgroundColor: backgroundColor ?? theme.colorScheme.surfaceContainer.withOpacity(0.6),
      ),
      icon: child,
    );
  }
}

class CustomFillBackButton extends StatelessWidget {
  const CustomFillBackButton({
    super.key,
    this.onPressed,
  });
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return CustomFillButton(
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      onPressed: onPressed ?? Navigator.of(context).maybePop,
      child: const Icon(CupertinoIcons.arrow_left),
    );
  }
}

class CustomFillCloseButton extends StatelessWidget {
  const CustomFillCloseButton({
    super.key,
    this.onPressed,
  });
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return CustomFillButton(
      tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
      onPressed: onPressed ?? Navigator.of(context).maybePop,
      child: const Icon(CupertinoIcons.xmark),
    );
  }
}

class CustomFillAvatarButton extends StatelessWidget {
  const CustomFillAvatarButton({
    super.key,
    required this.child,
    required this.onPressed,
  });
  final Widget child;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return IconButton(
      constraints: const BoxConstraints.tightFor(
        height: kToolbarHeight,
        width: kToolbarHeight,
      ),
      style: IconButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: const StadiumBorder(),
        foregroundColor: theme.colorScheme.onSurface,
        backgroundColor: theme.colorScheme.surfaceContainer,
        disabledForegroundColor: theme.colorScheme.onSurface,
        disabledBackgroundColor: theme.colorScheme.surfaceContainer,
      ),
      onPressed: onPressed,
      icon: ClipPath(
        clipper: const ShapeBorderClipper(shape: CircleBorder()),
        child: child,
      ),
    );
  }
}

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    super.key,
    this.onPressed,
  });
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final size = MediaQuery.textScalerOf(context).scale(28.0);
    return IconButton(
      iconSize: size,
      color: theme.colorScheme.onSurface,
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      constraints: const BoxConstraints.tightFor(width: kToolbarHeight),
      onPressed: onPressed ?? Navigator.of(context).maybePop,
      icon: const Icon(CupertinoIcons.arrow_left),
    );
  }
}

class CustomCloseButton extends StatelessWidget {
  const CustomCloseButton({
    super.key,
    this.onPressed,
  });
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final size = MediaQuery.textScalerOf(context).scale(28.0);
    return IconButton(
      iconSize: size,
      color: theme.colorScheme.onSurface,
      tooltip: MaterialLocalizations.of(context).closeButtonLabel,
      constraints: const BoxConstraints.tightFor(width: kToolbarHeight),
      onPressed: onPressed ?? Navigator.of(context).maybePop,
      icon: const Icon(CupertinoIcons.xmark),
    );
  }
}
