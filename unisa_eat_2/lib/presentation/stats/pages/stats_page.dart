import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:unisa_eat_2/l10n/app_localizations.dart';
import 'package:unisa_eat_2/presentation/stats/bloc/stats_cubit.dart';
import 'package:unisa_eat_2/presentation/stats/bloc/stats_state.dart';
import 'package:unisa_eat_2/presentation/wallet/bloc/wallet_cubit.dart';
import 'package:unisa_eat_2/presentation/wallet/bloc/wallet_state.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletCubit, WalletState>(
      builder: (context, walletState) {
        if (walletState is WalletSuccess) {
          return BlocProvider(
            create: (context) => StatsCubit(walletState.transactions),
            child: _buildBody(context),
          );
        } else if (walletState is WalletFailure) {
          return Center(child: Text('Error: ${walletState.error}'));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildBody(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.stats),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/wallet'),
        ),
      ),
      body: BlocBuilder<StatsCubit, StatsState>(
        builder: (context, state) {
          if (state is StatsSuccess) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _summaryCards(context, state.data),
                  const SizedBox(height: 24),
                  Text(
                    'Spending Overview (Last 7 Days)',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  _barChart(context, state.data.chartPoints),
                ],
              ),
            );
          } else if (state is StatsFailure) {
            return Center(child: Text('Error: ${state.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _summaryCards(BuildContext context, StatsData data) {
    return Row(
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(Icons.trending_down, color: Colors.red, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    'Total Spent',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    '€${data.totalSpent.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(Icons.trending_up, color: Colors.green, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    'Total Added',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    '€${data.totalAdded.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _barChart(BuildContext context, List<ChartPoint> points) {
    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          barGroups: points.asMap().entries.map((entry) {
            int index = entry.key;
            ChartPoint point = entry.value;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: point.added,
                  color: Colors.green,
                  width: 12,
                ),
                BarChartRodData(
                  toY: -point.spent, // Negative for down
                  color: Colors.red,
                  width: 12,
                ),
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (index >= 0 && index < points.length) {
                    return Text(points[index].label);
                  }
                  return const Text('');
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: true),
        ),
      ),
    );
  }
}