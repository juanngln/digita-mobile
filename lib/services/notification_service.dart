import 'dart:convert';

import 'package:digita_mobile/services/base_url.dart';
import 'package:digita_mobile/services/secure_storage_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;


@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");

  final FlutterLocalNotificationsPlugin localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings androidSettings =
  AndroidInitializationSettings('@drawable/ic_notification');
  const InitializationSettings settings = InitializationSettings(android: androidSettings);
  await localNotificationsPlugin.initialize(settings);

  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'high_importance_channel',
    'High Importance Notifications',
    channelDescription: 'This channel is for important announcements.',
    importance: Importance.max,
    priority: Priority.high,
  );
  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidDetails,
  );

  final String? title = message.data['title'];
  final String? body = message.data['body'];

  if (title != null && body != null) {
    localNotificationsPlugin.show(
      message.hashCode,
      title,
      body,
      notificationDetails,
      payload: jsonEncode(message.data),
    );
  }
}

class NotificationService {
  // --- Singleton Setup ---
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // --- Class Members ---
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  final SecureStorageService _secureStorage = SecureStorageService();

  // --- Public Navigator Key ---
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<void> initialize() async {
    await Firebase.initializeApp();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings(
      '@drawable/ic_notification',
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _localNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null && response.payload!.isNotEmpty) {
          _handleNavigation(jsonDecode(response.payload!));
        }
      },
    );

    _handleForegroundMessages();
    _handleNotificationTapped();
  }

  void _handleForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Check for title and body in the data payload
      if (message.data['title'] != null && message.data['body'] != null) {
        print('Foreground message received: ${message.data['title']}');
        _showLocalNotification(message); // Pass the message to be displayed
      }
    });
  }

  void _showLocalNotification(RemoteMessage message) {
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is for important announcements.',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    _localNotificationsPlugin.show(
      message.hashCode,
      message.data['title'],      // Read title from data
      message.data['body'],       // Read body from data
      notificationDetails,
      payload: jsonEncode(message.data),
    );
  }

  void _handleNotificationTapped() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Notification tapped!');
      }
      _handleNavigation(message.data);
    });
  }

  /// Centralized navigation logic based on notification data.
  void _handleNavigation(Map<String, dynamic> data) {
    final announcementId = data['announcement_id'];
    if (announcementId != null) {
      if (kDebugMode) {
        print("Navigating to announcement detail for ID: $announcementId");
      }
      // Example navigation:
      // navigatorKey.currentState?.pushNamed('/announcement_detail', arguments: announcementId);
    }
  }

  Future<void> registerDevice() async {
    final String? fcmToken = await _firebaseMessaging.getToken();
    if (fcmToken == null) {
      if (kDebugMode) {
        print("Could not get FCM token.");
      }
      return;
    }
    if (kDebugMode) {
      print("Obtained FCM Token: $fcmToken");
    }

    final String? authToken = await _secureStorage.getAccessToken();
    if (authToken == null) {
      if (kDebugMode) {
        print("Auth token not found. Cannot register FCM token with backend.");
      }
      return;
    }

    final url = Uri.parse(
      '${AppConfig.baseUrl}/api/v1/core/register-fcm-device/',
    );
    if (kDebugMode) {
      print("Registering FCM token at: $url");
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({'fcm_token': fcmToken}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (kDebugMode) {
          print("FCM token successfully registered with the backend.");
        }
      } else {
        if (kDebugMode) {
          print(
            "Failed to register FCM token. Status: ${response.statusCode}, Body: ${response.body}",
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("An error occurred while sending FCM token to server: $e");
      }
    }
  }
}