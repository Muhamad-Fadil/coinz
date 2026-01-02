import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final String apiKey;
  GenerativeModel? _model;

  GeminiService([String? key]) : apiKey = key ?? (dotenv.env['API_KEY'] ?? '') {
    final display = apiKey.isEmpty ? 'EMPTY' : 'loaded';
    print('GeminiService: apiKey $display (len=${apiKey.length})');
    if (apiKey.isEmpty) {
      // do not throw here; allow app to run and surface errors when sending
      print('GeminiService warning: API_KEY kosong');
    }
  }

  GenerativeModel _getModel() {
    _model ??= GenerativeModel(model: 'gemini-2.5-flash', apiKey: apiKey);
    return _model!;
  }

  Future<String> sendMessage(String message) async {
    if (apiKey.isEmpty) {
      throw Exception('API key is empty; set API_KEY in .env');
    }

    try {
      print('GeminiService: sending message (len=${message.length})');
      final model = _getModel();
      final response = await model.generateContent([Content.text(message)]);
      print('GeminiService: raw response => $response');

      final respText = response.text ?? '';
      if (respText.isEmpty) {
        print('GeminiService: response text empty');
        return 'Tidak ada respon (kosong)';
      }
      return respText;
    } catch (e, st) {
      print('GeminiService error: $e\n$st');
      throw Exception('GeminiService error: $e');
    }
  }
}
