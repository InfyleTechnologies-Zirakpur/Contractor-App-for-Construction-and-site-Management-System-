import 'package:flutter/material.dart';

/// Central place for every color the app uses.
/// Never hardcode a Color(0xFF...) inside a widget — put it here once,
/// reference it everywhere. Makes theming / rebranding a one-file change.
class AppColors {
  AppColors._();

  static const primary = Color(0xFFFF7A00); 
    static const Color dark = Color(0xFF1E2A38); // steel navy
  static const Color border = Colors.black12;

  static const primaryLight = Color(0xFF4C8C4A);
  static const secondary = Color(0xFFFF8F00); 

  static const background = Color(0xFFF5F6F8);
  static const surface = Colors.white;

  static const textPrimary = Color(0xFF1A1C1E);
  static const textSecondary = Color(0xFF5F6368);
  static const divider = Color(0xFFE0E0E0);
    static const Color error = Color(0xFFD32F2F);


  // Attendance status colors — reused across cards, chips, calendars
  static const statusPresent = Color(0xFF2E7D32);
  static const statusAbsent = Color(0xFFD32F2F);
  static const statusRejected = Color(0xFFD32F2F);
  static const statusLate = Color(0xFFF9A825);
  static const statusHalfDay = Color(0xFF1976D2);
  static const statusLeave = Color(0xFF7B1FA2);
  static const statusHoliday = Color(0xFF546E7A);
}
