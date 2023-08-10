import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
bool isShowing = false;

enum DialogTransitionType {

  fade,
  slideFromTop,
  slideFromTopFade,
  slideFromBottom,
  slideFromBottomFade,
  slideFromLeft,
  slideFromLeftFade,
  slideFromRight,
  slideFromRightFade,
  scale,
  fadeScale,
  rotate,
  scaleRotate,
  fadeRotate,
  rotate3D,
  size,
  sizeFade,
  none,
}

Future<T?> showAnimatedDialog<T extends Object?>({
  required BuildContext context,
  bool barrierDismissible = false,
  required WidgetBuilder builder,
  animationType = DialogTransitionType.size,
  Curve curve = Curves.linear,
  Duration? duration,
  Alignment alignment = Alignment.center,
  Color? barrierColor,
  Axis? axis = Axis.horizontal,
}) {
  assert(debugCheckHasMaterialLocalizations(context));

  final ThemeData theme = Theme.of(context);

  isShowing = true;
  return showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext buildContext, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      final Widget pageChild = Builder(builder: builder);
      return SafeArea(
        top: false,
        child: Builder(builder: (BuildContext context) {
          return Theme(data: theme, child: pageChild);
        }),
      );
    },
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: barrierColor ?? Colors.black54,
    transitionDuration: duration ?? const Duration(milliseconds: 400),
    transitionBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation, Widget child) {
      switch (animationType) {
        case DialogTransitionType.fade:
          return FadeTransition(opacity: animation, child: child);
        case DialogTransitionType.slideFromRight:
          return SlideTransition(
            transformHitTests: false,
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).chain(CurveTween(curve: curve)).animate(animation),
            child: child,
          );
        case DialogTransitionType.slideFromLeft:
          return SlideTransition(
            transformHitTests: false,
            position: Tween<Offset>(
              begin: const Offset(-1.0, 0.0),
              end: Offset.zero,
            ).chain(CurveTween(curve: curve)).animate(animation),
            child: child,
          );
        case DialogTransitionType.slideFromRightFade:
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).chain(CurveTween(curve: curve)).animate(animation),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        case DialogTransitionType.slideFromLeftFade:
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1.0, 0.0),
              end: Offset.zero,
            ).chain(CurveTween(curve: curve)).animate(animation),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        case DialogTransitionType.slideFromTop:
          return SlideTransition(
            transformHitTests: false,
            position: Tween<Offset>(
              begin: const Offset(0.0, -1.0),
              end: Offset.zero,
            ).chain(CurveTween(curve: curve)).animate(animation),
            child: child,
          );
        case DialogTransitionType.slideFromTopFade:
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, -1.0),
              end: Offset.zero,
            ).chain(CurveTween(curve: curve)).animate(animation),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        case DialogTransitionType.slideFromBottom:
          return SlideTransition(
            transformHitTests: false,
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).chain(CurveTween(curve: curve)).animate(animation),
            child: child,
          );
        case DialogTransitionType.slideFromBottomFade:
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).chain(CurveTween(curve: curve)).animate(animation),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        case DialogTransitionType.scale:
          return ScaleTransition(
            alignment: alignment,
            scale: CurvedAnimation(
              parent: animation,
              curve: Interval(
                0.00,
                0.50,
                curve: curve,
              ),
            ),
            child: child,
          );
        case DialogTransitionType.fadeScale:
          return ScaleTransition(
            alignment: alignment,
            scale: CurvedAnimation(
              parent: animation,
              curve: Interval(
                0.00,
                0.50,
                curve: curve,
              ),
            ),
            child: FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: curve,
              ),
              child: child,
            ),
          );
        case DialogTransitionType.scaleRotate:
          return ScaleTransition(
            alignment: alignment,
            scale: CurvedAnimation(
              parent: animation,
              curve: Interval(
                0.00,
                0.50,
                curve: curve,
              ),
            ),
            child: CustomRotationTransition(
              alignment: alignment,
              turns: Tween<double>(begin: 1, end: 2).animate(CurvedAnimation(
                  parent: animation, curve: Interval(0.0, 1.0, curve: curve))),
              child: child,
            ),
          );
        case DialogTransitionType.rotate:
          return CustomRotationTransition(
            alignment: alignment,
            turns: Tween<double>(begin: 1, end: 2).animate(CurvedAnimation(
                parent: animation, curve: Interval(0.0, 1.0, curve: curve))),
            child: child,
          );
        case DialogTransitionType.fadeRotate:
          return CustomRotationTransition(
            alignment: alignment,
            turns: Tween<double>(begin: 1, end: 2).animate(CurvedAnimation(
                parent: animation, curve: Interval(0.0, 1.0, curve: curve))),
            child: FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: curve,
              ),
              child: child,
            ),
          );
        case DialogTransitionType.rotate3D:
          return Rotation3DTransition(
            alignment: alignment,
            turns: Tween<double>(begin: math.pi, end: 2.0 * math.pi).animate(
                CurvedAnimation(
                    parent: animation,
                    curve: Interval(0.0, 1.0, curve: curve))),
            child: FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: animation,
                      curve: const Interval(0.5, 1.0, curve: Curves.elasticOut))),
              child: child,
            ),
          );
        case DialogTransitionType.size:
          return Align(
            alignment: alignment,
            child: SizeTransition(
              sizeFactor: CurvedAnimation(
                parent: animation,
                curve: curve,
              ),
              axis: axis ?? Axis.vertical,
              child: child,
            ),
          );
        case DialogTransitionType.sizeFade:
          return Align(
            alignment: alignment,
            child: SizeTransition(
              sizeFactor: CurvedAnimation(
                parent: animation,
                curve: curve,
              ),
              child: FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: curve,
                ),
                child: child,
              ),
            ),
          );
        case DialogTransitionType.none:
          return child;
        default:
          return FadeTransition(opacity: animation, child: child);
      }
    },
  );
}

