import 'package:flutter/material.dart';
import 'package:partyu/utils/app_theme.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Gradient? gradient;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isLoading;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final double? elevation;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.gradient,
    this.backgroundColor,
    this.foregroundColor,
    this.isLoading = false,
    this.padding,
    this.borderRadius,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        gradient: gradient,
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
        boxShadow: elevation != null ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: elevation! * 2,
            offset: Offset(0, elevation! / 2),
          ),
        ] : [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(borderRadius ?? 12),
          child: Container(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : DefaultTextStyle(
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      child: child,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class OutlineButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Color borderColor;
  final Color? backgroundColor;
  final double borderWidth;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;

  const OutlineButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.borderColor = AppTheme.gray200,
    this.backgroundColor,
    this.borderWidth = 1,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.transparent,
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius ?? 12),
          child: Container(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Center(
              child: DefaultTextStyle(
                style: const TextStyle(
                  color: AppTheme.gray700,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}