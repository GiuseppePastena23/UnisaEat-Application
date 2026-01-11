import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:unisa_eat_2/core/configs/theme/app_colors.dart';
import 'package:unisa_eat_2/l10n/app_localizations.dart';
import 'package:unisa_eat_2/presentation/wallet/bloc/wallet_cubit.dart';
import 'package:unisa_eat_2/presentation/wallet/bloc/wallet_state.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<WalletCubit>(
        // TIPICO: prendi il repository da context o getIt
        create: (context) => WalletCubit(
          // es: context.read<WalletRepository>(),
        )..getData(), // fai partire il fetch qui
        child: BlocBuilder<WalletCubit, WalletState>(
          builder: (context, state) {
            if (state is WalletSuccess) {
              return _buildBody(context, state);
            } else if (state is WalletFailure) {
              return Center(
                child: Text('Errore: ${state.error}'),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WalletSuccess state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 40),
          _balance(context, state),
          const SizedBox(height: 24),
          _recentTransactions(context, state),
        ],
      ),
    );
  }

  Widget _balance(BuildContext context, WalletSuccess state) {
    final balance = state.balance; // double dal cubit
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.only(top: 25, right: 25, left: 25),
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(
            l10n.current_balance,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '€${balance.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 35,
                height: 35,
                decoration: const BoxDecoration(
                  color: AppColors.balanceIconBackground,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {
                    context.push('/wallet/add-funds/');
                  },
                  icon: const Icon(Icons.add),
                  padding: EdgeInsets.zero,
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _recentTransactions(BuildContext context, WalletSuccess state) {
    final transactions = state.transactions;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(25),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.recent_transactions,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          if (transactions.isEmpty)
            Text(l10n.no_recent_transactions)
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactions.length,
              separatorBuilder: (_, __) => const Divider(height: 16),
              itemBuilder: (context, index) {
                final tx = transactions[index];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tx.typeDisplayName,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          tx.dateFormatted,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                      Text(
                        '${tx.isNegative ? '-' : '+'}€${tx.amount?.toStringAsFixed(2) ?? '0.00'}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: tx.isNegative
                            ? Theme.of(context).colorScheme.error
                            : Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}
