import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unisa_eat_2/core/configs/theme/app_colors.dart';
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
        )..getBalance(), // fai partire il fetch qui
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

    return Container(
      padding: const EdgeInsets.only(top: 25, right: 25, left: 25),
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(
            'Current Balance',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '€${balance.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.headlineLarge,
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
                    // es: context.read<WalletCubit>().onAddMoneyPressed();
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
    final transactions = state.transactions; // lista dal cubit

    return Container(
      padding: const EdgeInsets.all(25),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Transactions',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),
          if (transactions.isEmpty)
            const Text('No recent transactions')
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
                    // qui dipende dal tuo model Transaction
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tx.title),
                        Text(
                          tx.dateFormatted,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${tx.isNegative ? '-' : '+'}€${tx.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: tx.isNegative ? Colors.red : Colors.green,
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
