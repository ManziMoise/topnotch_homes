import '../models/user.dart';

enum NotificationType {
  bookingConfirmed,
  bookingPending,
  bookingCancelled,
  bookingRequest,
  bookingCancelledByGuest,
  paymentReceived,
  reviewReceived,
  general,
}

class AppNotification {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime createdAt;
  bool isRead;
  final String? bookingId;
  final String? targetUserId;
  final UserRole? targetRole;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
    this.isRead = false,
    this.bookingId,
    this.targetUserId,
    this.targetRole,
  });
}
