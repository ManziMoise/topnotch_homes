import 'package:uuid/uuid.dart';

import '../models/payment.dart';

class PaymentService {
  static final List<Payment> _payments = [];
  static const _uuid = Uuid();

  /// Simulates processing a mobile money payment
  Future<Payment> processPayment({
    required String bookingId,
    required double amount,
    required PaymentMethod method,
    String? phoneNumber,
    String? last4Digits,
  }) async {
    // Create pending payment
    final payment = Payment(
      id: 'PAY-${_uuid.v4().substring(0, 8).toUpperCase()}',
      bookingId: bookingId,
      amount: amount,
      method: method,
      status: PaymentStatus.processing,
      phoneNumber: phoneNumber,
      last4Digits: last4Digits,
      createdAt: DateTime.now(),
    );

    // Simulate payment processing delay
    await Future.delayed(const Duration(seconds: 3));

    // Simulate success (in production, integrate with MTN MoMo API, Airtel Money API, or Stripe)
    final completedPayment = Payment(
      id: payment.id,
      bookingId: payment.bookingId,
      amount: payment.amount,
      method: payment.method,
      status: PaymentStatus.completed,
      phoneNumber: payment.phoneNumber,
      last4Digits: payment.last4Digits,
      createdAt: payment.createdAt,
    );

    _payments.add(completedPayment);
    return completedPayment;
  }

  Payment? getPaymentForBooking(String bookingId) {
    try {
      return _payments.firstWhere((p) => p.bookingId == bookingId);
    } catch (_) {
      return null;
    }
  }
}
