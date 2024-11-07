import 'dart:async';
import 'package:flutter/foundation.dart';

class TimerService with ChangeNotifier {
  int _timeLimit = 5; 
  int _remainingTime = 5 * 60; 
  Timer? _timer;
  Function? onTimerEnd;

  int get timeLimit => _timeLimit;
  int get remainingTime => _remainingTime;

  void setTimeLimit(int minutes) {
    _timeLimit = minutes;
    _remainingTime = _timeLimit * 60;
    notifyListeners();
  }

  void startTimer({Function? onTimerEnd}) {
    this.onTimerEnd = onTimerEnd; 

    if (_timer != null) return;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        _remainingTime--;
        notifyListeners();
      } else {
        stopTimer();
        if (onTimerEnd != null) {
          onTimerEnd(); 
        }
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
    notifyListeners();
  }

  void resetTimer() {
    _remainingTime = _timeLimit * 60;
    notifyListeners();
  }

  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
