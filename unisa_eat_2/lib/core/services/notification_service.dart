import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  static const _storage = FlutterSecureStorage();
  
  static final StreamController<Map<String, dynamic>> _transactionController = StreamController<Map<String, dynamic>>.broadcast();
  static Stream<Map<String, dynamic>> get onTransactionNotification => _transactionController.stream;
  
  static final StreamController<Map<String, dynamic>> _navigationController = StreamController<Map<String, dynamic>>.broadcast();
  static Stream<Map<String, dynamic>> get onNavigate => _navigationController.stream;
  
  // Test method - call this to simulate a transaction notification
  static void simulateTransactionNotification() {
    print('[NotificationService] Simulating transaction notification');
    _transactionController.add({
      'type': 'transaction',
      'transaction_id': '123',
      'amount': '10.00',
      'transaction_type': 'kiosk',
    });
  }
  
  static const String _deviceTokenKey = 'fcm_device_token';
  
  static Future<void> initialize() async {
    // Initialize Firebase
    await Firebase.initializeApp();
    print('[NotificationService] Firebase initialized');
    
    // Initialize local notifications
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
    print('[NotificationService] Local notifications initialized');
    
    // Request notification permissions
    await _requestPermissions();
    
    // Get and save FCM token
    await _saveDeviceToken();
    
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    print('[NotificationService] Foreground listener registered');
    
    // Handle background messages when app opens
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
    print('[NotificationService] Message opened listener registered');
    
    // Check if app was opened from notification
    await _checkInitialMessage();
  }
  
  static Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      await _firebaseMessaging.requestPermission();
    } else if (Platform.isIOS) {
      await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        sound: true,
      );
    }
  }
  
  static Future<bool> requestPermission() async {
    try {
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        sound: true,
      );
      return settings.authorizationStatus == AuthorizationStatus.authorized ||
             settings.authorizationStatus == AuthorizationStatus.provisional;
    } catch (e) {
      print('Error requesting permission: $e');
      return false;
    }
  }
  
  static Future<void> _saveDeviceToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      if (token != null) {
        await _storage.write(key: _deviceTokenKey, value: token);
        print('FCM Token saved: $token');
      }
    } catch (e) {
      print('Error getting FCM token: $e');
    }
  }
  
  static Future<String?> getDeviceToken() async {
    final token = await _storage.read(key: _deviceTokenKey);
    if (token == null) {
      await _saveDeviceToken();
      return await _storage.read(key: _deviceTokenKey);
    }
    return token;
  }
  
  static Future<void> refreshToken() async {
    await _saveDeviceToken();
  }
  
  static void _handleForegroundMessage(RemoteMessage message) {
    print('Received foreground message: ${message.notification?.title}');
    print('Message data: ${message.data}');
    
    final notification = message.notification;
    final android = message.notification?.android;
    final data = message.data;
    
    // Emit transaction event for wallet refresh
    print('Notification type: ${data['type']}');
    if (data['type'] == 'transaction') {
      print('Emitting transaction event');
      _transactionController.add(Map<String, dynamic>.from(data));
    }
    
    if (notification != null) {
      final androidDetails = AndroidNotificationDetails(
        'unisaeat_notifications',
        'UnisaEat Notifications',
        channelDescription: 'Notifications for UnisaEat app',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      );
      
      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );
      
      final details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );
      
      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        details,
        payload: message.data.toString(),
      );
    }
  }
  
  static void _handleMessageOpenedApp(RemoteMessage message) {
    print('App opened from notification: ${message.notification?.title}');
    final data = Map<String, dynamic>.from(message.data);
    
    // Emit transaction event for wallet refresh
    if (data['type'] == 'transaction') {
      _transactionController.add(data);
    }
    
    if (message.data.isNotEmpty) {
      _handleNotificationData(data);
    }
  }

  static Future<void> _checkInitialMessage() async {
    final message = await _firebaseMessaging.getInitialMessage();
    if (message != null) {
      print('App opened from killed state: ${message.notification?.title}');
      final data = Map<String, dynamic>.from(message.data);
      
      // Emit transaction event for wallet refresh
      if (data['type'] == 'transaction') {
        _transactionController.add(data);
      }
      
      if (message.data.isNotEmpty) {
        _handleNotificationData(data);
      }
    }
  }
  
  static void _onNotificationTapped(NotificationResponse response) {
    print('Notification tapped: ${response.payload}');
    if (response.payload != null) {
      // Parse payload and navigate accordingly
    }
  }
  
  static void _handleNotificationData(Map<String, dynamic> data) {
    final type = data['type'];
    
    switch (type) {
      case 'order_status':
        _navigationController.add({'page': 'orders'});
        break;
      case 'transaction':
        _navigationController.add({'page': 'wallet', 'transaction_id': data['transaction_id']});
        break;
      case 'low_balance':
        _navigationController.add({'page': 'wallet'});
        break;
      case 'canteen_open':
        _navigationController.add({'page': 'menu'});
        break;
      default:
        break;
    }
  }
  
  static Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'unisaeat_local',
      'UnisaEat Local',
      channelDescription: 'Local notifications for UnisaEat',
      importance: Importance.high,
      priority: Priority.high,
    );
    
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      details,
      payload: payload,
    );
  }
}
