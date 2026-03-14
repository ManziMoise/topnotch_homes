enum PaymentMethod { mtnMomo, airtelMoney, card }

enum PaymentStatus { pending, processing, completed, failed }

class Payment {
  final String id;
  final String bookingId;
  final double amount;
  final PaymentMethod method;
  final PaymentStatus status;
  final String? phoneNumber; // for mobile money
  final String? last4Digits; // for card
  final DateTime createdAt;

  const Payment({
    required this.id,
    required this.bookingId,
    required this.amount,
    required this.method,
    required this.status,
    this.phoneNumber,
    this.last4Digits,
    required this.createdAt,
  });

  String get methodLabel {
    switch (method) {
      case PaymentMethod.mtnMomo:
        return 'MTN Mobile Money';
      case PaymentMethod.airtelMoney:
        return 'Airtel Money';
      case PaymentMethod.card:
        return 'Card Payment';
    }
  }

  String get statusLabel {
    switch (status) {
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.processing:
        return 'Processing';
      case PaymentStatus.completed:
        return 'Completed';
      case PaymentStatus.failed:
        return 'Failed';
    }
  }
}
