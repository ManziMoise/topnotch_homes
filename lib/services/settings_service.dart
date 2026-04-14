import 'package:flutter/material.dart';

class SettingsService extends ChangeNotifier {
  int _globalMaxBookingDays = 10;

  int get globalMaxBookingDays => _globalMaxBookingDays;

  void setGlobalMaxBookingDays(int days) {
    if (days > 0 && days <= 30) {
      _globalMaxBookingDays = days;
      notifyListeners();
    }
  }

  /// Returns the effective max stay for a property.
  /// Uses per-property override if set, otherwise global default.
  int getMaxStayForProperty(int? propertyMaxDays) {
    return propertyMaxDays ?? _globalMaxBookingDays;
  }
}
