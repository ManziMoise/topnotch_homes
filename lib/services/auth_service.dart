import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/user.dart';

class AuthService extends ChangeNotifier {
  AppUser? _currentUser;
  bool _isLoading = false;

  AppUser? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isLoading => _isLoading;

  // Mock registered users store
  static final List<_MockAccount> _accounts = [];
  static const _uuid = Uuid();

  Future<String?> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Check if email already exists
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
    );

    _accounts.add(_MockAccount(
      email: email.toLowerCase(),
      password: password,
      user: user,
    ));

    _currentUser = user;
    _isLoading = false;
    notifyListeners();
    return null; // success
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
    return null; // success
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
