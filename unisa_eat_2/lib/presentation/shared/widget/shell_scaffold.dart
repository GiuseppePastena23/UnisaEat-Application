import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:unisa_eat_2/presentation/shared/widget/bottom_nav_bar.dart';
import 'package:unisa_eat_2/presentation/shared/widget/profile_app_bar.dart';
import 'package:unisa_eat_2/presentation/shared/widget/qr_dialog.dart';




class ShellScaffold extends StatelessWidget {
  final Widget body;
  final Widget? floatingActionButton;

  const ShellScaffold({required this.body, this.floatingActionButton, super.key});

  

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    final hideNavRoutes = ['/login', '/signup', '/splash', '/wallet/add-funds'];
    final shouldHideNav = hideNavRoutes.contains(location);

    final showQrButton = !shouldHideNav && location != '/order' && location != '/order/create' && location != '/wallet';
    final isWalletPage = location == '/wallet';

    return PopScope(
      canPop: location != '/',
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && location == '/') {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        appBar: !shouldHideNav ? ProfileAppBar() : null,
        body: body,
        bottomNavigationBar: !shouldHideNav ? BottomNavBar() : null,
        floatingActionButton: showQrButton ? FloatingActionButton(
          onPressed: () {
            if (isWalletPage) {
              context.push('/wallet/add-funds');
            } else {
              showDialog(
                context: context,
                builder: (context) {
                  return Stack(
                    children: [
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                        child: Container(color: Colors.transparent),
                      ),
                      Center(child: const QrCodeDialog()),
                    ],
                  );
                },
              );
            }
          },
          child: Icon(isWalletPage ? Icons.add : Icons.qr_code_scanner),
        ) : null,
      ),
    );
  }
}
