import 'package:flutter/material.dart';
import '../features/future/future_screen.dart';
import '../features/timer/timer_screen.dart';
import '../features/isolate/isolate_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color iosBlue = Color(0xFF007AFF);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text('Taller: Asincronía'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              _buildMenuCard(
                context,
                title: 'Future (Simulación API)',
                subtitle: 'Simula una llamada asíncrona',
                color: iosBlue,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FutureScreen())),
              ),
              const SizedBox(height: 12),
              _buildMenuCard(
                context,
                title: 'Timer (Cronómetro)',
                subtitle: 'Iniciar / Pausar / Reanudar / Reiniciar',
                color: iosBlue,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TimerScreen())),
              ),
              const SizedBox(height: 12),
              _buildMenuCard(
                context,
                title: 'Isolate (Tarea pesada)',
                subtitle: 'Ejecuta tarea en segundo plano',
                color: iosBlue,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const IsolateScreen())),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context,
      {required String title, required String subtitle, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFFFFFFFF), Color(0xFFF7F9FC)]),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(6, 6)),
            BoxShadow(color: Colors.white.withOpacity(0.9), blurRadius: 12, offset: const Offset(-6, -6)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(14)),
              child: const Icon(Icons.code, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text(subtitle, style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black26),
          ],
        ),
      ),
    );
  }
}
