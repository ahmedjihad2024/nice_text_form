import 'package:flutter/material.dart';
import 'package:smooth_corner/smooth_corner.dart';

class CustomInkButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Color? backgroundColor;
  final Color? splashColor;
  final Color? highlightColor;
  final double? borderRadius;
  final BorderRadius? customBorderRadius;
  final EdgeInsetsGeometry? padding;
  final double? elevation;
  final Color? shadowColor;
  final double? width;
  final double? height;
  final double? maxWidth;
  final double? maxHeight;
  final bool enabled;
  final Duration? animationDuration;
  final AlignmentGeometry? alignment;
  final BorderSide side;
  final double? smoothness;
  final Gradient? gradient;
  final List<BoxShadow>? boxShadow;
  const CustomInkButton(
      {Key? key,
      required this.child,
      this.onTap,
      this.onLongPress,
      this.backgroundColor,
      this.splashColor,
      this.highlightColor,
      this.borderRadius,
      this.customBorderRadius,
      this.padding,
      this.elevation = 0,
      this.shadowColor,
      this.width,
      this.height,
      this.maxWidth,
      this.maxHeight,
      this.enabled = true,
      this.animationDuration,
      this.alignment,
      this.side = BorderSide.none,
      this.smoothness,
      this.gradient,
      this.boxShadow})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: ShapeDecoration(
        color: backgroundColor ?? (gradient == null ? Colors.transparent : null),
        gradient: gradient,
        shadows: boxShadow,
        shape: SmoothRectangleBorder(
          smoothness: smoothness ?? 1,
          borderRadius: BorderRadius.circular(borderRadius ?? 6),
          side: side,
        ),

      ),
      child: Material(
        color: Colors.transparent,
        elevation: elevation ?? 0,
        shadowColor: shadowColor,
        animationDuration:
            animationDuration ?? const Duration(milliseconds: 200),
        child: InkWell(
          onTap: enabled ? onTap : null,
          onLongPress: enabled ? onLongPress : null,
          splashColor: splashColor,
          highlightColor: highlightColor,
          child: Container(
            constraints: BoxConstraints(
              minWidth: width ?? 0,
              minHeight: height ?? 0,
              maxWidth: maxWidth ?? width ?? double.infinity,
              maxHeight: maxHeight ?? height ?? double.infinity,
            ),
            padding: padding,
            alignment: alignment,
            child: child,
          ),
        ),
      ),
    );
  }
}
