import 'package:equatable/equatable.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();
  
  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationPreferencesLoaded extends NotificationState {
  final bool lowBalanceAlerts;
  final bool orderStatusAlerts;
  final bool transactionAlerts;
  final bool canteenOpenAlerts;
  final bool affluenceAlerts;
  final bool notificationsEnabled;
  
  const NotificationPreferencesLoaded({
    required this.lowBalanceAlerts,
    required this.orderStatusAlerts,
    required this.transactionAlerts,
    required this.canteenOpenAlerts,
    required this.affluenceAlerts,
    this.notificationsEnabled = true,
  });

  bool get isAnyEnabled => 
    lowBalanceAlerts || orderStatusAlerts || transactionAlerts || 
    canteenOpenAlerts || affluenceAlerts;
  
  NotificationPreferencesLoaded copyWith({
    bool? lowBalanceAlerts,
    bool? orderStatusAlerts,
    bool? transactionAlerts,
    bool? canteenOpenAlerts,
    bool? affluenceAlerts,
    bool? notificationsEnabled,
  }) {
    return NotificationPreferencesLoaded(
      lowBalanceAlerts: lowBalanceAlerts ?? this.lowBalanceAlerts,
      orderStatusAlerts: orderStatusAlerts ?? this.orderStatusAlerts,
      transactionAlerts: transactionAlerts ?? this.transactionAlerts,
      canteenOpenAlerts: canteenOpenAlerts ?? this.canteenOpenAlerts,
      affluenceAlerts: affluenceAlerts ?? this.affluenceAlerts,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
  
  @override
  List<Object?> get props => [
    lowBalanceAlerts,
    orderStatusAlerts,
    transactionAlerts,
    canteenOpenAlerts,
    affluenceAlerts,
    notificationsEnabled,
  ];
}

class NotificationPreferencesUpdated extends NotificationState {
  final String message;
  
  const NotificationPreferencesUpdated(this.message);
  
  @override
  List<Object?> get props => [message];
}

class NotificationError extends NotificationState {
  final String message;
  
  const NotificationError(this.message);
  
  @override
  List<Object?> get props => [message];
}

class TestNotificationSent extends NotificationState {
  final String message;
  
  const TestNotificationSent(this.message);
  
  @override
  List<Object?> get props => [message];
}
