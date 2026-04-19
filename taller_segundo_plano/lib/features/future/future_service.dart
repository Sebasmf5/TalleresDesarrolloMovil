import 'dart:math';

/// Servicio que simula una llamada a API y reporta logs mediante callback.
class FutureService {
  final Random _rng = Random();

  /// Simula una petición. Llama a [log] con mensajes y niveles.
  /// Retorna el `String` de datos o lanza una excepción en caso de error simulado.
  Future<String> fetchSimulated(void Function(String text, {String level}) log) async {
    final stopwatch = Stopwatch()..start();
    log('Future: Antes de la llamada', level: 'INFO');
    log('Future: Ejecutando petición simulada', level: 'INFO');
    await Future.delayed(const Duration(seconds: 2));

    // 30% probabilidad de fallo
    if (_rng.nextInt(100) < 30) {
      stopwatch.stop();
      final err = Exception('Simulated network error (timeout)');
      log('Future: Error en petición: ${err.toString()} (duración ${stopwatch.elapsedMilliseconds} ms)', level: 'ERROR');
      throw err;
    }

    stopwatch.stop();
    final data = 'Datos simulados recibidos';
    log('Future: Respuesta recibida en ${stopwatch.elapsedMilliseconds} ms', level: 'INFO');
    return data;
  }
}
