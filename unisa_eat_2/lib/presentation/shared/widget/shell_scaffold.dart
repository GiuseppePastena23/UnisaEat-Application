import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:unisa_eat_2/presentation/shared/bloc/user_profile_cubit.dart';
import 'package:unisa_eat_2/presentation/shared/widget/bottom_nav_bar.dart';
import 'package:unisa_eat_2/presentation/shared/widget/profile_app_bar.dart';



class ShellScaffold extends StatelessWidget {
  final Widget body;

  const ShellScaffold({required this.body, super.key});

  

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    final hideNavRoutes = ['/login', '/signup', '/splash'];
    final shouldHideNav = hideNavRoutes.contains(location);

    return BlocProvider(
      create: (context) => UserProfileCubit()..getUser(),
      child: Scaffold(
        appBar: !shouldHideNav ? ProfileAppBar() : null,
        body: body,
        bottomNavigationBar: !shouldHideNav ? BottomNavBar() : null, 
      ),
    );
  }
}
