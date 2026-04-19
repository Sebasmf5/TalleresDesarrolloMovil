import 'package:flutter/material.dart';

mixin LoggerMixin<T extends StatefulWidget> on State<T> {
  final List<String> logs = [];

  void addLog(String text, {String level = 'INFO'}) {
    if (!mounted) return;
    final entry = '${DateTime.now().toIso8601String()}  [$level]  - $text';
    setState(() {
      logs.add(entry);
    });
    // ignore: avoid_print
    print(entry);
  }
}
