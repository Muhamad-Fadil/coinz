// import 'package:flutter/material.dart';
// import '../models/message_model.dart';
// import '../models/gemini_model.dart';

// class GeminiViewModel extends ChangeNotifier {
//   final GeminiService _service;

//   GeminiViewModel(this._service);

//   final List<ChatMessageModel> _messages = [];
//   bool _isLoading = false;
//   String _error = '';

//   List<ChatMessageModel> get messages => _messages;
//   bool get isLoading => _isLoading;
//   String get error => _error;

//   Future<void> sendMessage(String text) async {
//     if (text.isEmpty) return;

//     _messages.add(ChatMessageModel(role: ChatRole.user, message: text));
//     notifyListeners();

//     _isLoading = true;
//     _error = '';
//     notifyListeners();

//     try {
//       final response = await _service.sendMessage(text);
//       print('GeminiViewModel: received response len=${response.length}');

//       _messages.add(ChatMessageModel(role: ChatRole.bot, message: response));
//     } catch (e, st) {
//       print('GeminiViewModel error: $e\n$st');
//       _error = e.toString();
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
// }
import 'package:flutter/material.dart';
import '../models/message_model.dart';
import '../models/gemini_model.dart';

class GeminiViewModel extends ChangeNotifier {
  final GeminiService _service;

  GeminiViewModel(this._service);

  final List<ChatMessageModel> _messages = [];
  bool _isLoading = false;
  String _error = '';

  List<ChatMessageModel> get messages => _messages;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> sendMessage(String text) async {
    final prompt = text.trim();
    if (prompt.isEmpty) return;

    // user message
    _messages.add(ChatMessageModel(role: ChatRole.user, message: prompt));
    notifyListeners();

    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final reply = await _service.sendMessage(prompt);

      _messages.add(ChatMessageModel(role: ChatRole.bot, message: reply));
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