class CustomDialogWidget extends StatelessWidget {
  const CustomDialogWidget({
    Key? key,
    this.title,
    this.titlePadding,
    this.titleTextStyle,
    this.content,
    this.contentPadding = const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
    this.contentTextStyle,
    this.bottomWidget,
    this.actions,
    this.backgroundColor,
    this.elevation,
    this.semanticLabel,
    this.shape,
    this.minWidth,
  })  : assert(contentPadding != null),
        super(key: key);
  final Widget? title;

  final EdgeInsetsGeometry? titlePadding;

  final TextStyle? titleTextStyle;

  final Widget? content;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? contentTextStyle;
  final List<Widget>? actions;
  final Widget? bottomWidget;
  final Color? backgroundColor;
  final double? elevation;
  final String? semanticLabel;
  final ShapeBorder? shape;

  final double? minWidth;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    final ThemeData theme = Theme.of(context);
    final DialogTheme dialogTheme = DialogTheme.of(context);
    final List<Widget> children = <Widget>[];
    String? label = semanticLabel;

    if (title != null) {
      children.add(Padding(
        padding: titlePadding ??
            EdgeInsets.fromLTRB(24.0, 24.0, 24.0, content == null ? 20.0 : 0.0),
        child: DefaultTextStyle(
          style: (titleTextStyle ??
              dialogTheme.titleTextStyle ??
              theme.textTheme.titleLarge)!,
          child: Semantics(
            namesRoute: true,
            container: true,
            child: title,
          ),
        ),
      ));
    } else {
      switch (defaultTargetPlatform) {
        case TargetPlatform.iOS:
          label = semanticLabel;
          break;
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
          label = semanticLabel ??
              MaterialLocalizations.of(context).alertDialogLabel;
          break;
        case TargetPlatform.linux:
          label = semanticLabel ??
              MaterialLocalizations.of(context).alertDialogLabel;
          break;
        case TargetPlatform.macOS:
          label = semanticLabel;
          break;
        case TargetPlatform.windows:
          label = semanticLabel ??
              MaterialLocalizations.of(context).alertDialogLabel;
          break;
      }
    }

