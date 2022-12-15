import 'dart:async';

class PausableTimer {
  PausableTimer(duration, func) {
    _timer = Timer.periodic(duration, (timer) async {
      func();
    });
  }

  Timer? _timer;

  void dispose() {
    print("timer_canceled");
    _timer?.cancel();
  }
}
