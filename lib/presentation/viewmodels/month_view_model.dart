import 'package:flutter/material.dart';

class MonthViewModel extends ChangeNotifier {
  DateTime _currentMonth;

  MonthViewModel()
    : _currentMonth = DateTime(DateTime.now().year, DateTime.now().month);

  DateTime get currentMonth => _currentMonth;

  void changeMonth(DateTime newMonth) {
    _currentMonth = DateTime(newMonth.year, newMonth.month);
    notifyListeners();
  }
}
