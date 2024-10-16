import 'package:flutter/material.dart';

class ProgressProvider with ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void updateIndex(int index) {
    _currentIndex = index;
    notifyListeners(); // Notify listeners to rebuild
  }
}