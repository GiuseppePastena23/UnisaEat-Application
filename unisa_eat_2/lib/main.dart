import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unisa_eat_2/common/helper/router/app_router.dart';
import 'package:unisa_eat_2/core/configs/theme/app_theme.dart';
import 'package:unisa_eat_2/core/services/auth_service.dart';
import 'package:unisa_eat_2/presentation/auth/bloc/login_cubit.dart';

import 'package:unisa_eat_2/presentation/shared/bloc/user_profile_cubit.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => UserProfileCubit()),
      ],
      child: MaterialApp.router(
        themeMode: ThemeMode.dark,
        routerConfig: appRouter,
      ),
    );
  }
}

