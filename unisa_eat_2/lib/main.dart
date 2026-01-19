import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'package:hive_flutter/adapters.dart';

import 'package:unisa_eat_2/common/helper/router/app_router.dart';
import 'package:unisa_eat_2/core/configs/localization/locale_cubit.dart';
import 'package:unisa_eat_2/core/configs/localization/supported_locales.dart';
import 'package:unisa_eat_2/core/configs/theme/app_theme.dart';
import 'package:unisa_eat_2/core/configs/theme/theme_cubit.dart';
import 'package:unisa_eat_2/core/services/time_service.dart';
import 'package:unisa_eat_2/domain/menu/entity/menu_entity.dart';
import 'package:unisa_eat_2/l10n/app_localizations.dart';

import 'package:unisa_eat_2/domain/user/entities/cached_user.dart';
import 'package:unisa_eat_2/domain/user/entities/user_entity.dart';
import 'package:unisa_eat_2/presentation/affluence/bloc/affluence_cubit.dart';
import 'package:unisa_eat_2/presentation/auth/bloc/login_cubit.dart';
import 'package:unisa_eat_2/presentation/menu/bloc/menu_cubit.dart';
import 'package:unisa_eat_2/presentation/shared/bloc/order_cubit.dart';
import 'package:unisa_eat_2/presentation/shared/bloc/user_profile_cubit.dart';
import 'package:unisa_eat_2/presentation/wallet/bloc/wallet_cubit.dart';
import 'package:unisa_eat_2/service_locator.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Stripe
  Stripe.publishableKey = 'pk_test_51SqyOaFF147g0YUUwekPr11IDg5P0BuLmL5iXZXNiW4puu1JyeZNaSs10EgxwVwVr5D944ddspK7P2jymfC5AtC400PSiE6pZX'; // Replace with actual test key
  await Stripe.instance.applySettings();

  await Hive.initFlutter();
  Hive.registerAdapter(CachedUserAdapter());
  Hive.registerAdapter(UserEntityAdapter());
   await Hive.openBox<CachedUser>('user');
   await Hive.openBox<MenuEntity>('menu');
   setupServiceLocator();

   // Sync server time
   await sl<TimeService>().syncServerTime();

   runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LocaleCubit()),
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => UserProfileCubit()),
        BlocProvider(create: (context) => WalletCubit()..getData()),
        BlocProvider(create: (context) => OrderCubit()),
        BlocProvider(create: (context) => MenuCubit()),
        BlocProvider(create: (context) => AffluenceCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return BlocBuilder<LocaleCubit, Locale>(
            builder: (context, locale) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeMode,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: SupportedLocales.all,
                locale: locale,
                routerConfig: appRouter,
              );
            },
          );
        },
      ),
    );
  }
}

