import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final String apiKey;
  GenerativeModel? _model;

  GeminiService([String? key])
      : apiKey = key ?? (dotenv.env['API_KEY'] ?? '') {
    if (apiKey.isEmpty) {
      print('⚠️ GeminiService: API_KEY kosong');
    } else {
      print('✅ GeminiService: API_KEY loaded (${apiKey.length} chars)');
    }
  }

  GenerativeModel _getModel() {
    _model ??= GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
    );
    return _model!;
  }

  Future<String> sendMessage(String message) async {
    if (apiKey.isEmpty) {
      throw Exception('API_KEY belum diset di .env');
    }

    final response =
        await _getModel().generateContent([Content.text(message)]);

    return response.text ?? 'Tidak ada respon';
  }
}
