import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  static const _storage = FlutterSecureStorage();
  
  static const String _deviceTokenKey = 'fcm_device_token';
  
  static Future<void> initialize() async {
    // Initialize Firebase
    await Firebase.initializeApp();
    
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
    
    // Request notification permissions
    await _requestPermissions();
    
    // Get and save FCM token
    await _saveDeviceToken();
    
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    
    // Handle background messages when app opens
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
    
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
    
    final notification = message.notification;
    final android = message.notification?.android;
    
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
    if (message.data.isNotEmpty) {
      _handleNotificationData(Map<String, dynamic>.from(message.data));
    }
  }

  static Future<void> _checkInitialMessage() async {
    final message = await _firebaseMessaging.getInitialMessage();
    if (message != null) {
      print('App opened from killed state: ${message.notification?.title}');
      if (message.data.isNotEmpty) {
        _handleNotificationData(Map<String, dynamic>.from(message.data));
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
        // Navigate to orders page
        break;
      case 'transaction':
        // Navigate to wallet page
        break;
      case 'low_balance':
        // Navigate to wallet page to add funds
        break;
      case 'canteen_open':
        // Navigate to menu page
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
