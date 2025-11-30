import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unisa_eat_2/core/configs/theme/app_colors.dart';


class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      textTheme: GoogleFonts.workSansTextTheme().copyWith(
      headlineMedium: GoogleFonts.workSans(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: AppColors.lightTextHeadings,
      ),
      ),
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: ColorScheme.light(
        primary: AppColors.primaryLight,
        onPrimary: Colors.white,
        surface: AppColors.lightBackground,
        onSurface: AppColors.lightTextHeadings,
        secondary: AppColors.lightSecondaryAccent,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.lightSurface,
        selectedItemColor: AppColors.primaryDark,
        unselectedItemColor: AppColors.lightTextBody,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.lightSecondaryAccent,
        iconSize: 32,
        shape: CircleBorder(),
        elevation: 0,
      ),
      appBarTheme: AppBarThemeData(
        backgroundColor: AppColors.lightBackground,
        foregroundColor: AppColors.primaryDark,
        
        titleTextStyle: TextStyle(
          color: AppColors.lightTextHeadings,
          fontWeight: FontWeight.w900,
          fontSize: 19
        )
      )
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
    );
  }
}