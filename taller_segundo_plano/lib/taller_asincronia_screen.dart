import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';

void heavyComputation(SendPort sendPort) {
  final int N = 100000000; 
  BigInt sum = BigInt.zero;
  for (int i = 1; i <= N; i++) {
    sum += BigInt.from(i);
  }
  // Enviamos el resultado de vuelta al UI thread.
  sendPort.send(sum.toString());
}

class TallerAsincroniaScreen extends StatefulWidget {
  const TallerAsincroniaScreen({super.key});

  @override
  State<TallerAsincroniaScreen> createState() => _TallerAsincroniaScreenState();
}

class _TallerAsincroniaScreenState extends State<TallerAsincroniaScreen> {
  // --- Módulo Future ---
  String _futureStatus = 'Esperando acción';
  bool _futureLoading = false;
  String? _fetchedData;

  // --- Módulo Timer (cronómetro) ---
  Timer? _timer;
  int _seconds = 0;
  bool _isRunning = false;

  // --- Módulo Isolate ---
  Isolate? _isolate;
  ReceivePort? _receivePort;
  bool _isIsolateRunning = false;
  String? _isolateResult;

  // ----------------- FUTURE (simulación API) -----------------
  Future<void> _simulateApiCall() async {
    // Mensajes en consola para seguir el flujo: Antes, Durante, Después
    print('Future: Antes de la llamada');
    setState(() {
      _futureLoading = true;
      _futureStatus = 'Cargando...';
      _fetchedData = null;
    });

    print('Future: Durante la ejecución (simulación)');
    // Simulación de retardo de red entre 2 y 3 segundos
    await Future.delayed(const Duration(seconds: 2));

    // Resultado simulado
    final data = 'Datos simulados recibidos';

    print('Future: Después de la llamada');
    setState(() {
      _futureLoading = false;
      _futureStatus = 'Éxito: Datos obtenidos';
      _fetchedData = data;
    });
  }

  // ----------------- TIMER (cronómetro) -----------------
  /// Inicia el cronómetro desde cero.
  void _startTimer() {
    if (_isRunning) return;
    // Reiniciar a cero al iniciar desde "Iniciar"
    _seconds = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _seconds++);
    });
    setState(() => _isRunning = true);
  }

  /// Reanuda el cronómetro desde el tiempo actual.
  void _resumeTimer() {
    if (_isRunning) return;
    // Si no hay segundos acumulados, no tiene sentido reanudar.
    if (_seconds == 0) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _seconds++);
    });
    setState(() => _isRunning = true);
  }

  /// Pausa el cronómetro manteniendo el tiempo actual.
  void _pauseTimer() {
    _timer?.cancel();
    _timer = null;
    setState(() => _isRunning = false);
  }

  /// Reinicia el cronómetro a cero.
  void _resetTimer() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _seconds = 0;
      _isRunning = false;
    });
  }

  // ----------------- ISOLATE (tarea pesada) -----------------
  Future<void> _startHeavyIsolate() async {
    if (_isIsolateRunning) return;
    print('Isolate: Iniciando');
    setState(() {
      _isIsolateRunning = true;
      _isolateResult = null;
    });

    _receivePort = ReceivePort();

    // Escuchar mensajes del Isolate
    _receivePort!.listen((message) async {
      // message contendrá el resultado enviado desde heavyComputation
      print('Isolate: Mensaje recibido en UI');
      setState(() {
        _isIsolateRunning = false;
        _isolateResult = message?.toString();
      });

      // Liberar recursos
      _receivePort?.close();
      _receivePort = null;
      // Si creamos el Isolate localmente la referencia puede ser usada
      _isolate?.kill(priority: Isolate.immediate);
      _isolate = null;
    });

    // Lanzar el isolate pasando el SendPort
    try {
      _isolate = await Isolate.spawn(heavyComputation, _receivePort!.sendPort);
    } catch (e) {
      print('Isolate: Error al spawn -> $e');
      _receivePort?.close();
      setState(() {
        _isIsolateRunning = false;
        _isolateResult = 'Error al iniciar Isolate';
      });
    }
  } 

  @override
  void dispose() {
    // IMPORTANTE: cancelar timer para evitar fugas de memoria
    _timer?.cancel();

    // Cerrar receivePort e intentar matar isolate si aún existe
    _receivePort?.close();
    _isolate?.kill(priority: Isolate.immediate);
    super.dispose();
  }

  // ----------------- UI -----------------
  @override
  Widget build(BuildContext context) {
    const Color iosBlue = Color(0xFF007AFF);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        foregroundColor: iosBlue,
        title: const Text('Taller: Asincronía & Background'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFFFFF), Color(0xFFF7F9FC)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        titleTextStyle: const TextStyle(color: iosBlue, fontSize: 18, fontWeight: FontWeight.w600),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF5F7FA), Color(0xFFEFF3F8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildCardFuture(),
                const SizedBox(height: 12),
                _buildCardTimer(),
                const SizedBox(height: 12),
                _buildCardIsolate(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Card para el módulo Future
  Widget _buildCardFuture() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Módulo Future', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(_futureStatus, style: const TextStyle(color: Colors.black87)),
          const SizedBox(height: 12),
          if (_futureLoading) const Center(child: CircularProgressIndicator()),
          if (_fetchedData != null) ...[
            const SizedBox(height: 8),
            Text(_fetchedData!, style: const TextStyle(color: Colors.green)),
          ],
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: _futureLoading ? null : _simulateApiCall,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 209, 209, 209),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Simular consulta'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Card para el módulo Timer (cronómetro)
  Widget _buildCardTimer() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits((_seconds ~/ 60));
    final seconds = twoDigits((_seconds % 60));

    const Color iosBlue = Color(0xFF007AFF);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFFF7F9FC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30.0),
        border: Border.all(color: Color(0xFFECEFF5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(8, 8),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.95),
            blurRadius: 18,
            offset: const Offset(-8, -8),
          ),
        ],
      ),
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
          // Use Wrap to allow buttons to flow onto multiple lines on narrow screens
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                onPressed: _isRunning ? null : _startTimer,
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
                onPressed: (!_isRunning && _seconds > 0) ? _resumeTimer : null,
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
                onPressed: _isRunning ? _pauseTimer : null,
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
    );
  }

  // Card para el módulo Isolate
  Widget _buildCardIsolate() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Módulo Isolate', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          const Text('Tarea pesada simulada en background (sumar 1..1,000,000,000)', style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 12),
          if (_isIsolateRunning) ...[
            const Center(child: CircularProgressIndicator()),
            const SizedBox(height: 8),
            const Text('Isolate ejecutándose...', style: TextStyle(color: Colors.black87)),
          ] else if (_isolateResult != null) ...[
            const SizedBox(height: 8),
            Text('Resultado: ${_isolateResult}', style: const TextStyle(color: Colors.green)),
          ] else ...[
            const SizedBox(height: 8),
            const Text('Presiona ejecutar para iniciar Isolate', style: TextStyle(color: Colors.black87)),
          ],
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: _isIsolateRunning ? null : _startHeavyIsolate,
                style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 209, 209, 209), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text('Ejecutar Isolate'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
