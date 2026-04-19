import 'dart:async';
import 'dart:isolate';

/// Servicio para ejecutar la tarea pesada en un Isolate y reportar logs y progreso.
class IsolateService {
  Isolate? _isolate;

  /// Ejecuta la tarea pesada. [log] recibe mensajes de texto.
  /// [onProgress] se llama con valores entre 0.0 y 1.0 para actualizar UI.
  Future<String> runHeavy(
    void Function(String text, {String level}) log, {
    void Function(double progress)? onProgress,
  }) async {
    if (_isolate != null) return Future.error('Isolate already running');
    log('IsolateService: Iniciando', level: 'INFO');

    final receivePort = ReceivePort();
    try {
      _isolate = await Isolate.spawn(_heavyComputation, receivePort.sendPort);
    } catch (e) {
      receivePort.close();
      log('IsolateService: Error al spawn -> $e', level: 'ERROR');
      rethrow;
    }

    final completer = Completer<String>();
    receivePort.listen((message) {
      // Esperamos mensajes estructurados desde el isolate
      if (message is Map) {
        final type = message['type'];
        if (type == 'progress') {
          final percent = (message['percent'] as num).toDouble();
          final msg = message['message']?.toString() ?? '';
          log('Isolate: ${(percent * 100).toStringAsFixed(1)}% - $msg', level: 'INFO');
          if (onProgress != null) onProgress(percent);
        } else if (type == 'done') {
          final result = message['result']?.toString() ?? '';
          if (!completer.isCompleted) completer.complete(result);
          receivePort.close();
          _isolate?.kill(priority: Isolate.immediate);
          _isolate = null;
        } else if (type == 'log') {
          final msg = message['message']?.toString() ?? '';
          log('Isolate: $msg', level: 'INFO');
        }
      } else {
        // Fallback: tratar como resultado final en string
        if (!completer.isCompleted) completer.complete(message?.toString());
        receivePort.close();
        _isolate?.kill(priority: Isolate.immediate);
        _isolate = null;
      }
    });

    return completer.future;
  }

  void dispose() {
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
  }
}

// función top-level ejecutada por el isolate
void _heavyComputation(SendPort sendPort) {
  // N suficientemente grande para demo; ajustable si se desea.
  const int N = 20000000; // 20 millones
  BigInt sum = BigInt.zero;

  final int steps = 100; // envia 100 eventos de progreso
  final int chunk = (N / steps).ceil();

  for (int i = 1; i <= N; i++) {
    sum += BigInt.from(i);
    if (i % chunk == 0) {
      final double percent = i / N;
      sendPort.send({
        'type': 'progress',
        'percent': percent,
        'message': 'Procesados $i de $N elementos',
      });
      // envía también un pequeño "hallazgo" interesante cada 25%.
      if ((percent * 100).toInt() % 25 == 0) {
        final s = sum.toString();
        sendPort.send({
          'type': 'log',
          'message': 'Checkpoint: sum parcial ${s.length > 12 ? s.substring(0, 12) : s}...',
        });
      }
    }
  }

  // envío del resultado final
  sendPort.send({'type': 'done', 'result': sum.toString()});
}
