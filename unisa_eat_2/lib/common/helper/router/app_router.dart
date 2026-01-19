// lib/config/router/app_router.dart
import 'package:go_router/go_router.dart';
import 'package:unisa_eat_2/core/services/auth_service.dart';
import 'package:unisa_eat_2/presentation/auth/pages/login.dart';
import 'package:unisa_eat_2/presentation/auth/pages/signup_page.dart';
import 'package:unisa_eat_2/presentation/home/pages/home.dart';
import 'package:unisa_eat_2/presentation/menu/pages/menu.dart';
import 'package:unisa_eat_2/presentation/order/pages/order_creation_screen.dart';
import 'package:unisa_eat_2/presentation/order/pages/order_page.dart';
import 'package:unisa_eat_2/presentation/settings/pages/settings.dart';
import 'package:unisa_eat_2/presentation/shared/widget/shell_scaffold.dart';
import 'package:unisa_eat_2/presentation/splash.dart';
import 'package:unisa_eat_2/presentation/wallet/pages/add_funds_page.dart';
import 'package:unisa_eat_2/presentation/wallet/pages/wallet_page.dart';
import 'package:unisa_eat_2/service_locator.dart';

final appRouter = GoRouter(
  initialLocation: '/', // Start at root, let redirect logic decide
  redirect: (context, state) async {
    // Skip redirect for splash page
    if (state.matchedLocation == '/') return null;

    final authService = sl<AuthService>();
    final isAuthenticated = await authService.isTokenValid();

    // If user is not authenticated and trying to access protected routes
    final isOnLoginPage = state.matchedLocation == '/login';
    final isOnSignupPage = state.matchedLocation == '/signup';

    if (!isAuthenticated) {
      // Redirect to login if not authenticated and not already on auth pages
      if (!isOnLoginPage && !isOnSignupPage) {
        return '/login';
      }
    } else {
      // Redirect authenticated users away from auth pages to home
      if (isOnLoginPage || isOnSignupPage) {
        return '/home';
      }
    }

    // No redirect needed
    return null;
  },
   routes: [
     GoRoute(
       path: '/',
       builder: (context, state) => const SplashPage(),
     ),
     GoRoute(
       path: '/login',
       builder: (context, state) => const LoginPage(),
     ),
     GoRoute(
       path: '/signup',
       builder: (context, state) => const SignupPage(),
     ),
     GoRoute(
       path: '/wallet/add-funds',
       builder: (context, state) => const AddFundsPage(),
     ),
     ShellRoute(
      builder: (context, state, child) => ShellScaffold(body: child),
       routes: [
         GoRoute(
           path: '/home',
           builder: (context, state) => const HomePage(),
         ),
        GoRoute(
          path: '/menu',
          builder: (context, state) => const MenuPage(),
        ),
         GoRoute(
           path: '/order',
           builder: (context, state) => const OrderPage(),
         ),
         GoRoute(
           path: '/order/create',
           builder: (context, state) => const OrderCreationScreen(),
         ),
        GoRoute(
          path: '/wallet',
          builder: (context, state) => const WalletPage(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsPage(),
        ),
      ],
    ),
  ],
);
