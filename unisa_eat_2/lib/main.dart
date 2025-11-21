import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unisa_eat_2/core/configs/theme/app_theme.dart';
import 'package:unisa_eat_2/presentation/auth/bloc/login_cubit.dart';
import 'package:unisa_eat_2/presentation/auth/pages/login.dart';
import 'package:unisa_eat_2/service_locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // SEARCH
  setupServiceLocator();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeMode themeMode = ThemeMode.light; 

    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: BlocProvider(create: (context) => LoginCubit(),
      child: LoginPage()),
    );
  }
}
