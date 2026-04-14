import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../config/theme.dart';
import '../../services/auth_service.dart';
import '../../services/booking_service.dart';
import '../../services/property_service.dart';
import '../admin/property_bookings_screen.dart';

class HostDashboardScreen extends StatelessWidget {
  HostDashboardScreen({super.key});

  final _propertyService = PropertyService();
  final _bookingService = BookingService();

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final user = authService.currentUser;
    final hostId = user?.id;

    // Get host's properties
    final allProperties = _propertyService.getAllProperties();
    final hostProperties =
        allProperties.where((p) => p.hostId == hostId).toList();

    // Get bookings for host's properties
    double hostRevenue = 0;
    int hostBookingCount = 0;
    int hostPendingCount = 0;
    for (final prop in hostProperties) {
      final propBookings = _bookingService.getBookingsForProperty(prop.id);
      hostBookingCount += propBookings.length;
      hostPendingCount +=
          propBookings.where((b) => b.status.name == 'pending').length;
      hostRevenue += propBookings.fold(0.0, (sum, b) => sum + b.totalPrice);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Host Dashboard'),
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Properties',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            // Stats
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.home_work,
                    label: 'My Properties',
                    value: '${hostProperties.length}',
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.bookmark,
                    label: 'Bookings',
                    value: '$hostBookingCount',
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.pending_actions,
                    label: 'Pending',
                    value: '$hostPendingCount',
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.attach_money,
                    label: 'Revenue',
                    value: '\$${hostRevenue.toStringAsFixed(0)}',
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            Text(
              'My Listings',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            if (hostProperties.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'No properties assigned to your account yet.',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              )
            else
              ...hostProperties.map((property) {
                final propBookings =
                    _bookingService.getBookingsForProperty(property.id);
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(
                      property.title,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Text(
                      '${property.location} | ${propBookings.length} bookings',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right,
                        color: AppColors.textLight),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PropertyBookingsScreen(
                          propertyId: property.id,
                          propertyTitle: property.title,
                        ),
                      ),
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
