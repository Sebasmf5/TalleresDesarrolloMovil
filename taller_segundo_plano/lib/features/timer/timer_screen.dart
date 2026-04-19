import 'dart:async';
import 'package:flutter/material.dart';
import '../../widgets/log_console.dart';
import '../../widgets/custom_card.dart';
import '../../utils/logger_mixin.dart';
import 'timer_service.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> with LoggerMixin {
  final TimerService _service = TimerService();
  int _seconds = 0;
  StreamSubscription<int>? _sub;



  void _startTimer() {
    if (_service.isRunning) return;
    _service.start(addLog);
  }

  void _resumeTimer() {
    if (_service.isRunning) return;
    _service.resume(addLog);
  }

  void _pauseTimer() {
    if (!_service.isRunning) return;
    _service.pause(addLog);
    setState(() {});
  }

  void _resetTimer() {
    _service.reset(addLog);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _sub = _service.ticks.listen((s) {
      setState(() => _seconds = s);
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits((_seconds ~/ 60));
    final seconds = twoDigits((_seconds % 60));

    const Color iosBlue = Color(0xFF007AFF);

    return Scaffold(
      appBar: AppBar(title: const Text('Cronómetro')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CustomCard(
                variant: CardVariant.neumorphic,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Cronómetro', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w200, color: Color(0xFF263238))),
                    const SizedBox(height: 14),
                    Text(
                      '$minutes:$seconds',
                      style: const TextStyle(fontSize: 56, fontWeight: FontWeight.w200, color: Color(0xFF102027), letterSpacing: 1.2),
                    ),
                    const SizedBox(height: 18),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _service.isRunning ? null : _startTimer,
                          icon: const Icon(Icons.play_arrow, size: 20),
                          label: const Text('Iniciar', style: TextStyle(fontWeight: FontWeight.w400)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: iosBlue,
                            foregroundColor: Colors.white,
                            elevation: 6,
                            shadowColor: iosBlue.withOpacity(0.25),
                            minimumSize: const Size(100, 44),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: (!_service.isRunning && _seconds > 0) ? _resumeTimer : null,
                          icon: const Icon(Icons.play_circle_outline, size: 20),
                          label: const Text('Reanudar', style: TextStyle(fontWeight: FontWeight.w400)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: iosBlue,
                            elevation: 0,
                            side: const BorderSide(color: Color(0xFFE3E9F3)),
                            minimumSize: const Size(110, 44),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _service.isRunning ? _pauseTimer : null,
                          icon: const Icon(Icons.pause, size: 20),
                          label: const Text('Pausar', style: TextStyle(fontWeight: FontWeight.w400)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: iosBlue,
                            elevation: 0,
                            side: const BorderSide(color: Color(0xFFE3E9F3)),
                            minimumSize: const Size(100, 44),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _resetTimer,
                          icon: const Icon(Icons.replay, size: 20),
                          label: const Text('Reiniciar', style: TextStyle(fontWeight: FontWeight.w400)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: iosBlue,
                            elevation: 0,
                            side: const BorderSide(color: Color(0xFFE3E9F3)),
                            minimumSize: const Size(110, 44),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(child: LogConsole(logs: logs)),
            ],
          ),
        ),
      ),
    );
  }
}
