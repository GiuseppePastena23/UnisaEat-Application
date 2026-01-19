import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unisa_eat_2/domain/auth/usecases/logout.dart';
import 'package:unisa_eat_2/presentation/shared/bloc/user_profile_cubit.dart';
import 'package:unisa_eat_2/presentation/shared/bloc/user_profile_state.dart';
import 'package:unisa_eat_2/presentation/shared/widget/custom_card.dart';
import 'package:unisa_eat_2/service_locator.dart';


class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  Widget _infoRow(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
          const SizedBox(width: 12),
          Text(
            '$label:',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _logoutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {sl<LogoutUsecase>().call(); context.read<UserProfileCubit>().reset();},
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      child: const Text("Logout"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileCubit, UserProfileState>(
        builder: (context, state) {
          if (state is UserProfileSuccess) {
            final user = state.user;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: CustomCard(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                         Text(
                           '${user.nome} ${user.cognome}',
                           style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                 fontWeight: FontWeight.bold,
                                 color: Theme.of(context).colorScheme.onSurface,
                               ),
                         ),
                         SizedBox(height: 15,),
                        
                         _infoRow(context, Icons.email, 'Email', user.email.toString()),
                         const SizedBox(height: 10),
                         _infoRow(context, Icons.badge, 'Codice Fiscale', user.codiceFiscale.toString()),
                        SizedBox(height: 20,),
                        Center(child: _logoutButton(context))
                      ],
                      
                    ),
                  ),
                ),
              ),
            );
          } else if (state is UserProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserProfileFailure) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 50),
                  const SizedBox(height: 12),
                   Text(
                     "Error Loading User Profile",
                     style: Theme.of(context).textTheme.titleMedium?.copyWith(
                       color: Theme.of(context).colorScheme.onSurface,
                     ),
                   ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                       context.read<UserProfileCubit>().getUser();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                    
                  ),
                ],
              ),
            );
          }
          return Container();
        },
      );
  }
}
