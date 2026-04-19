
import 'package:flutter/material.dart';
import '../../widgets/log_console.dart';
import '../../widgets/custom_card.dart';
import '../../utils/logger_mixin.dart';
import 'future_service.dart';

class FutureScreen extends StatefulWidget {
  const FutureScreen({super.key});

  @override
  State<FutureScreen> createState() => _FutureScreenState();
}

class _FutureScreenState extends State<FutureScreen> with LoggerMixin {
  final FutureService _service = FutureService();
  String _status = 'Esperando acción';
  bool _loading = false;
  String? _data;

  Future<void> _simulateApiCall() async {
    setState(() {
      _loading = true;
      _status = 'Cargando...';
      _data = null;
    });

    try {
      final data = await _service.fetchSimulated(addLog);
      setState(() {
        _loading = false;
        _status = 'Éxito: Datos obtenidos';
        _data = data;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _status = 'Error: ${e.toString()}';
        _data = null;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Módulo Future')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Módulo Future', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Text(_status,
                        style: TextStyle(color: _status.startsWith('Error') ? Colors.red : Colors.black87)),
                    const SizedBox(height: 6),
                    const Text('Nota: errores simulados aleatoriamente (~30% probabilidad)', style: TextStyle(fontSize: 12, color: Colors.black45)),
                    const SizedBox(height: 12),
                    if (_loading) const Center(child: CircularProgressIndicator()),
                    if (_data != null) ...[
                      const SizedBox(height: 8),
                      Text(_data!, style: const TextStyle(color: Colors.green)),
                    ],
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: _loading
                              ? null
                              : () {
                                  addLog('Future: Iniciando simulación (probabilidad de fallo 30%)', level: 'INFO');
                                  _simulateApiCall();
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 209, 209, 209),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Simular consulta'),
                        ),
                        const SizedBox(width: 8),
                        if (_status.startsWith('Error'))
                          OutlinedButton(
                            onPressed: _loading
                                ? null
                                : () {
                                    addLog('Future: Reintentando petición', level: 'INFO');
                                    _simulateApiCall();
                                  },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.redAccent),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Reintentar', style: TextStyle(color: Colors.redAccent)),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Log console
              Expanded(child: LogConsole(logs: logs)),
            ],
          ),
        ),
      ),
    );
  }
}
