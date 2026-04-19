import 'dart:async';

/// Servicio que controla la lógica del cronómetro y expone un stream de segundos.
class TimerService {
  int _seconds = 0;
  Timer? _timer;
  final StreamController<int> _controller = StreamController<int>.broadcast();

  Stream<int> get ticks => _controller.stream;
  bool get isRunning => _timer != null;

  void _emit() => _controller.add(_seconds);

  void start(void Function(String text, {String level}) log) {
    if (isRunning) return;
    log('TimerService: Start (desde 0)', level: 'INFO');
    _seconds = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _seconds++;
      _emit();
    });
    _emit();
  }

  void resume(void Function(String text, {String level}) log) {
    if (isRunning) return;
    if (_seconds == 0) return;
    log('TimerService: Resume', level: 'INFO');
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _seconds++;
      _emit();
    });
  }

  void pause(void Function(String text, {String level}) log) {
    if (!isRunning) return;
    log('TimerService: Pause', level: 'INFO');
    _timer?.cancel();
    _timer = null;
  }

  void reset(void Function(String text, {String level}) log) {
    log('TimerService: Reset', level: 'INFO');
    _timer?.cancel();
    _timer = null;
    _seconds = 0;
    _emit();
  }

  void dispose() {
    _timer?.cancel();
    _controller.close();
  }
}
