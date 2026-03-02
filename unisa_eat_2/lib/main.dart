import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';

import 'package:hive_flutter/adapters.dart';

import 'package:unisa_eat_2/common/helper/router/app_router.dart';
import 'package:unisa_eat_2/core/configs/localization/locale_cubit.dart';
import 'package:unisa_eat_2/core/configs/localization/supported_locales.dart';
import 'package:unisa_eat_2/core/configs/theme/app_theme.dart';
import 'package:unisa_eat_2/core/configs/theme/theme_cubit.dart';
import 'package:unisa_eat_2/core/services/notification_service.dart';
import 'package:unisa_eat_2/core/services/time_service.dart';
import 'package:unisa_eat_2/domain/menu/entity/menu_entity.dart';
import 'package:unisa_eat_2/l10n/app_localizations.dart';

import 'package:unisa_eat_2/domain/user/entities/cached_user.dart';
import 'package:unisa_eat_2/domain/user/entities/user_entity.dart';
import 'package:unisa_eat_2/presentation/affluence/bloc/affluence_cubit.dart';
import 'package:unisa_eat_2/presentation/auth/bloc/login_cubit.dart';
import 'package:unisa_eat_2/presentation/menu/bloc/menu_cubit.dart';
import 'package:unisa_eat_2/presentation/notification/bloc/notification_cubit.dart';
import 'package:unisa_eat_2/data/notification/sources/notification_api_service.dart';
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

   // Initialize notifications
   await NotificationService.initialize();

   // Sync server time
   await sl<TimeService>().syncServerTime();

   runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with WidgetsBindingObserver {
  StreamSubscription? _notificationSubscription;
  StreamSubscription? _navigationSubscription;
  
  // Store references to cubits for external access
  static WalletCubit? _walletCubit;
  static UserProfileCubit? _userProfileCubit;
  
  static WalletCubit? get walletCubit => _walletCubit;
  static UserProfileCubit? get userProfileCubit => _userProfileCubit;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _listenToTransactionNotifications();
    _listenToNavigation();
  }

  void _listenToTransactionNotifications() {
    _notificationSubscription = NotificationService.onTransactionNotification.listen((data) {
      print('[MainApp] Transaction notification received: $data');
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          print('[MainApp] Calling refresh via static references');
          _walletCubit?.getData();
          _userProfileCubit?.getUser(forceRefresh: true);
        }
      });
    });
  }

  void _listenToNavigation() {
    _navigationSubscription = NotificationService.onNavigate.listen((data) {
      print('[MainApp] Navigation event: $data');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          final page = data['page'];
          if (page == 'wallet') {
            // Navigate to wallet and show receipt
            _walletCubit?.getData();
            _userProfileCubit?.getUser(forceRefresh: true);
            // Navigate to wallet page with transaction data to show receipt
            GoRouter.of(context).go('/wallet', extra: {
              'show_receipt': true,
              'transaction_id': data['transaction_id'],
              'amount': data['amount'],
              'type': data['transaction_type'],
            });
          } else if (page == 'orders') {
            GoRouter.of(context).go('/orders');
          } else if (page == 'menu') {
            GoRouter.of(context).go('/menu');
          }
        }
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _notificationSubscription?.cancel();
    _navigationSubscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh wallet and user profile when app comes to foreground
      // This catches kiosk transactions made while app was in background
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          try {
            final walletCubit = BlocProvider.of<WalletCubit>(context, listen: false);
            final userProfileCubit = BlocProvider.of<UserProfileCubit>(context, listen: false);
            walletCubit.getData();
            userProfileCubit.getUser(forceRefresh: true);
          } catch (e) {
            // Cubits might not be available yet
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LocaleCubit()),
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) {
          _userProfileCubit = UserProfileCubit();
          return _userProfileCubit!;
        }),
        BlocProvider(create: (context) {
          _walletCubit = WalletCubit()..getData();
          return _walletCubit!;
        }),
        BlocProvider(create: (context) => OrderCubit()),
        BlocProvider(create: (context) => MenuCubit()),
        BlocProvider(create: (context) => AffluenceCubit()),
        BlocProvider(create: (context) => NotificationCubit(sl<NotificationApiService>())),
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

