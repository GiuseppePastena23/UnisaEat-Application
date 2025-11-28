// lib/presentation/shared/widgets/profile_app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:unisa_eat_2/presentation/shared/bloc/user_profile_cubit.dart';
import 'package:unisa_eat_2/presentation/shared/bloc/user_profile_state.dart';


class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 2,
      shadowColor: Colors.black,
      titleSpacing: 0,
      title: BlocBuilder<UserProfileCubit, UserProfileState>(
        builder: (context, state) {
          if (state is UserProfileSuccess) {
            return _buildBalanceSection(context, state);
          } else if (state is UserProfileLoading) {
            return const SizedBox.shrink();
          } else if (state is UserProfileFailure) {
            return _buildBalanceSectionFallback(context);

          }
          return const SizedBox.shrink();
        },
      ),
      actions: [
        BlocBuilder<UserProfileCubit, UserProfileState>(
          builder: (context, state) {
            if (state is UserProfileSuccess) {
              return Row(
                children: [
                  _buildProfileSection(context, state),
                ],
              );
            } else if (state is UserProfileFailure) {
              return _buildProfileSectionFallback(context);
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  // SINISTRA
  Widget _buildBalanceSection(BuildContext context, UserProfileSuccess state) {
    return GestureDetector(
      onTap: () {
        //AppNavigation.push(context, AddFundsPage());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _buildBalanceIcon(),
            const SizedBox(width: 8),
            _buildBalanceInfo(state),
            const SizedBox(width: 8),
            _buildAddFundsButton(),
          ],
        ),
      ),
    );
  }

  //  Icona Euro
  Widget _buildBalanceIcon() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.euro,
        color: Colors.green.shade700,
        size: 20,
      ),
    );
  }

  // Saldo
  Widget _buildBalanceInfo(UserProfileSuccess state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '€${state.user.saldo?.toStringAsFixed(2) ?? '0.00'}',
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          'Saldo',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  // Piu
  Widget _buildAddFundsButton() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(
        Icons.add,
        color: Colors.blue.shade700,
        size: 18,
      ),
    );
  }

  // DESTRA
  Widget _buildProfileSection(BuildContext context, UserProfileSuccess state) {
    return GestureDetector(
      onTap: () {
        context.go('/profile');
      },
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        child: Row(
          children: [
            _buildUserInfo(state),
            const SizedBox(width: 8),
            _buildUserAvatar(state),
          ],
        ),
      ),
    );
  }

  // Avatar 
  Widget _buildUserAvatar(UserProfileSuccess state) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: Colors.teal.shade200,
      child: Text(
        (state.user.nome?.isNotEmpty ?? false)
            ? state.user.nome![0].toUpperCase()
            : '?',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  // Nome Cognome
  Widget _buildUserInfo(UserProfileSuccess state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          state.user.nome ?? 'N/A',
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          state.user.cognome ?? 'N/A',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  // fallback function _buildBalanceSection
  Widget _buildBalanceSectionFallback(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //AppNavigation.push(context, AddFundsPage());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _buildBalanceIcon(),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '€0.00',
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Saldo',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            _buildAddFundsButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSectionFallback(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Giuseppe',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    
                  ),
                ),
                Text(
                  'Pastena',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.teal.shade200,
              child: const Text(
                '?',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
