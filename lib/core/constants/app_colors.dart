import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF8B4513); // Marrom barbearia
  static const Color primaryDark = Color(0xFF5D2E0F);
  static const Color primaryLight = Color(0xFFA0522D);
  
  // Secondary Colors
  static const Color secondary = Color(0xFFD4AF37); // Dourado
  static const Color secondaryDark = Color(0xFFB8941F);
  static const Color secondaryLight = Color(0xFFE5C158);
  
  // Neutral Colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color textWhite = Color(0xFFFFFFFF);
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);
  
  // Appointment Status Colors
  static const Color scheduled = Color(0xFF2196F3);
  static const Color confirmed = Color(0xFF4CAF50);
  static const Color completed = Color(0xFF9E9E9E);
  static const Color cancelled = Color(0xFFF44336);
  
  // Subscription Status Colors
  static const Color active = Color(0xFF4CAF50);
  static const Color inactive = Color(0xFF9E9E9E);
  static const Color suspended = Color(0xFFF44336);
  static const Color pending = Color(0xFFFF9800);
  
  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
