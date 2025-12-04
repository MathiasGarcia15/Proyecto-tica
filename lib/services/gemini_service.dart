import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  late final String apiKey;

  // Listas para almacenar los 4 JSON
  List<Map<String, dynamic>> recetasNutritivas = [];
  List<Map<String, dynamic>> guiasMinsa = [];
  List<Map<String, dynamic>> guiasPoblacion = [];
  List<Map<String, dynamic>> recetasAnemia = [];

  bool _documentosCargados = false;

  GeminiService() {
    final fromDefine = const String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');
    if (fromDefine.isNotEmpty) {
      apiKey = fromDefine;
      print('API Key cargada desde --dart-define');
      return;
    }

    try {
      apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
      if (apiKey.isNotEmpty) {
        print('API Key cargada desde .env');
      } else {
        print('GEMINI_API_KEY no encontrada en .env');
      }
    } catch (e) {
      print('Error al acceder a dotenv: $e');
      apiKey = '';
    }
  }

  // Cargar los 4 JSON desde assets
  Future<void> cargarDocumentos() async {
    if (_documentosCargados) return;

    try {
      final recetasJson = await rootBundle.loadString('assets/data/Recetario_nutritivo_para_niños_de_seis_a_veintitres_meses.json');
      final minsaJson = await rootBundle.loadString('assets/data/Guia_alimentacion_infantil_Minsa.json');
      final poblacionJson = await rootBundle.loadString('assets/data/Guia_alimentacion_poblacion_mayor2anios.json');
      final anemiaJson = await rootBundle.loadString('assets/data/Recetarios_anemia.json');

      recetasNutritivas = List<Map<String, dynamic>>.from(jsonDecode(recetasJson));
      guiasMinsa = List<Map<String, dynamic>>.from(jsonDecode(minsaJson));
      guiasPoblacion = List<Map<String, dynamic>>.from(jsonDecode(poblacionJson));
      recetasAnemia = List<Map<String, dynamic>>.from(jsonDecode(anemiaJson));

      _documentosCargados = true;
      final total = recetasNutritivas.length + guiasMinsa.length + guiasPoblacion.length + recetasAnemia.length;
      print('Documentos cargados: $total elementos');
    } catch (e) {
      print('Error al cargar documentos: $e');
      throw Exception('No se pudieron cargar los documentos base');
    }
  }

  // Prompt del sistema con la personalidad de Sofía
    final String promptSistema = '''
  Eres Sofía, nutricionista peruana experta en alimentación infantil y anemia infantil. Hablas con total formalidad y no uses jergas(No lo trate como si fuera un niño).
  
  PERSONALIDAD:
  - Cálida, empática, práctica
  - Ejemplos cotidianos peruanos, algunas palabras peruanas (si gustas)
  
  ESTILO:
   "Según MINSA (osea cita la fuente)"
   "A los 6 meses empieza con papillas. Te explico..."
   "Nunca uses diminutivos"
   "Receta: Ingredientes: 1 puñado..."
   "El pure verde es fácil: habitas, papa y leche. Tiene buen hierro"
   
  REGLAS:
  -Si es necesario te identificaras como asistente nutricionista
  -Si te brindan un nivel de hemogoblina ten en cuenta esto
  Normal	11.0 g/dL o más:Si esta bien si esta bien alimentado
 Anemia Leve	10.0 - 10.9 g/dL El niño no corre peligro inmediato, pero su desarrollo cerebral está en riesgo a largo plazo si no se corrige. Acción: Consulta externa (Cita médica normal).
 Anemia Moderada	7.0 - 9.9 g/dL El niño ya presenta síntomas físicos (cansancio, palidez, falta de apetito) y su sistema inmune está débil. Acción: Consulta Médica Prioritaria (No esperar semanas).
 Anemia GRAVE (Severa)	Menos de 7.0 g/dL Estado crítico. El corazón del niño está sufriendo para bombear oxígeno. Hay riesgo de descompensación cardíaca. Acción: IR A EMERGENCIA / URGENCIAS AHORA MISMO.
  - Si el paciente es mayor a 5 años redirige amablemente
  - Si tienes diagnostico o respuesta no cambies de parecer en tu siguiente respuesta
  - Basa respuestas EN LOS DOCUMENTOS principalmente
  - Explica con tus palabras, NO copies textual
  - Sin info suficiente: "Consulta con tu pediatra o especialista en el área"
  - NUNCA diagnostiques ni recetes medicamentos salvo sea necesario por ejemplo te dan un indice de anemia severa,hemoglobina,etc
  - Temas fuera de nutrición infantil: redirige amablemente
  - Máximo 5-6 líneas, salvo haya una receta que necesite más
  - Si la pregunta es muy larga, dile que resuma
  - Si te pregunta por "recetas", no necesariamente son recetas medicas, si no las recetas de comida que hay en los documentos,preguntale por si las dudas
  
  Eres amiga nutricionista, no manual médico.
  ''';

  // Metodo principal para enviar mensaje con RAG
  Future<String> enviarMensaje(String pregunta, List<Map<String, String>> historial) async {
    print('1. Iniciando enviarMensaje con pregunta: $pregunta');

    if (apiKey.isEmpty) {
      return 'No hay API configurada.';
    }

    print('2. API Key OK');

    if (!_documentosCargados) {
      print('3. Cargando documentos...');
      await cargarDocumentos();
      print('4. Documentos cargados');
    }

    print('5. Buscando contexto...');
    List<String> contextosRelevantes = _buscarEnTodosLosDocumentos(pregunta);
    print('6. Contextos encontrados: ${contextosRelevantes.length}');

    print('7. Construyendo prompt...');
    String promptCompleto = _construirPromptNatural(pregunta, contextosRelevantes);
    print('8. Prompt construido, longitud: ${promptCompleto.length} caracteres');

    print('9. Llamando a Gemini...');
    final respuesta = await _llamarGemini(promptCompleto, historial);
    print('10. Respuesta recibida');

    return respuesta;
  }

  // Buscar en todos los documentos
  List<String> _buscarEnTodosLosDocumentos(String pregunta) {
    List<Map<String, dynamic>> todosLosDocumentos = [
      ...recetasNutritivas,
      ...guiasMinsa,
      ...guiasPoblacion,
      ...recetasAnemia,
    ];

    List<MapEntry<Map<String, dynamic>, int>> documentosConScore = [];
    String preguntaLower = pregunta.toLowerCase();

    Set<String> palabrasClave = preguntaLower
        .split(RegExp(r'\s+'))
        .where((p) => p.length > 3)
        .toSet();

    for (var doc in todosLosDocumentos) {
      int score = 0;
      String textoDoc = '${doc['tema']} ${doc['texto']}'.toLowerCase();

      for (var palabra in palabrasClave) {
        if (textoDoc.contains(palabra)) {
          score += 2;
        }
      }

      if (doc['tema'] != null &&
          palabrasClave.any((p) => doc['tema'].toString().toLowerCase().contains(p))) {
        score += 5;
      }

      if (score > 0) {
        documentosConScore.add(MapEntry(doc, score));
      }
    }

    documentosConScore.sort((a, b) => b.value.compareTo(a.value));

    return documentosConScore
        .take(2)
        .map((entry) => '${entry.key['tema']}: ${entry.key['texto']}')
        .toList();
  }

  String _construirPromptNatural(String pregunta, List<String> contextos) {
    String infoBase = contextos.isEmpty
        ? 'Sin info en documentos.'
        : contextos.join('\n\n---\n\n');

    return '''
$promptSistema

CONTEXTO:
$infoBase

PREGUNTA: "$pregunta"

Responde en máximo 5 líneas, sé amable siempre
''';
  }

  Future<String> _llamarGemini(String prompt, List<Map<String, String>> historial) async {
    try {
      List<Map<String, dynamic>> contents = [];

      int inicio = historial.length > 4 ? historial.length - 4 : 0;
      for (int i = inicio; i < historial.length; i++) {
        contents.add({
          'role': historial[i]['role'] == 'user' ? 'user' : 'model',
          'parts': [{'text': historial[i]['content']}]
        });
      }

      contents.add({
        'role': 'user',
        'parts': [{'text': prompt}]
      });

      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent?key=$apiKey',
      );

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': contents,
          'generationConfig': {
            'temperature': 0.9,
            'topP': 0.95,
            'topK': 40,
            'maxOutputTokens': 2048,
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        //Para debuguear
        print('DEBUG - Response completo: ${response.body}');
        print('DEBUG - Data: $data');
        print('DEBUG - Candidates: ${data['candidates']}');


        final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'];

        //Mas debug

        print('DEBUG - Text extraído: $text');
        print('DEBUG - Text es null?: ${text == null}');
        print('DEBUG - Text está vacío?: ${text?.isEmpty}');

        if (text != null && text.isNotEmpty) {
          return text;
        } else {
          return 'Gemini no devolvió texto. Intenta nuevamente.';
        }
      } else {
        print('Error HTTP ${response.statusCode}: ${response.body}');
        final data = jsonDecode(response.body);
        final message = data['error']?['message'] ?? 'Error desconocido';
        return 'Error desde Gemini (${response.statusCode}): $message';
      }
    } catch (e) {
      print('Error de conexión con Gemini: $e');
      return 'No se pudo conectar con la API de Gemini.\nDetalles: $e';
    }
  }

  // Metodo legacy para compatibilidad
  Future<String> query(String prompt) async {
    return await enviarMensaje(prompt, []);
  }
}