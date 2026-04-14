import 'package:flutter/material.dart';

class SettingsService extends ChangeNotifier {
  int _maxActiveBookings = 10;

  int get maxActiveBookings => _maxActiveBookings;

  void setMaxActiveBookings(int count) {
    if (count > 0 && count <= 100) {
      _maxActiveBookings = count;
      notifyListeners();
    }
  }
}
