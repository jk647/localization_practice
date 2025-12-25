import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryDark = Color(0xFF4F46E5);
  static const Color primaryLight = Color(0xFF818CF8);

  // Secondary Colors
  static const Color secondary = Color(0xFF8B5CF6);
  static const Color secondaryDark = Color(0xFF7C3AED);
  static const Color accent = Color(0xFFEC4899);

  // Background Colors
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);

  // Text Colors
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textLight = Color(0xFF94A3B8);

  // Category Colors
  static const Color categoryElectronics = Color(0xFF3B82F6);
  static const Color categoryFashion = Color(0xFFEC4899);
  static const Color categoryFood = Color(0xFFF59E0B);
  static const Color categoryBooks = Color(0xFF10B981);

  // UI Element Colors
  static const Color cardShadow = Color(0x1A000000);
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFE2E8F0);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
  );

  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFEC4899)],
  );

  // White
  static const Color white = Color(0xFFFFFFFF);
  static const Color whiteOpacity70 = Color(0xB3FFFFFF);
  static const Color whiteOpacity50 = Color(0x80FFFFFF);
}
