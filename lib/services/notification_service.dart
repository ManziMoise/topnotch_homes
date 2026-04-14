import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uuid/uuid.dart';

import '../models/app_notification.dart';
import '../models/user.dart';

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
      List.unmodifiable(_notifications
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt)));

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  List<AppNotification> getNotificationsForUser(String userId, UserRole role) {
    return _notifications.where((n) {
      // Show if targeted to this user
      if (n.targetUserId == userId) return true;
      // Show if targeted to this role
      if (n.targetRole == role) return true;
      // Show general notifications (no target)
      if (n.targetUserId == null && n.targetRole == null) return true;
      return false;
    }).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  int unreadCountForUser(String userId, UserRole role) {
    return getNotificationsForUser(userId, role)
        .where((n) => !n.isRead)
        .length;
  }

  Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    try {
      await _localNotifications.initialize(initSettings);
    } catch (_) {
      // Local notifications may not work on web
    }
    _initialized = true;

    _notifications.addAll([
      AppNotification(
        id: 'n1',
        title: 'Welcome to Topnotch Homes!',
        body:
            'Find the perfect stay across Rwanda. Browse verified properties and book instantly.',
        type: NotificationType.general,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      AppNotification(
        id: 'n2',
        title: 'Featured: Lake Kivu Luxury Villa',
        body:
            'New luxury listing in Karongi! Lakefront villa with private pool starting at \$180/night.',
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
    String? targetUserId,
  }) async {
    final notification = AppNotification(
      id: _uuid.v4().substring(0, 8),
      title: 'Booking Confirmed!',
      body:
          'Your stay at $propertyTitle from $checkIn to $checkOut has been confirmed. Booking #$bookingId',
      type: NotificationType.bookingConfirmed,
      createdAt: DateTime.now(),
      bookingId: bookingId,
      targetUserId: targetUserId,
    );
    _notifications.add(notification);
    notifyListeners();
    await _showLocalNotification(notification);
  }

  Future<void> sendBookingPending({
    required String bookingId,
    required String propertyTitle,
    String? targetUserId,
  }) async {
    final notification = AppNotification(
      id: _uuid.v4().substring(0, 8),
      title: 'Booking Pending',
      body:
          'Your booking at $propertyTitle is pending confirmation. We\'ll notify you once it\'s confirmed.',
      type: NotificationType.bookingPending,
      createdAt: DateTime.now(),
      bookingId: bookingId,
      targetUserId: targetUserId,
    );
    _notifications.add(notification);
    notifyListeners();
    await _showLocalNotification(notification);
  }

  Future<void> sendBookingRequestToHost({
    required String bookingId,
    required String propertyTitle,
    required String guestName,
    String? hostUserId,
  }) async {
    final notification = AppNotification(
      id: _uuid.v4().substring(0, 8),
      title: 'New Booking Request',
      body:
          '$guestName has requested to book $propertyTitle. Booking #$bookingId',
      type: NotificationType.bookingRequest,
      createdAt: DateTime.now(),
      bookingId: bookingId,
      targetUserId: hostUserId,
      targetRole: UserRole.host,
    );
    _notifications.add(notification);
    notifyListeners();
    await _showLocalNotification(notification);
  }

  Future<void> sendBookingCancelledNotification({
    required String bookingId,
    required String propertyTitle,
    required String cancelledBy,
    String? guestUserId,
    String? hostUserId,
  }) async {
    // Notify the guest
    if (guestUserId != null) {
      final guestNotif = AppNotification(
        id: _uuid.v4().substring(0, 8),
        title: 'Booking Cancelled',
        body:
            'Your booking at $propertyTitle (#$bookingId) has been cancelled.',
        type: NotificationType.bookingCancelled,
        createdAt: DateTime.now(),
        bookingId: bookingId,
        targetUserId: guestUserId,
      );
      _notifications.add(guestNotif);
    }

    // Notify the host
    if (hostUserId != null) {
      final hostNotif = AppNotification(
        id: _uuid.v4().substring(0, 8),
        title: 'Booking Cancelled by Guest',
        body:
            '$cancelledBy cancelled their booking at $propertyTitle (#$bookingId).',
        type: NotificationType.bookingCancelledByGuest,
        createdAt: DateTime.now(),
        bookingId: bookingId,
        targetUserId: hostUserId,
      );
      _notifications.add(hostNotif);
    }

    notifyListeners();
  }

  Future<void> sendPaymentReceived({
    required String bookingId,
    required double amount,
    required String method,
    String? targetUserId,
  }) async {
    final notification = AppNotification(
      id: _uuid.v4().substring(0, 8),
      title: 'Payment Received',
      body:
          'Your payment of \$${amount.toStringAsFixed(2)} via $method has been received for booking #$bookingId.',
      type: NotificationType.paymentReceived,
      createdAt: DateTime.now(),
      bookingId: bookingId,
      targetUserId: targetUserId,
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
