import 'package:flutter/foundation.dart';

class AppLogger extends ChangeNotifier {
  AppLogger._internal();
  static final AppLogger instance = AppLogger._internal();

  final List<String> _logs = [];

  List<String> get logs => List.unmodifiable(_logs);

  void log(String message) {
    final entry = '[${DateTime.now().toIso8601String()}] $message';
    _logs.add(entry);
    // keep recent history only
    if (_logs.length > 500) _logs.removeAt(0);
    notifyListeners();
  }

  void clear() {
    _logs.clear();
    notifyListeners();
  }
}
