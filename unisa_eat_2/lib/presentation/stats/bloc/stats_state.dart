import 'package:equatable/equatable.dart';

abstract class StatsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class StatsInitial extends StatsState {}

class StatsLoading extends StatsState {}

class StatsSuccess extends StatsState {
  final StatsData data;

  StatsSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class StatsFailure extends StatsState {
  final String error;

  StatsFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class StatsData extends Equatable {
  final double totalSpent;
  final double totalAdded;
  final List<ChartPoint> chartPoints;

  const StatsData({
    required this.totalSpent,
    required this.totalAdded,
    required this.chartPoints,
  });

  @override
  List<Object?> get props => [totalSpent, totalAdded, chartPoints];
}

class ChartPoint extends Equatable {
  final String label;
  final double added;
  final double spent;

  const ChartPoint({
    required this.label,
    required this.added,
    required this.spent,
  });

  @override
  List<Object?> get props => [label, added, spent];
}