import 'package:flutter/material.dart';

abstract final class AppColors {
  static const ink = Color(0xFF282B2A);
  static const mutedInk = Color(0xFF707572);
  static const canvas = Color(0xFFFAF9F6);
  static const surface = Color(0xFFFFFFFF);
  static const border = Color(0xFFEAE8E1);
  static const gold = Color(0xFFB88A42);
  static const goldTint = Color(0xFFF7F0E3);
  static const blue = Color(0xFF668091);
  static const blueTint = Color(0xFFEDF2F4);
  static const terracotta = Color(0xFFA85F4D);
  static const terracottaTint = Color(0xFFF6ECE8);
}

abstract final class AppTheme {
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.gold,
      brightness: Brightness.light,
      surface: AppColors.surface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.canvas,
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: AppColors.ink,
          fontSize: 44,
          fontWeight: FontWeight.w700,
          height: 1.12,
          letterSpacing: -1.5,
        ),
        headlineMedium: TextStyle(
          color: AppColors.ink,
          fontSize: 27,
          fontWeight: FontWeight.w700,
          height: 1.2,
          letterSpacing: -0.5,
        ),
        titleLarge: TextStyle(
          color: AppColors.ink,
          fontSize: 21,
          fontWeight: FontWeight.w700,
          height: 1.25,
        ),
        bodyLarge: TextStyle(
          color: AppColors.mutedInk,
          fontSize: 16,
          height: 1.6,
        ),
        bodyMedium: TextStyle(
          color: AppColors.mutedInk,
          fontSize: 14,
          height: 1.5,
        ),
      ),
    );
  }
}
