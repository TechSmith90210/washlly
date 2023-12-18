import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> subscribeToAdminTopic() async {
    await _firebaseMessaging.subscribeToTopic('admin_notifications');
  }

  Future<void> sendBookingNotification(String userName) async {
    // Prepare notification payload
    final Map<String, dynamic> notificationData = {
      'notification': {
        'title': 'New Booking',
        'body': '$userName has booked a new service',
      },
      'data': {
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'status': 'done',
        'message': 'hello',
        'bookingDetails': 'new service call',
      },
      'to': '/topics/admin_notifications', // Specify the target topic
    };

    // Send notification
    await _firebaseMessaging.sendMessage(
      to: '/topics/admin_notifications',
      data: notificationData['data'],
    );
  }
}
