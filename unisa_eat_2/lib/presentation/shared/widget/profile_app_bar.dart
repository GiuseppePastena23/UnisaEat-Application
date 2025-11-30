// lib/presentation/shared/widgets/profile_app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:unisa_eat_2/core/configs/theme/app_colors.dart';
import 'package:unisa_eat_2/presentation/shared/bloc/user_profile_cubit.dart';
import 'package:unisa_eat_2/presentation/shared/bloc/user_profile_state.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({super.key});

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

                _buildBalanceInfo(state),
              ],
            ),
          );
        },
      ),
    );
  }

  // Saldo
  Widget _buildBalanceInfo(UserProfileSuccess state) {
    return GestureDetector(
      onTap: () {

      },
      child: Container(
        
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
             
            shape: BoxShape.rectangle,
            
            borderRadius: BorderRadius.circular(10),
          ),
        child: Row(
          children: [
            Text(
              '€${state.user.saldo?.toStringAsFixed(2) ?? '0.00'}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.primaryDark,
                letterSpacing: 0.24,
                height: 1.25,
              ),
            ),
            const SizedBox(width: 8),
            Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: AppColors.balanceIconBackground,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.add, color: AppColors.primaryDark, size: 18, fontWeight: FontWeight.w700,),
        
          
            
            
              
          
          ),
          ],
        ),
      ),
    );
  }

  // Piu

  // DESTRA
  Widget _buildProfileSection(BuildContext context, UserProfileSuccess state) {
    return GestureDetector(
      onTap: () {
        context.go('/profile');
      },
      child: Row(
        children: [
          _buildUserAvatar(state),
          const SizedBox(width: 12),
          _buildUserInfo(state),
        ],
      ),
    );
  }

  // Avatar
  Widget _buildUserAvatar(UserProfileSuccess state) {
    return CircleAvatar(
      radius: 22,
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

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
