import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unisa_eat_2/core/configs/theme/app_colors.dart';


class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      textTheme: GoogleFonts.workSansTextTheme().copyWith(
      headlineMedium: GoogleFonts.workSans(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      letterSpacing: -1,
      color: AppColors.lightTextBody,
      ),
      
      
      ),
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: ColorScheme.light(
        primary: AppColors.primaryDark,
        onPrimary: Colors.white,
        surface: AppColors.lightBackground,
        onSurface: AppColors.primaryDark,
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
        titleTextStyle: TextStyle(
          color: AppColors.lightTextHeadings,
          fontWeight: FontWeight.bold,
          fontSize: 16, // Reduced for better proportion
        ),
      )
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      textTheme: GoogleFonts.workSansTextTheme().copyWith(
        headlineMedium: GoogleFonts.workSans(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          letterSpacing: -1,
          color: AppColors.darkTextHeadings,
        ),
      ),
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: Colors.black,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkTextHeadings,
        secondary: AppColors.darkSecondaryAccent,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.darkTextBody,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.darkSecondaryAccent,
        iconSize: 32,
        shape: CircleBorder(),
        elevation: 0,
      ),
      appBarTheme: AppBarThemeData(
        backgroundColor: AppColors.darkBackground,
        titleTextStyle: TextStyle(
          color: AppColors.darkTextHeadings,
          fontWeight: FontWeight.bold,
          fontSize: 16, // Reduced from 19
        ),
      ),
    );
  }
}