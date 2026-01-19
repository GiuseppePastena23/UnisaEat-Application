// lib/presentation/shared/widget/profile_app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:unisa_eat_2/l10n/app_localizations.dart';
import 'package:unisa_eat_2/presentation/shared/bloc/user_profile_cubit.dart';
import 'package:unisa_eat_2/presentation/shared/bloc/user_profile_state.dart';

class ProfileAppBar extends StatefulWidget implements PreferredSizeWidget {
  const ProfileAppBar({super.key});

  @override
  State<ProfileAppBar> createState() => _ProfileAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ProfileAppBarState extends State<ProfileAppBar> {
  @override
  void initState() {
    super.initState();
    // Refresh user profile when app bar is shown, but throttled
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<UserProfileCubit>().refreshUserIfNeeded();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      automaticallyImplyLeading: false,
      title: BlocBuilder<UserProfileCubit, UserProfileState>(
        builder: (context, state) {
          if (state is! UserProfileSuccess) return const SizedBox.shrink();

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 _buildProfileSection(context, state),
                 _buildBalanceInfo(context, state),
               ],
            ),
          );
        },
      ),
    );
  }

  // Balance
  Widget _buildBalanceInfo(BuildContext context, UserProfileSuccess state) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () {
        context.push('/wallet/add-funds/');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(l10n.balance, style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            fontWeight: FontWeight.w500,
          )),
          const SizedBox(height: 2),
          Row(
            children: [
              Text(
                '€${state.user.saldo?.toStringAsFixed(2) ?? '0.00'}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add,
                  color: Theme.of(context).colorScheme.primary,
                  size: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  

  // Profile section
  Widget _buildProfileSection(BuildContext context, UserProfileSuccess state) {
    return GestureDetector(
      onTap: () {
        context.go('/profile');
      },
      child: Row(
        children: [
           _buildUserAvatar(context, state),
          const SizedBox(width: 12),
           _buildUserInfo(context, state),
        ],
      ),
    );
  }

  // Avatar
  Widget _buildUserAvatar(BuildContext context, UserProfileSuccess state) {
    return CircleAvatar(
      radius: 22,
      backgroundColor: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.8),
      child: Text(
        (state.user.nome?.isNotEmpty ?? false)
            ? state.user.nome![0].toUpperCase()
            : '?',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSecondary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  // Name
  Widget _buildUserInfo(BuildContext context, UserProfileSuccess state) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(state.user.nome ?? 'N/A'),
        SizedBox(width: 4),
        Text(state.user.cognome ?? 'N/A'),
      ],
    );
  }
}
