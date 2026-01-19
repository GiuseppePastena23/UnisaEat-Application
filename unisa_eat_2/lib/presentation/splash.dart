// In presentation/splash.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unisa_eat_2/core/configs/assets/images.dart';
import 'package:unisa_eat_2/core/services/auth_service.dart';
import 'package:unisa_eat_2/service_locator.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _checking = true;

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), _checkAuth);
  }

  Future<void> _checkAuth() async {
    final authService = sl<AuthService>();
    final isAuthenticated = await authService.isTokenValid();

    if (isAuthenticated) {
      final prefs = await SharedPreferences.getInstance();
      final biometricEnabled = prefs.getBool('biometric_enabled') ?? false;

      if (biometricEnabled) {
        final localAuth = LocalAuthentication();
        try {
          final authenticated = await localAuth.authenticate(
            localizedReason: 'Authenticate to access the app',
          );
          if (authenticated) {
            if (mounted) context.go('/home');
          } else {
            if (mounted) context.go('/login');
          }
        } catch (e) {
          if (mounted) context.go('/login');
        }
      } else {
        if (mounted) context.go('/home');
      }
    } else {
      if (mounted) context.go('/login');
    }

    setState(() => _checking = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage(AppImages.splashBg), fit: BoxFit.cover)
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
