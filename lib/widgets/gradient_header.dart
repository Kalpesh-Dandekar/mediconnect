import 'package:flutter/material.dart';
import '../core/app_gradients.dart';
import '../core/app_spacing.dart';

class GradientHeader extends StatelessWidget {
  final Widget child;
  final double height;

  const GradientHeader({
    super.key,
    required this.child,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(AppSpacing.large),
      decoration: const BoxDecoration(
        gradient: AppGradients.primaryGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: child,
    );
  }
}