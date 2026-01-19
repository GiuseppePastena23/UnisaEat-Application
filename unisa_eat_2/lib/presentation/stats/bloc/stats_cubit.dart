import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unisa_eat_2/domain/wallet/entities/transaction_entity.dart';
import 'package:unisa_eat_2/presentation/stats/bloc/stats_state.dart';

class StatsCubit extends Cubit<StatsState> {
  final List<TransactionEntity> transactions;

  StatsCubit(this.transactions) : super(StatsInitial()) {
    _calculateStats();
  }

  void _calculateStats() {
    emit(StatsLoading());

    double totalSpent = 0;
    double totalAdded = 0;
    Map<String, Map<String, double>> dailyData = {};

    for (var tx in transactions) {
      if (tx.createdAt != null) {
        DateTime date = DateTime.parse(tx.createdAt!);
        String dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

        dailyData.putIfAbsent(dateKey, () => {'added': 0, 'spent': 0});

        if (tx.isNegative) {
          totalSpent += tx.amount ?? 0;
          dailyData[dateKey]!['spent'] = (dailyData[dateKey]!['spent'] ?? 0) + (tx.amount ?? 0);
        } else {
          totalAdded += tx.amount ?? 0;
          dailyData[dateKey]!['added'] = (dailyData[dateKey]!['added'] ?? 0) + (tx.amount ?? 0);
        }
      }
    }

    List<ChartPoint> chartPoints = dailyData.entries.map((entry) {
      return ChartPoint(
        label: entry.key,
        added: entry.value['added'] ?? 0,
        spent: entry.value['spent'] ?? 0,
      );
    }).toList();

    // Sort by date descending
    chartPoints.sort((a, b) => b.label.compareTo(a.label));

    // Take last 7 days for chart
    chartPoints = chartPoints.take(7).toList().reversed.toList();

    emit(StatsSuccess(StatsData(
      totalSpent: totalSpent,
      totalAdded: totalAdded,
      chartPoints: chartPoints,
    )));
  }
}