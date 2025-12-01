// lib/config/router/app_router.dart
import 'package:go_router/go_router.dart';
import 'package:unisa_eat_2/core/services/auth_service.dart';
import 'package:unisa_eat_2/presentation/auth/pages/login.dart';
import 'package:unisa_eat_2/presentation/home/pages/home.dart';
import 'package:unisa_eat_2/presentation/shared/widget/shell_scaffold.dart';
import 'package:unisa_eat_2/presentation/splash.dart';
import 'package:unisa_eat_2/presentation/user/pages/user_profile_page.dart';
import 'package:unisa_eat_2/presentation/wallet/pages/wallet_page.dart';
import 'package:unisa_eat_2/service_locator.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  redirect: (context, state) async {
    
    if (state.uri.toString() == '/splash') return null;
    
    final isValid = await sl<AuthService>().isTokenValid();
    
    
    if (state.uri.toString() == '/login' && isValid) {
      return '/';
    }
    if (!isValid && state.uri.toString() != '/login') {
      return '/login';
    }
    return null; 
  },
  routes: [
    ShellRoute(
      builder: (context, state, child) => ShellScaffold(body: child),
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(path: '/login', builder: (context, state) => LoginPage()),
        GoRoute(path: '/', builder: (context, state) => HomePage(), routes: [
            
          ],
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => UserProfilePage(),
        ),
        GoRoute(
          path: '/wallet',
          builder: (context, state) => WalletPage(),
        ),
      ],
    ),
  ],
);
