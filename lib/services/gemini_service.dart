import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class GeminiService {
  late final String apiKey;

  GeminiService() {
    // Leer la API Key desde --dart-define o .env
    final fromDefine = const String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');
    if (fromDefine.isNotEmpty) {
      apiKey = fromDefine;
      print('🔑 API Key cargada desde --dart-define');
      return;
    }

    try {
      apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
      if (apiKey.isNotEmpty) {
        print('🔑 API Key cargada desde .env');
      } else {
        print('⚠️ GEMINI_API_KEY no encontrada en .env');
      }
    } catch (e) {
      print('⚠️ Error al acceder a dotenv: $e');
      apiKey = '';
    }
  }

  /// Envía una pregunta a Gemini 2.5 Flash y devuelve la respuesta de texto.
  Future<String> query(String prompt) async {
    if (apiKey.isEmpty) {
      return '⚠️ No hay API configurada. Modo local activo.';
    }

    // ✅ Usa el modelo correcto que tu API key tiene habilitado
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent?key=$apiKey',
    );

    final headers = {'Content-Type': 'application/json'};

    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": prompt}
          ]
        }
      ]
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data["candidates"]?[0]?["content"]?["parts"]?[0]?["text"];
        if (text != null && text.isNotEmpty) {
          print("✅ Respuesta de Gemini 2.5 Flash recibida correctamente.");
          return text;
        } else {
          return "⚠️ Gemini no devolvió texto. Intenta nuevamente.";
        }
      } else {
        print('❌ Error HTTP ${response.statusCode}: ${response.body}');
        final data = jsonDecode(response.body);
        final message = data["error"]?["message"] ?? "Error desconocido";
        return "❌ Error desde Gemini (${response.statusCode}): $message";
      }
    } catch (e) {
      print('⚠️ Error de conexión con Gemini: $e');
      return "⚠️ No se pudo conectar con la API de Gemini.\nDetalles: $e";
    }
  }
}
