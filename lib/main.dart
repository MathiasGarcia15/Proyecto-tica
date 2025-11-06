import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'models/chat_message.dart';
import 'services/gemini_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Solo mostramos la ruta, sin listar el contenido
    print("📂 Directorio actual (desde Flutter): ${Directory.current.path}");

    await dotenv.load(fileName: ".env");
    print("✅ Archivo .env cargado correctamente");
  } catch (e) {
    print("❌ Error al cargar .env: $e");
  }

  runApp(const AnmiApp());
}

class AnmiApp extends StatelessWidget {
  const AnmiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ANMI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ANMI')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'ANMI - Asistente Nutricional Materno Infantil',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Información educativa sobre nutrición para prevenir la anemia. '
              'No sustituye a un profesional de la salud.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              child: const Text('Comenzar'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ConsentScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConsentScreen extends StatefulWidget {
  const ConsentScreen({super.key});

  @override
  State<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  bool accepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consentimiento informado')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: const Text(
                  'Antes de usar ANMI, por favor lee y acepta el consentimiento.\n\n'
                  'Recolectaremos solo datos mínimos (edad del bebé, alergias, etapa de lactancia) '
                  'y los usaremos para ofrecer información educativa. '
                  'No se proporcionan diagnósticos médicos. Puedes borrar tus datos en cualquier momento.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            Row(
              children: [
                Checkbox(
                  value: accepted,
                  onChanged: (v) => setState(() => accepted = v ?? false),
                ),
                const Expanded(
                  child: Text(
                    'Acepto que ANMI use mis datos para ofrecer información educativa.',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: accepted
                  ? () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const ChatScreen()),
                      )
                  : null,
              child: const Text('Continuar'),
            )
          ],
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> messages = [];
  final TextEditingController controller = TextEditingController();
  late final GeminiService gemini;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    gemini = GeminiService();
    messages.add(ChatMessage(
      author: 'anmi',
      text:
          'Hola! Soy ANMI. ¿En qué puedo ayudarte hoy? (Recuerda que no sustituyo a un profesional de salud)',
    ));
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      messages.add(ChatMessage(author: 'user', text: text.trim()));
      loading = true;
    });
    controller.clear();

    final reply = await gemini.query(text);
    setState(() {
      messages.add(ChatMessage(author: 'anmi', text: reply));
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ANMI - Chat')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, i) {
                final m = messages[i];
                final isUser = m.author == 'user';
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Card(
                    color: isUser ? Colors.teal.shade50 : Colors.grey.shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(m.text),
                    ),
                  ),
                );
              },
            ),
          ),
          if (loading) const LinearProgressIndicator(),
          SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'Escribe tu pregunta...',
                    ),
                    onSubmitted: sendMessage,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => sendMessage(controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
