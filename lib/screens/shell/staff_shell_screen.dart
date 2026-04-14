import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../config/theme.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../admin/admin_dashboard_screen.dart';
import '../admin/manage_bookings_screen.dart';
import '../admin/manage_properties_screen.dart';
import '../auth/login_screen.dart';
import '../dashboard/host_dashboard_screen.dart';
import '../dashboard/manager_dashboard_screen.dart';
import '../home/home_screen.dart';
import '../notifications/notifications_screen.dart';
import '../profile/profile_screen.dart';

class StaffShellScreen extends StatefulWidget {
  const StaffShellScreen({super.key});

  @override
  State<StaffShellScreen> createState() => _StaffShellScreenState();
}

class _StaffShellScreenState extends State<StaffShellScreen> {
  int _selectedIndex = 0;

  List<_DrawerItem> _getIndexedItems(UserRole role) {
    return [
      const _DrawerItem(
        icon: Icons.dashboard,
        label: 'Dashboard',
      ),
      const _DrawerItem(
        icon: Icons.search,
        label: 'Browse Properties',
      ),
    ];
  }

  List<_DrawerNavItem> _getPushItems(UserRole role) {
    final items = <_DrawerNavItem>[];

    if (role == UserRole.admin) {
      items.add(_DrawerNavItem(
        icon: Icons.home_work_outlined,
        label: 'Manage Properties',
        builder: () => const ManagePropertiesScreen(),
      ));
      items.add(_DrawerNavItem(
        icon: Icons.bookmark_border,
        label: 'Manage Bookings',
        builder: () => const ManageBookingsScreen(),
      ));
    }

    if (role == UserRole.manager) {
      items.add(_DrawerNavItem(
        icon: Icons.bookmark_border,
        label: 'Manage Bookings',
        builder: () => const ManageBookingsScreen(),
      ));
    }

    items.add(_DrawerNavItem(
      icon: Icons.notifications_outlined,
      label: 'Notifications',
      builder: () => const NotificationsScreen(),
    ));

    items.add(_DrawerNavItem(
      icon: Icons.person_outline,
      label: 'Profile',
      builder: () => const ProfileScreen(),
    ));

    return items;
  }

  String _getTitle(UserRole role) {
    switch (_selectedIndex) {
      case 0:
        switch (role) {
          case UserRole.admin:
            return 'Admin Dashboard';
          case UserRole.manager:
            return 'Manager Dashboard';
          case UserRole.host:
            return 'Host Dashboard';
          default:
            return 'Dashboard';
        }
      case 1:
        return 'Browse Properties';
      default:
        return 'Topnotch Homes';
    }
  }

  Widget _getDashboardBody(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return AdminDashboardScreen.buildBody();
      case UserRole.manager:
        return ManagerDashboardScreen.buildBody();
      case UserRole.host:
        return const HostDashboardBody();
      default:
        return const SizedBox.shrink();
    }
  }

  void _logout() {
    final authService = context.read<AuthService>();
    authService.logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final user = authService.currentUser;

    if (user == null) {
      return const LoginScreen();
    }

    final role = user.role;
    final indexedItems = _getIndexedItems(role);
    final pushItems = _getPushItems(role);

    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle(role)),
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            // Drawer header
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  user.fullName.isNotEmpty
                      ? user.fullName[0].toUpperCase()
                      : '?',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
              accountName: Text(
                user.fullName,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              accountEmail: Row(
                children: [
                  Flexible(
                    child: Text(
                      user.email,
                      style: GoogleFonts.poppins(fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      user.roleLabel,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Indexed items (Dashboard, Browse)
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ...indexedItems.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final item = entry.value;
                    final isSelected = _selectedIndex == idx;
                    return ListTile(
                      leading: Icon(
                        item.icon,
                        color:
                            isSelected ? AppColors.primary : AppColors.textSecondary,
                      ),
                      title: Text(
                        item.label,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textPrimary,
                        ),
                      ),
                      selected: isSelected,
                      selectedTileColor:
                          AppColors.primary.withValues(alpha: 0.08),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onTap: () {
                        setState(() => _selectedIndex = idx);
                        Navigator.pop(context); // close drawer
                      },
                    );
                  }),

                  const Divider(height: 24),

                  // Push-based items
                  ...pushItems.map((item) {
                    return ListTile(
                      leading: Icon(item.icon, color: AppColors.textSecondary),
                      title: Text(
                        item.label,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context); // close drawer
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => item.builder()),
                        );
                      },
                    );
                  }),
                ],
              ),
            ),

            // Sign out
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.error),
              title: Text(
                'Sign Out',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.error,
                ),
              ),
              onTap: _logout,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _getDashboardBody(role),
          const HomeScreen(embedded: true),
        ],
      ),
    );
  }
}

class _DrawerItem {
  final IconData icon;
  final String label;

  const _DrawerItem({required this.icon, required this.label});
}

class _DrawerNavItem {
  final IconData icon;
  final String label;
  final Widget Function() builder;

  const _DrawerNavItem({
    required this.icon,
    required this.label,
    required this.builder,
  });
}
