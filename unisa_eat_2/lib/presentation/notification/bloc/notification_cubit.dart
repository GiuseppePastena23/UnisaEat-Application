import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unisa_eat_2/core/services/notification_service.dart';
import 'package:unisa_eat_2/data/notification/sources/notification_api_service.dart';
import 'package:unisa_eat_2/presentation/notification/bloc/notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationApiService _notificationApiService;
  
  NotificationCubit(this._notificationApiService) : super(NotificationInitial());
  
  Future<void> loadPreferences() async {
    emit(NotificationLoading());
    
    final result = await _notificationApiService.getPreferences();
    
    result.fold(
      (error) => emit(NotificationError(error.toString())),
      (data) {
        if (data is! Map<String, dynamic>) {
          emit(NotificationError('Failed to load preferences: Invalid response'));
          return;
        }
        final prefs = data;
        final lowBalance = prefs['low_balance_alerts'] ?? true;
        final orderStatus = prefs['order_status_alerts'] ?? true;
        final transaction = prefs['transaction_alerts'] ?? true;
        final canteenOpen = prefs['canteen_open_alerts'] ?? false;
        final affluence = prefs['affluence_alerts'] ?? false;
        
        final notificationsEnabled = lowBalance || orderStatus || transaction || canteenOpen || affluence;
        
        emit(NotificationPreferencesLoaded(
          lowBalanceAlerts: lowBalance,
          orderStatusAlerts: orderStatus,
          transactionAlerts: transaction,
          canteenOpenAlerts: canteenOpen,
          affluenceAlerts: affluence,
          notificationsEnabled: notificationsEnabled,
        ));
      },
    );
  }
  
  Future<void> setNotificationsEnabled(bool enabled) async {
    final currentState = state;
    if (currentState is! NotificationPreferencesLoaded) return;

    if (enabled) {
      final hasPermission = await _requestNotificationPermission();
      if (!hasPermission) {
        emit(NotificationError('Notification permission denied'));
        emit(currentState);
        return;
      }
      
      emit(NotificationLoading());
      
      await _notificationApiService.updatePreferences({
        'low_balance_alerts': true,
        'order_status_alerts': true,
        'transaction_alerts': true,
        'canteen_open_alerts': true,
        'affluence_alerts': true,
      });
      
      await registerDevice();
      await loadPreferences();
    } else {
      emit(NotificationLoading());
      
      await _notificationApiService.updatePreferences({
        'low_balance_alerts': false,
        'order_status_alerts': false,
        'transaction_alerts': false,
        'canteen_open_alerts': false,
        'affluence_alerts': false,
      });
      
      await unregisterDevice();
      await loadPreferences();
    }
  }
  
  Future<bool> _requestNotificationPermission() async {
    try {
      final result = await NotificationService.requestPermission();
      return result;
    } catch (e) {
      print('Error requesting permission: $e');
      return false;
    }
  }
  
  Future<void> updatePreferences({
    bool? lowBalanceAlerts,
    bool? orderStatusAlerts,
    bool? transactionAlerts,
    bool? canteenOpenAlerts,
    bool? affluenceAlerts,
  }) async {
    final currentState = state;
    if (currentState is! NotificationPreferencesLoaded) return;
    
    final prefs = <String, dynamic>{};
    
    if (lowBalanceAlerts != null) prefs['low_balance_alerts'] = lowBalanceAlerts;
    if (orderStatusAlerts != null) prefs['order_status_alerts'] = orderStatusAlerts;
    if (transactionAlerts != null) prefs['transaction_alerts'] = transactionAlerts;
    if (canteenOpenAlerts != null) prefs['canteen_open_alerts'] = canteenOpenAlerts;
    if (affluenceAlerts != null) prefs['affluence_alerts'] = affluenceAlerts;
    
    emit(NotificationLoading());
    
    final result = await _notificationApiService.updatePreferences(prefs);
    
    result.fold(
      (error) => emit(NotificationError(error.toString())),
      (data) {
        if (data is! Map<String, dynamic>) {
          emit(NotificationPreferencesUpdated('Preferences updated'));
          loadPreferences();
          return;
        }
        emit(NotificationPreferencesUpdated('Preferences updated successfully'));
        loadPreferences();
      },
    );
  }
  
  Future<void> registerDevice() async {
    try {
      final token = await NotificationService.getDeviceToken();
      if (token != null) {
        await _notificationApiService.registerDevice(token, 'android');
      }
    } catch (e) {
      print('Failed to register device: $e');
    }
  }
  
  Future<void> unregisterDevice() async {
    try {
      final token = await NotificationService.getDeviceToken();
      if (token != null) {
        await _notificationApiService.unregisterDevice(token);
      }
    } catch (e) {
      print('Failed to unregister device: $e');
    }
  }
  
  Future<void> sendTestNotification() async {
    emit(NotificationLoading());
    
    final result = await _notificationApiService.sendTestNotification();
    
    result.fold(
      (error) => emit(NotificationError(error.toString())),
      (data) => emit(TestNotificationSent('Test notification sent!')),
    );
  }
}