    if (content != null) {
      children.add(
        Flexible(
          child: Padding(
            padding: contentPadding!,
            child: DefaultTextStyle(
              style: (contentTextStyle ??
                  dialogTheme.contentTextStyle ??
                  theme.textTheme.titleMedium)!,
              child: content!,
            ),
          ),
        ),
      );
    }

    if (bottomWidget != null) {
      children.add(bottomWidget!);
    } else if (actions != null) {
      children.add(
        ButtonBarTheme(
          data: ButtonBarTheme.of(context),
          child: ButtonBar(
            children: actions!,
          ),
        ),
      );
    }

    Widget dialogChild = IntrinsicWidth(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );

    if (label != null) {
      dialogChild = Semantics(
        namesRoute: true,
        label: label,
        child: dialogChild,
      );
    }

    dialogChild = CustomDialog(
      backgroundColor: backgroundColor,
      elevation: elevation,
      minWidth: minWidth,
      shape: shape,
      child: dialogChild,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
            statusBarIconBrightness: Brightness.light,
            statusBarColor: Colors.transparent),
        child: dialogChild);
  }
}
class CustomDialog extends StatelessWidget {

  const CustomDialog({
    Key? key,
    this.backgroundColor,
    this.elevation,
    this.insetAnimationDuration = const Duration(milliseconds: 100),
    this.insetAnimationCurve = Curves.decelerate,
    this.minWidth = 280.0,
    this.shape,
    this.child,
  }) : super(key: key);
  final Color? backgroundColor;
  final double? elevation;
  final Duration? insetAnimationDuration;

  final Curve? insetAnimationCurve;

  final double? minWidth;

  final ShapeBorder? shape;

  final Widget? child;

  static const RoundedRectangleBorder _defaultDialogShape =
  RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2.0)));
  static const double _defaultElevation = 24.0;

  @override
  Widget build(BuildContext context) {
    final DialogTheme dialogTheme = DialogTheme.of(context);
    return AnimatedPadding(
      padding: MediaQuery
          .of(context)
          .viewInsets +
          const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
      duration: insetAnimationDuration!,
      curve: insetAnimationCurve!,
      child: MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: minWidth ?? 280.0),
            child: Material(
              color: backgroundColor ??
                  dialogTheme.backgroundColor ??
                  Theme
                      .of(context)
                      .dialogBackgroundColor,
              elevation:
              elevation ?? dialogTheme.elevation ?? _defaultElevation,
              shape: shape ?? dialogTheme.shape ?? _defaultDialogShape,
              type: MaterialType.card,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class Rotation3DTransition extends AnimatedWidget {
  const Rotation3DTransition({
    Key? key,
    required Animation<double> turns,
    this.alignment = Alignment.center,
    this.child,
  }) : super(key: key, listenable: turns);
  Animation<double> get turns => listenable as Animation<double>;
  final Alignment? alignment;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final double turnsValue = turns.value;
    final Matrix4 transform = Matrix4.identity()
      ..setEntry(3, 2, 0.0006)
      ..rotateY(turnsValue);
    return Transform(
      transform: transform,
      alignment: const FractionalOffset(0.5, 0.5),
      child: child,
    );
  }
}

class CustomRotationTransition extends AnimatedWidget {
  const CustomRotationTransition({
    Key? key,
    required Animation<double> turns,
    this.alignment = Alignment.center,
    this.child,
  }) : super(key: key, listenable: turns);

  Animation<double> get turns => listenable as Animation<double>;

  final Alignment? alignment;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final double turnsValue = turns.value;
    final Matrix4 transform = Matrix4.rotationZ(turnsValue * math.pi);
    return Transform(
      transform: transform,
      alignment: alignment,
      child: child,
    );
  }
}
