// lib/config/router/app_router.dart
import 'package:go_router/go_router.dart';
import 'package:unisa_eat_2/presentation/auth/pages/login.dart';
import 'package:unisa_eat_2/presentation/home/pages/home.dart';
import 'package:unisa_eat_2/presentation/shared/widget/shell_scaffold.dart';
import 'package:unisa_eat_2/presentation/user/pages/user_profile_page.dart';


final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    ShellRoute(
      builder: (context, state, child) => ShellScaffold(
        body: child,
      ),
      routes: [
        GoRoute(path: '/login', builder: (context, state) => LoginPage(), ),
        GoRoute(
          path: '/',
          builder: (context, state) => HomePage(),
          routes: [
            
          ],
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => UserProfilePage(),
        ),
       
        
      ],
    ),
  ],
);
