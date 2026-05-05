import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const WeatherPage(),
    );
  }
}

class Weather {
  final double temperature;
  final double windspeed;
  final int weathercode;
  final DateTime time;

  Weather({required this.temperature, required this.windspeed, required this.weathercode, required this.time});

  factory Weather.fromJson(Map<String, dynamic> json) {
    final cw = json['current_weather'] as Map<String, dynamic>;
    return Weather(
      temperature: (cw['temperature'] as num).toDouble(),
      windspeed: (cw['windspeed'] as num).toDouble(),
      weathercode: (cw['weathercode'] as num).toInt(),
      time: DateTime.parse(cw['time'] as String),
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  Weather? _weather;
  bool _loading = false;
  String? _error;

  // Bogotá coordinates
  final double _lat = 4.7110;
  final double _lon = -74.0721;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final url = 'https://api.open-meteo.com/v1/forecast?latitude=$_lat&longitude=$_lon&current_weather=true&timezone=UTC';
    try {
      final res = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      if (res.statusCode == 200) {
        final data = json.decode(res.body) as Map<String, dynamic>;
        setState(() => _weather = Weather.fromJson(data));
      } else {
        setState(() => _error = 'Server error: ${res.statusCode}');
      }
    } on TimeoutException {
      setState(() => _error = 'Request timed out (10s)');
    } catch (e) {
      setState(() => _error = 'Network error: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  IconData _iconForCode(int code) {
    if (code == 0) return Icons.wb_sunny;
    if (code == 1 || code == 2 || code == 3) return Icons.cloud;
    if (code == 45 || code == 48) return Icons.blur_on; // fog
    if ((51 <= code && code <= 67) || (80 <= code && code <= 82)) return Icons.grain; // rain/drizzle
    if ((71 <= code && code <= 77) || (85 <= code && code <= 86)) return Icons.ac_unit; // snow
    if (code >= 95) return Icons.flash_on; // thunder
    return Icons.help_outline;
  }

  String _descForCode(int code) {
    if (code == 0) return 'Clear';
    if (code == 1) return 'Mainly clear';
    if (code == 2) return 'Partly cloudy';
    if (code == 3) return 'Overcast';
    if (code == 45 || code == 48) return 'Fog';
    if (51 <= code && code <= 57) return 'Drizzle';
    if (61 <= code && code <= 67) return 'Rain';
    if (71 <= code && code <= 77) return 'Snow';
    if (80 <= code && code <= 82) return 'Rain showers';
    if (code >= 95) return 'Thunderstorm';
    return 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Bogotá — Clima Actual')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFe0f7fa), Color(0xFF80deea)],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _loading
                ? const CircularProgressIndicator()
                : _error != null
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.error_outline, size: 48, color: Colors.red[700]),
                          const SizedBox(height: 12),
                          Text(_error!, style: theme.textTheme.bodyLarge?.copyWith(color: Colors.red[700]), textAlign: TextAlign.center),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(onPressed: _fetchWeather, icon: const Icon(Icons.refresh), label: const Text('Reintentar')),
                        ],
                      )
                    : _weather == null
                        ? const Text('Sin datos')
                        : Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 8,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(_iconForCode(_weather!.weathercode), size: 56, color: Colors.orange[700]),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('${_weather!.temperature.toStringAsFixed(1)}°C', style: theme.textTheme.headlineLarge),
                                          Text(_descForCode(_weather!.weathercode), style: theme.textTheme.titleMedium),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(children: [Text('Viento', style: theme.textTheme.bodySmall), const SizedBox(height: 6), Text('${_weather!.windspeed.toStringAsFixed(1)} km/h')]),
                                      Column(children: [Text('Actualizado', style: theme.textTheme.bodySmall), const SizedBox(height: 6), Text(_weather!.time.toUtc().toIso8601String())]),
                                    ],
                                  ),
                                  const SizedBox(height: 18),
                                  ElevatedButton.icon(onPressed: _fetchWeather, icon: const Icon(Icons.refresh), label: const Text('Actualizar')),
                                  const SizedBox(height: 8),
                                  Text('Versión 1.0.0+1', style: theme.textTheme.bodySmall),
                                ],
                              ),
                            ),
                          ),
          ),
        ),
      ),
    );
  }
}
