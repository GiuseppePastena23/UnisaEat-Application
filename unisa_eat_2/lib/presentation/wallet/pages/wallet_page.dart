import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:unisa_eat_2/domain/wallet/entities/transaction_entity.dart';
import 'package:unisa_eat_2/l10n/app_localizations.dart';
import 'package:unisa_eat_2/presentation/stats/bloc/stats_cubit.dart';
import 'package:unisa_eat_2/presentation/stats/bloc/stats_state.dart';
import 'package:unisa_eat_2/presentation/wallet/bloc/wallet_cubit.dart';
import 'package:unisa_eat_2/presentation/wallet/bloc/wallet_state.dart';
import 'package:unisa_eat_2/presentation/wallet/widgets/transaction_detail_modal.dart';

class WalletPage extends StatefulWidget {
  final bool showReceipt;

  const WalletPage({super.key, this.showReceipt = false});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  TransactionType? selectedType;
  String sortBy = 'dateDesc';
  String groupBy = 'none';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.showReceipt) {
        // Wait a bit for wallet data to load
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _showReceiptForLastTransaction();
          }
        });
      }
    });
  }

  void _showReceiptForLastTransaction() {
    final walletState = context.read<WalletCubit>().state;
    if (walletState is WalletSuccess && walletState.transactions.isNotEmpty) {
      final lastTx = walletState.transactions.first;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Kiosk Purchase'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Amount: €${lastTx.amount?.toStringAsFixed(2) ?? '0.00'}'),
              const SizedBox(height: 8),
              Text('Date: ${lastTx.dateFormatted}'),
              if (lastTx.dishes != null && lastTx.dishes!.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text(
                  'Items:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ...lastTx.dishes!.map(
                  (d) => Text('${d.quantity}x ${d.name} - €${d.price?.toStringAsFixed(2)}'),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: BlocBuilder<WalletCubit, WalletState>(
          builder: (context, state) {
            if (state is WalletSuccess) {
              return _buildTabbedBody(context, state);
            } else if (state is WalletFailure) {
              return Center(child: Text('Errore: ${state.error}'));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.push('/wallet/add-funds'),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildTabbedBody(BuildContext context, WalletSuccess state) {
    final l10n = AppLocalizations.of(context)!;
    return RefreshIndicator(
      onRefresh: () async => context.read<WalletCubit>().getData(),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              dividerColor: Colors.transparent,
              tabs: [
                Tab(text: l10n.wallet),
                Tab(text: l10n.stats),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildWalletTab(context, state),
                _buildStatsTab(context, state),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletTab(BuildContext context, WalletSuccess state) {
    return RefreshIndicator(
      onRefresh: () async => context.read<WalletCubit>().getData(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            _balance(context, state),
            const SizedBox(height: 24),
            _filters(context),
            _recentTransactions(context, state.transactions),
          ],
        ),
      ),
    );
  }

  Widget _balance(BuildContext context, WalletSuccess state) {
    final balance = state.balance;
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
          Text(
            '€${balance.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _filters(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          Expanded(
            child: DropdownButton<TransactionType?>(
              value: selectedType,
              hint: Text('Type'),
              items: [
                DropdownMenuItem(value: null, child: Text('All')),
                ...TransactionType.values.map(
                  (type) => DropdownMenuItem(
                    value: type,
                    child: Text(_getLocalizedTransactionType(context, type)),
                  ),
                ),
              ],
              onChanged: (value) => setState(() => selectedType = value),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButton<String>(
              value: sortBy,
              items: [
                DropdownMenuItem(value: 'dateDesc', child: Text('Date ↓')),
                DropdownMenuItem(value: 'dateAsc', child: Text('Date ↑')),
                DropdownMenuItem(value: 'amountDesc', child: Text('Amount ↓')),
                DropdownMenuItem(value: 'amountAsc', child: Text('Amount ↑')),
              ],
              onChanged: (value) => setState(() => sortBy = value!),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButton<String>(
              value: groupBy,
              items: [
                DropdownMenuItem(value: 'none', child: Text('No Group')),
                DropdownMenuItem(value: 'day', child: Text('By Day')),
                DropdownMenuItem(value: 'week', child: Text('By Week')),
                DropdownMenuItem(value: 'year', child: Text('By Year')),
              ],
              onChanged: (value) => setState(() => groupBy = value!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _recentTransactions(BuildContext context, List<TransactionEntity> transactions) {
    final filtered = _filterAndSort(transactions);
    final l10n = AppLocalizations.of(context)!;

    if (groupBy == 'none') {
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
            if (filtered.isEmpty)
              Text(l10n.no_recent_transactions)
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const Divider(height: 16),
                itemBuilder: (context, index) {
                  final tx = filtered[index];
                  return InkWell(
                    onTap: () => showTransactionDetail(context, tx),
                    child: Row(
                      children: [
                        Icon(
                          _getIconForType(tx.type),
                          color: _getIconColorForType(tx.type, context),
                          size: 28,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getLocalizedTransactionType(context, tx.type),
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                              ),
                              Text(
                                tx.dateFormatted,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurface
                                          .withOpacity(0.6),
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${tx.isNegative ? '-' : '+'}€${tx.amount?.toStringAsFixed(2) ?? '0.00'}',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: tx.type == TransactionType.topup
                                    ? Colors.green
                                    : tx.isNegative
                                        ? Theme.of(context).colorScheme.error
                                        : Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      );
    } else {
      final grouped = _groupTransactions(filtered);
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
            if (grouped.isEmpty)
              Text(l10n.no_recent_transactions)
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: grouped.length,
                itemBuilder: (context, index) {
                  final entry = grouped.entries.elementAt(index);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.key,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: entry.value.length,
                        separatorBuilder: (_, __) => const Divider(height: 8),
                        itemBuilder: (context, idx) {
                          final tx = entry.value[idx];
                          return InkWell(
                            onTap: () => showTransactionDetail(context, tx),
                            child: Row(
                              children: [
                                Icon(
                                  _getIconForType(tx.type),
                                  color: _getIconColorForType(tx.type, context),
                                  size: 28,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _getLocalizedTransactionType(context, tx.type),
                                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context).colorScheme.onSurface,
                                            ),
                                      ),
                                      Text(
                                        tx.dateFormatted,
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                              color: Theme.of(context).colorScheme.onSurface
                                                  .withOpacity(0.6),
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '${tx.isNegative ? '-' : '+'}€${tx.amount?.toStringAsFixed(2) ?? '0.00'}',
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: tx.type == TransactionType.topup
                                            ? Colors.green
                                            : tx.isNegative
                                                ? Theme.of(context).colorScheme.error
                                                : Theme.of(context).colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                },
              ),
          ],
        ),
      );
    }
  }

  String _getLocalizedTransactionType(BuildContext context, TransactionType? type) {
    final l10n = AppLocalizations.of(context)!;
    switch (type) {
      case TransactionType.topup:
        return l10n.transaction_type_topup;
      case TransactionType.kiosk:
        return l10n.transaction_type_kiosk;
      case TransactionType.order:
        return l10n.transaction_type_order;
      default:
        return '';
    }
  }

  IconData _getIconForType(TransactionType? type) {
    switch (type) {
      case TransactionType.topup:
        return Icons.credit_card;
      case TransactionType.kiosk:
        return Icons.restaurant;
      case TransactionType.order:
        return Icons.receipt;
      default:
        return Icons.help;
    }
  }

  Color _getIconColorForType(TransactionType? type, BuildContext context) {
    switch (type) {
      case TransactionType.topup:
        return Colors.green;
      case TransactionType.kiosk:
      case TransactionType.order:
        return Theme.of(context).colorScheme.error;
      default:
        return Theme.of(context).colorScheme.onSurface;
    }
  }

  List<TransactionEntity> _filterAndSort(List<TransactionEntity> transactions) {
    var filtered =
        transactions.where((tx) => selectedType == null || tx.type == selectedType).toList();
    filtered.sort((a, b) {
      switch (sortBy) {
        case 'dateDesc':
          return b.createdAt!.compareTo(a.createdAt!);
        case 'dateAsc':
          return a.createdAt!.compareTo(b.createdAt!);
        case 'amountDesc':
          return (b.amount ?? 0).compareTo(a.amount ?? 0);
        case 'amountAsc':
          return (a.amount ?? 0).compareTo(b.amount ?? 0);
        default:
          return 0;
      }
    });
    return filtered;
  }

  Map<String, List<TransactionEntity>> _groupTransactions(List<TransactionEntity> transactions) {
    Map<String, List<TransactionEntity>> groups = {};
    for (var tx in transactions) {
      String key;
      DateTime date = DateTime.parse(tx.createdAt!);
      if (groupBy == 'day') {
        key = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      } else if (groupBy == 'week') {
        int weekNumber = ((date.day - date.weekday + 10) / 7).floor();
        key = '${date.year}-W$weekNumber';
      } else if (groupBy == 'year') {
        key = date.year.toString();
      } else {
        key = 'All';
      }
      groups.putIfAbsent(key, () => []).add(tx);
    }
    return groups;
  }

  Widget _buildStatsTab(BuildContext context, WalletSuccess state) {
    return BlocProvider(
      create: (context) => StatsCubit(state.transactions),
      child: BlocBuilder<StatsCubit, StatsState>(
        builder: (context, statsState) {
          if (statsState is StatsSuccess) {
            return RefreshIndicator(
              onRefresh: () async => context.read<WalletCubit>().getData(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _summaryCards(context, statsState.data),
                    const SizedBox(height: 24),
                    Text(
                      'Spending Overview (Last 7 Days)',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    _barChart(context, statsState.data.chartPoints),
                  ],
                ),
              ),
            );
          } else if (statsState is StatsFailure) {
            return Center(child: Text('Error: ${statsState.error}'));
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
    double maxValue = 0;
    for (var point in points) {
      maxValue = max(maxValue, point.added);
      maxValue = max(maxValue, point.spent);
    }
    if (maxValue == 0) maxValue = 10; // default

    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          maxY: maxValue,
          minY: -maxValue,
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
                  toY: -point.spent,
                  color: Colors.red,
                  width: 12,
                ),
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 60,
                getTitlesWidget: (value, meta) {
                  if (value == 0) return const Text('€0');
                  return Text(value > 0 ? '+€${value.toInt()}' : '-€${(-value).toInt()}');
                },
              ),
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

