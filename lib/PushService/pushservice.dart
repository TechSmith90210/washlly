// ignore_for_file: unnecessary_null_comparison
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> _handleBackgroundMessage(RemoteMessage message) async {
  if (message != null) {
    print('Title: ${message.notification?.title.toString()}');
    print('Body: ${message.notification?.body.toString()}');
    print('Payload: ${message.data.toString()}');
  }
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Channel',
    description: 'This channel is used for important notifications',
    importance: Importance.defaultImportance,
  );

  // Initialize local_notifications plugin
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initLocalNotifications() async {
    var android = const AndroidInitializationSettings('@drawable/maintenance4');
    var iOS = const DarwinInitializationSettings();
    var settings = InitializationSettings(android: android, iOS: iOS);
    await _flutterLocalNotificationsPlugin.initialize(settings);
    final platform =
        _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  Future<void> initNotifications() async {
    // Requesting Permission
    await _firebaseMessaging.requestPermission();

    // Create the notification channel
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);

    // Get FCM Token
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token: $fCMToken');

    initLocalNotifications();

    // Run callback Function when a background notification is received
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

    // Handle onMessage when the app is in the foreground
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (message != null) {
        print('Title: ${notification?.title.toString()}');
        print('Body: ${notification?.body.toString()}');
        print('Payload: ${message.data.toString()}');

        _flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification?.title,
          notification?.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _androidChannel.id,
              _androidChannel.name,
              channelDescription: _androidChannel.description,
              icon: '@drawable/ic_launcher',
            ),
          ),
          payload: jsonEncode(message.toMap()),
        );
      }
    });
  }
}

void handleMessage(RemoteMessage message) {
  // Handle background message payload here
  print('Handling background message: ${message.data}');
}
