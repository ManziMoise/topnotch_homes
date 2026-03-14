import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../config/theme.dart';
import '../../models/booking.dart';
import '../../services/booking_service.dart';

class ManageBookingsScreen extends StatefulWidget {
  const ManageBookingsScreen({super.key});

  @override
  State<ManageBookingsScreen> createState() => _ManageBookingsScreenState();
}

class _ManageBookingsScreenState extends State<ManageBookingsScreen> {
  final _bookingService = BookingService();
  final _dateFormat = DateFormat('MMM dd, yyyy');

  @override
  Widget build(BuildContext context) {
    final bookings = _bookingService.getAllBookings();

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Bookings')),
      body: bookings.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.inbox_outlined,
                      size: 64, color: AppColors.textLight),
                  const SizedBox(height: 16),
                  Text(
                    'No bookings yet',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[bookings.length - 1 - index];
                return _AdminBookingCard(
                  booking: booking,
                  dateFormat: _dateFormat,
                  onStatusChange: (newStatus) {
                    _bookingService.updateBookingStatus(
                        booking.id, newStatus);
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Booking #${booking.id} ${newStatus.name}',
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class _AdminBookingCard extends StatelessWidget {
  final Booking booking;
  final DateFormat dateFormat;
  final void Function(BookingStatus) onStatusChange;

  const _AdminBookingCard({
    required this.booking,
    required this.dateFormat,
    required this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '#${booking.id}',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                _statusBadge(booking.status),
              ],
            ),
            const SizedBox(height: 10),

            // Property
            Text(
              booking.propertyTitle,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),

            // Guest info
            _infoRow(Icons.person, booking.guestName),
            _infoRow(Icons.phone, booking.guestPhone),
            _infoRow(Icons.email, booking.guestEmail),
            _infoRow(Icons.calendar_today,
                '${dateFormat.format(booking.checkIn)} - ${dateFormat.format(booking.checkOut)}'),
            _infoRow(Icons.people, '${booking.guests} guests, ${booking.numberOfNights} nights'),

            const Divider(height: 20),

            // Price + actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${booking.totalPrice.toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                Row(
                  children: [
                    if (booking.status == BookingStatus.pending) ...[
                      _actionButton(
                        'Confirm',
                        AppColors.success,
                        () => onStatusChange(BookingStatus.confirmed),
                      ),
                      const SizedBox(width: 8),
                      _actionButton(
                        'Cancel',
                        AppColors.error,
                        () => onStatusChange(BookingStatus.cancelled),
                      ),
                    ],
                    if (booking.status == BookingStatus.confirmed)
                      _actionButton(
                        'Cancel',
                        AppColors.error,
                        () => onStatusChange(BookingStatus.cancelled),
                      ),
                    if (booking.status == BookingStatus.cancelled)
                      _actionButton(
                        'Reopen',
                        AppColors.primary,
                        () => onStatusChange(BookingStatus.pending),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(BookingStatus status) {
    Color color;
    String label;
    switch (status) {
      case BookingStatus.pending:
        color = AppColors.accent;
        label = 'Pending';
      case BookingStatus.confirmed:
        color = AppColors.success;
        label = 'Confirmed';
      case BookingStatus.cancelled:
        color = AppColors.error;
        label = 'Cancelled';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _actionButton(String label, Color color, VoidCallback onPressed) {
    return SizedBox(
      height: 34,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          textStyle: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        child: Text(label),
      ),
    );
  }
}
