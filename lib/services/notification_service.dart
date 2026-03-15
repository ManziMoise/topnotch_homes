import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uuid/uuid.dart';

import '../models/app_notification.dart';

class NotificationService extends ChangeNotifier {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  static const _uuid = Uuid();

  final List<AppNotification> _notifications = [];
  bool _initialized = false;

  List<AppNotification> get notifications =>
      List.unmodifiable(_notifications..sort((a, b) => b.createdAt.compareTo(a.createdAt)));

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    try {
      await _localNotifications.initialize(initSettings);
    } catch (_) {
      // Local notifications may not work on web — that's fine
    }
    _initialized = true;

    // Add some initial notifications for demo
    _notifications.addAll([
      AppNotification(
        id: 'n1',
        title: 'Welcome to Topnotch Homes! 🏠',
        body: 'Find the perfect stay across Rwanda. Browse verified properties and book instantly.',
        type: NotificationType.general,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      AppNotification(
        id: 'n2',
        title: 'Featured: Lake Kivu Luxury Villa',
        body: 'New luxury listing in Karongi! Lakefront villa with private pool starting at \$180/night.',
        type: NotificationType.general,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
    ]);

    notifyListeners();
  }

  Future<void> sendBookingConfirmation({
    required String bookingId,
    required String propertyTitle,
    required String checkIn,
    required String checkOut,
  }) async {
    final notification = AppNotification(
      id: _uuid.v4().substring(0, 8),
      title: 'Booking Confirmed! ✅',
      body: 'Your stay at $propertyTitle from $checkIn to $checkOut has been confirmed. Booking #$bookingId',
      type: NotificationType.bookingConfirmed,
      createdAt: DateTime.now(),
      bookingId: bookingId,
    );
    _notifications.add(notification);
    notifyListeners();

    await _showLocalNotification(notification);
  }

  Future<void> sendBookingPending({
    required String bookingId,
    required String propertyTitle,
  }) async {
    final notification = AppNotification(
      id: _uuid.v4().substring(0, 8),
      title: 'Booking Pending ⏳',
      body: 'Your booking at $propertyTitle is pending confirmation. We\'ll notify you once it\'s confirmed.',
      type: NotificationType.bookingPending,
      createdAt: DateTime.now(),
      bookingId: bookingId,
    );
    _notifications.add(notification);
    notifyListeners();

    await _showLocalNotification(notification);
  }

  Future<void> sendPaymentReceived({
    required String bookingId,
    required double amount,
    required String method,
  }) async {
    final notification = AppNotification(
      id: _uuid.v4().substring(0, 8),
      title: 'Payment Received 💳',
      body: 'Your payment of \$${amount.toStringAsFixed(2)} via $method has been received for booking #$bookingId.',
      type: NotificationType.paymentReceived,
      createdAt: DateTime.now(),
      bookingId: bookingId,
    );
    _notifications.add(notification);
    notifyListeners();

    await _showLocalNotification(notification);
  }

  void markAsRead(String notificationId) {
    final idx = _notifications.indexWhere((n) => n.id == notificationId);
    if (idx != -1) {
      _notifications[idx].isRead = true;
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (final n in _notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }

  void removeNotification(String notificationId) {
    _notifications.removeWhere((n) => n.id == notificationId);
    notifyListeners();
  }

  Future<void> _showLocalNotification(AppNotification notification) async {
    try {
      const androidDetails = AndroidNotificationDetails(
        'topnotch_bookings',
        'Booking Updates',
        channelDescription: 'Notifications for booking status updates',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
      );
      const details = NotificationDetails(android: androidDetails);

      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        details,
      );
    } catch (_) {
      // Silently fail on web/unsupported platforms
    }
  }
}
