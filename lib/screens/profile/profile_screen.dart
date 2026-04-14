import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../config/theme.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../auth/login_screen.dart';
import '../bookings/my_bookings_screen.dart';
import '../dashboard/user_dashboard_screen.dart';
import '../faq/faq_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final user = authService.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person_off_outlined,
                  size: 64, color: AppColors.textLight),
              const SizedBox(height: 16),
              Text(
                'Not signed in',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                ),
                child: const Text('Sign In'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.error),
            onPressed: () => _showLogoutDialog(context, authService),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Avatar
            CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: Text(
                user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : '?',
                style: GoogleFonts.poppins(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user.fullName,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'Member since ${DateFormat('MMMM yyyy').format(user.createdAt)}',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                user.roleLabel,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Info cards
            _infoTile(Icons.email_outlined, 'Email', user.email),
            _infoTile(Icons.phone_outlined, 'Phone', user.phone),
            const SizedBox(height: 24),

            // Actions
            _actionTile(
              icon: Icons.bookmark_outline,
              label: 'My Bookings',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyBookingsScreen()),
              ),
            ),
            _actionTile(
              icon: Icons.favorite_outline,
              label: 'Saved Properties',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Coming soon')),
                );
              },
            ),
            _actionTile(
              icon: Icons.help_outline,
              label: 'Help & Support',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FaqScreen()),
              ),
            ),
            const Divider(height: 24),

            // User dashboard link (staff roles access dashboard via sidebar)
            if (user.role == UserRole.user)
              _actionTile(
                icon: Icons.dashboard_outlined,
                label: 'My Dashboard',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => UserDashboardScreen()),
                ),
              ),
            const SizedBox(height: 30),

            // Logout button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () => _showLogoutDialog(context, authService),
                icon: const Icon(Icons.logout, color: AppColors.error),
                label: Text(
                  'Sign Out',
                  style: GoogleFonts.poppins(
                    color: AppColors.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.error),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textLight),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthService authService) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Sign Out', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              authService.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Sign Out', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
