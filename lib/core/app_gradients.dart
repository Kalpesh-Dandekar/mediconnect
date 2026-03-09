import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppGradients {
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      AppColors.primaryBlue,
      AppColors.royalBlue,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}