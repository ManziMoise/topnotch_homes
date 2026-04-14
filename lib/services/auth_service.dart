import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/user.dart';

class AuthService extends ChangeNotifier {
  AppUser? _currentUser;
  bool _isLoading = false;

  AppUser? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isLoading => _isLoading;

  // Role convenience getters
  bool get isAdmin => _currentUser?.role == UserRole.admin;
  bool get isManager => _currentUser?.role == UserRole.manager;
  bool get isHost => _currentUser?.role == UserRole.host;
  bool get isGuest => _currentUser?.role == UserRole.user;

  // Mock registered users store with pre-seeded accounts
  static final List<_MockAccount> _accounts = [
    _MockAccount(
      email: 'admin@topnotch.rw',
      password: 'admin123',
      user: AppUser(
        id: 'admin-001',
        fullName: 'Admin Topnotch',
        email: 'admin@topnotch.rw',
        phone: '+250788000001',
        createdAt: DateTime(2025, 1, 1),
        role: UserRole.admin,
      ),
    ),
    _MockAccount(
      email: 'manager@topnotch.rw',
      password: 'manager123',
      user: AppUser(
        id: 'manager-001',
        fullName: 'Manager Topnotch',
        email: 'manager@topnotch.rw',
        phone: '+250788000002',
        createdAt: DateTime(2025, 1, 1),
        role: UserRole.manager,
      ),
    ),
    _MockAccount(
      email: 'host@topnotch.rw',
      password: 'host123',
      user: AppUser(
        id: 'host-001',
        fullName: 'Jean Pierre Host',
        email: 'host@topnotch.rw',
        phone: '+250788000003',
        createdAt: DateTime(2025, 6, 1),
        role: UserRole.host,
      ),
    ),
  ];

  static const _uuid = Uuid();

  Future<String?> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    if (_accounts.any((a) => a.email == email.toLowerCase())) {
      _isLoading = false;
      notifyListeners();
      return 'An account with this email already exists';
    }

    final user = AppUser(
      id: _uuid.v4(),
      fullName: fullName,
      email: email.toLowerCase(),
      phone: phone,
      createdAt: DateTime.now(),
      role: UserRole.user,
    );

    _accounts.add(_MockAccount(
      email: email.toLowerCase(),
      password: password,
      user: user,
    ));

    _currentUser = user;
    _isLoading = false;
    notifyListeners();
    return null;
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    final account = _accounts.where(
      (a) => a.email == email.toLowerCase() && a.password == password,
    );

    if (account.isEmpty) {
      _isLoading = false;
      notifyListeners();
      return 'Invalid email or password';
    }

    _currentUser = account.first.user;
    _isLoading = false;
    notifyListeners();
    return null;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}

class _MockAccount {
  final String email;
  final String password;
  final AppUser user;

  const _MockAccount({
    required this.email,
    required this.password,
    required this.user,
  });
}
