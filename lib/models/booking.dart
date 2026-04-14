enum BookingStatus { pending, confirmed, cancelled }

class Booking {
  final String id;
  final String propertyId;
  final String propertyTitle;
  final String guestName;
  final String guestPhone;
  final String guestEmail;
  final String? guestUserId;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final double nightlyRate;
  final double totalPrice;
  final double serviceFee;
  final BookingStatus status;
  final DateTime createdAt;

  const Booking({
    required this.id,
    required this.propertyId,
    required this.propertyTitle,
    required this.guestName,
    required this.guestPhone,
    required this.guestEmail,
    this.guestUserId,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.nightlyRate,
    required this.totalPrice,
    required this.serviceFee,
    required this.status,
    required this.createdAt,
  });

  int get numberOfNights => checkOut.difference(checkIn).inDays;
}
