import 'dart:async';
import 'package:flutter/material.dart';
import '../../widgets/log_console.dart';
import '../../widgets/custom_card.dart';
import '../../utils/logger_mixin.dart';
import 'isolate_service.dart';

class IsolateScreen extends StatefulWidget {
  const IsolateScreen({super.key});

  @override
  State<IsolateScreen> createState() => _IsolateScreenState();
}

class _IsolateScreenState extends State<IsolateScreen> with LoggerMixin {
  final IsolateService _service = IsolateService();
  bool _isRunning = false;
  String? _result;
  double _progress = 0.0;

  // Main-thread run fields for comparison
  bool _isRunningMain = false;
  String? _mainResult;
  Duration? _mainDuration;
  Duration? _isolateDuration;
  String? _comparison;



  Future<void> _startIsolate() async {
    if (_isRunning) return;
    addLog('Isolate: Iniciando');
    setState(() {
      _isRunning = true;
      _result = null;
    });

    try {
      _progress = 0.0;
      final sw = Stopwatch()..start();
      final res = await _service.runHeavy(
        addLog,
        onProgress: (p) {
          setState(() => _progress = p);
        },
      );
      sw.stop();
      setState(() {
        _isRunning = false;
        _result = res;
        _isolateDuration = sw.elapsed;
        _progress = 1.0;
      });
      addLog('Isolate: Finalizado (resultado recibido) en ${_isolateDuration?.inMilliseconds} ms', level: 'INFO');
    } catch (e) {
      addLog('Isolate: Error -> $e', level: 'ERROR');
      setState(() {
        _isRunning = false;
        _result = 'Error al iniciar Isolate';
        _progress = 0.0;
      });
    }
  }

  // Synchronous computation on the main thread for comparison (will block UI)
  String _computeOnMainThread(int N, void Function(double)? onProgress) {
    BigInt sum = BigInt.zero;
    final int steps = 100;
    final int chunk = (N / steps).ceil();
    for (int i = 1; i <= N; i++) {
      sum += BigInt.from(i);
      if (onProgress != null && i % chunk == 0) {
        onProgress(i / N);
      }
    }
    return sum.toString();
  }

  Future<void> _runOnMainThread() async {
    if (_isRunningMain) return;
    addLog('MainThread: Iniciando (bloqueará UI)');
    setState(() {
      _isRunningMain = true;
      _mainResult = null;
    });

    try {
      final sw = Stopwatch()..start();
      // Use same N as isolate service for fair comparison
      const int N = 20000000;
      final res = _computeOnMainThread(N, null);
      sw.stop();
      setState(() {
        _isRunningMain = false;
        _mainResult = res;
        _mainDuration = sw.elapsed;
      });
      addLog('MainThread: Finalizado en ${_mainDuration?.inMilliseconds} ms', level: 'INFO');
    } catch (e) {
      addLog('MainThread: Error -> $e', level: 'ERROR');
      setState(() {
        _isRunningMain = false;
        _mainResult = 'Error';
      });
    }
  }

  void _compareResults() {
    if (_result == null || _mainResult == null) {
      addLog('Comparación: Ambos resultados deben existir para comparar', level: 'WARN');
      setState(() => _comparison = 'Falta ejecutar alguna prueba');
      return;
    }
    final equal = _result == _mainResult;
    setState(() => _comparison = equal ? 'Iguales' : 'Diferentes');
    addLog('Comparación: resultados ${equal ? 'IGUALES' : 'DISTINTOS'}', level: equal ? 'INFO' : 'ERROR');
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Módulo Isolate')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Módulo Isolate', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    const Text('Tarea pesada simulada en background (sumar 1..N)', style: TextStyle(color: Colors.black54)),
                    const SizedBox(height: 12),
                    if (_isRunning) ...[
                      const SizedBox(height: 6),
                      LinearProgressIndicator(value: _progress, minHeight: 6),
                      const SizedBox(height: 8),
                      Center(child: Text('Progreso: ${( _progress * 100 ).toStringAsFixed(1)}%')),
                      const SizedBox(height: 8),
                      const Text('Isolate ejecutándose...', style: TextStyle(color: Colors.black87)),
                    ] else if (_result != null) ...[
                      const SizedBox(height: 8),
                      Text('Resultado Isolate: ${_result}', style: const TextStyle(color: Colors.green)),
                      if (_isolateDuration != null) Text('Tiempo Isolate: ${_isolateDuration!.inMilliseconds} ms', style: const TextStyle(color: Colors.black87)),
                    ] else ...[
                      const SizedBox(height: 8),
                      const Text('Presiona ejecutar para iniciar Isolate', style: TextStyle(color: Colors.black87)),
                    ],
                    const SizedBox(height: 12),
                    // Use Wrap so buttons wrap on small screens instead of overflowing
                    Wrap(
                      alignment: WrapAlignment.end,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton(
                          onPressed: _isRunning ? null : _startIsolate,
                          style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 209, 209, 209), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                          child: const Text('Ejecutar Isolate'),
                        ),
                        ElevatedButton(
                          onPressed: _isRunningMain ? null : _runOnMainThread,
                          style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 240, 240, 240), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                          child: const Text('Ejecutar en hilo principal'),
                        ),
                        ElevatedButton(
                          onPressed: (_result != null && _mainResult != null) ? _compareResults : null,
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF007AFF), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                          child: const Text('Comparar', style: TextStyle(color: Colors.white)),
                        ),
                        if (_comparison != null) Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0), child: Text(_comparison!, style: const TextStyle(fontWeight: FontWeight.bold))),
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
