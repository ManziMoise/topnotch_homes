import 'package:uuid/uuid.dart';
import '../models/booking.dart';

class BookingService {
  static final List<Booking> _bookings = [];
  static const _uuid = Uuid();

  static const double serviceFeeRate = 0.04; // 4% service fee

  Booking createBooking({
    required String propertyId,
    required String propertyTitle,
    required String guestName,
    required String guestPhone,
    required String guestEmail,
    String? guestUserId,
    required DateTime checkIn,
    required DateTime checkOut,
    required int guests,
    required double nightlyRate,
  }) {
    final nights = checkOut.difference(checkIn).inDays;
    final subtotal = nightlyRate * nights;
    final serviceFee = subtotal * serviceFeeRate;
    final totalPrice = subtotal + serviceFee;

    final booking = Booking(
      id: _uuid.v4().substring(0, 8).toUpperCase(),
      propertyId: propertyId,
      propertyTitle: propertyTitle,
      guestName: guestName,
      guestPhone: guestPhone,
      guestEmail: guestEmail,
      guestUserId: guestUserId,
      checkIn: checkIn,
      checkOut: checkOut,
      guests: guests,
      nightlyRate: nightlyRate,
      totalPrice: totalPrice,
      serviceFee: serviceFee,
      status: BookingStatus.pending,
      createdAt: DateTime.now(),
    );

    _bookings.add(booking);
    return booking;
  }

  List<Booking> getAllBookings() => List.unmodifiable(_bookings);

  List<Booking> getBookingsForProperty(String propertyId) {
    return _bookings.where((b) => b.propertyId == propertyId).toList();
  }

  List<Booking> getBookingsForUser(String userId) {
    return _bookings.where((b) => b.guestUserId == userId).toList();
  }

  void updateBookingStatus(String bookingId, BookingStatus newStatus) {
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      final old = _bookings[index];
      _bookings[index] = Booking(
        id: old.id,
        propertyId: old.propertyId,
        propertyTitle: old.propertyTitle,
        guestName: old.guestName,
        guestPhone: old.guestPhone,
        guestEmail: old.guestEmail,
        guestUserId: old.guestUserId,
        checkIn: old.checkIn,
        checkOut: old.checkOut,
        guests: old.guests,
        nightlyRate: old.nightlyRate,
        totalPrice: old.totalPrice,
        serviceFee: old.serviceFee,
        status: newStatus,
        createdAt: old.createdAt,
      );
    }
  }

  void cancelBooking(String bookingId) {
    updateBookingStatus(bookingId, BookingStatus.cancelled);
  }

  int get totalCount => _bookings.length;
  int get pendingCount =>
      _bookings.where((b) => b.status == BookingStatus.pending).length;
  int get confirmedCount =>
      _bookings.where((b) => b.status == BookingStatus.confirmed).length;
  int get cancelledCount =>
      _bookings.where((b) => b.status == BookingStatus.cancelled).length;
  double get totalRevenue =>
      _bookings.fold(0, (sum, b) => sum + b.totalPrice);

  Map<String, int> get statusCounts => {
        'pending': pendingCount,
        'confirmed': confirmedCount,
        'cancelled': cancelledCount,
      };
}
