import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unisa_eat_2/l10n/app_localizations.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    switch (location) {
      case '/home':
        return 0;
      case '/menu':
        return 1;
      case '/order':
        return 2;
      case '/wallet':
        return 3;
      case '/settings':
        return 4;
      default:
        return 0;
    }
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/menu');
        break;
      case 2:
        context.go('/order');
        break;
      case 3:
        context.go('/wallet');
        break;
      case 4:
        context.go('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _getCurrentIndex(context),
      onTap: (index) => _onTap(context, index),
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Menu'),
        BottomNavigationBarItem(icon: Icon(Icons.receipt), label: AppLocalizations.of(context)!.orders),
        BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: AppLocalizations.of(context)!.wallet),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: AppLocalizations.of(context)!.settings),
      ],
    );
  }
}
