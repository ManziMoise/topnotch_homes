import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';

import '../../config/theme.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../auth/login_screen.dart';
import '../home/home_screen.dart';
import '../shell/staff_shell_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        final authService = context.read<AuthService>();
        final isLoggedIn = authService.isLoggedIn;
        final role = authService.currentUser?.role;
        final isStaff = role != null && role != UserRole.user;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => !isLoggedIn
                ? const LoginScreen()
                : isStaff
                    ? const StaffShellScreen()
                    : const HomeScreen(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
        ),
        child: FadeTransition(
          opacity: _fadeIn,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo icon
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.home_work_rounded,
                  size: 72,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Topnotch Homes',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Find your perfect stay in Rwanda',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
