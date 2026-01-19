import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:unisa_eat_2/core/configs/assets/images.dart';
import 'package:unisa_eat_2/l10n/app_localizations.dart';
import 'package:unisa_eat_2/presentation/affluence/bloc/affluence_cubit.dart';
import 'package:unisa_eat_2/presentation/affluence/widgets/affluence_card.dart';
import 'package:unisa_eat_2/presentation/shared/bloc/user_profile_cubit.dart';
import 'package:unisa_eat_2/presentation/shared/bloc/user_profile_state.dart';
import 'package:unisa_eat_2/presentation/shared/widget/tappable_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _debugMode = false;

  @override
  void initState() {
    super.initState();
    _loadDebugMode();
  }

  Future<void> _loadDebugMode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _debugMode = prefs.getBool('debug_mode') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<UserProfileCubit, UserProfileState>(
      builder: (context, state) {
        if (state is UserProfileSuccess) {
          final user = state.user;
          return Container(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  l10n.greeting_morning(user.nome ?? ''),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 10),
                TappableImageCard(assetImagePath: AppImages.todayMenuImage, overlayText: l10n.todays_menu, routePath: '/menu', subtitleText: l10n.tap_to_see_cooking),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    l10n.cafeteria_status,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const AffluenceCard(),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => context.push('/wallet/add-funds'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, size: 32),
                            const SizedBox(height: 8),
                            Text(l10n.add_funds, textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => context.push('/order/create'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add_shopping_cart, size: 32),
                            const SizedBox(height: 8),
                            Text(l10n.create_order, textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (_debugMode) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.read<AffluenceCubit>().fetchAffluence(),
                      child: const Text('Reload Affluence (Debug)'),
                    ),
                  ),
                ],
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}