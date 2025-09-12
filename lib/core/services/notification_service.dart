// lib/core/services/notification_service.dart

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  // Initialize notifications
  Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _initialized = true;
  }

  // Show notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await initialize();

    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'outbox_studio_channel',
        'Outbox Studio',
        channelDescription: 'Outbox Studio notifications',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        color: Color(0xFFFBAF2A),
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _notifications.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  // Show booking notification
  Future<void> showBookingNotification({
    required String title,
    required String message,
    required String bookingId,
  }) async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: title,
      body: message,
      payload: 'booking:$bookingId',
    );
  }

  // Handle notification tapped
  void _onNotificationTapped(NotificationResponse response) {
    final payload = response.payload;
    if (payload != null) {
      debugPrint('Notification tapped with payload: $payload');
    }
  }

  // Send booking status update notification
  Future<void> notifyBookingStatusUpdate({
    required String status,
    required String packageName,
  }) async {
    String title;
    String message;

    switch (status) {
      case 'confirmed':
        title = 'Booking Confirmed! 🎉';
        message = 'Your $packageName session has been confirmed';
        break;
      case 'cancelled':
        title = 'Booking Cancelled';
        message = 'Your $packageName session has been cancelled';
        break;
      case 'completed':
        title = 'Session Completed! ✨';
        message = 'Thanks for choosing Outbox Studio!';
        break;
      default:
        title = 'Booking Update';
        message = 'Your $packageName session status has been updated';
    }

    await showBookingNotification(
      title: title,
      message: message,
      bookingId: '',
    );
  }
}
