import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/chat_message.dart';
import '../services/gemini_service.dart';

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
  //int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    gemini = GeminiService();
    _cargarDocumentos();
    messages.add(ChatMessage(
      author: 'anmi',
      text:
      '¡Hola! Soy Sofía, tu asistente nutricional materno-infantil 🥗🍼 Estoy aquí para brindarte información confiable y sencilla sobre la alimentación y el cuidado nutricional de tu bebé. ¿En qué puedo ayudarte hoy?',
    ));
  }

  Future<void> _cargarDocumentos() async {
    await gemini.cargarDocumentos();
    print('Documentos cargados');
  }

  List<Map<String, String>> _construirHistorial() {
    return messages.map((m) => {
      'role': m.author == 'user' ? 'user' : 'model',
      'content': m.text,
    }).toList();
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      messages.add(ChatMessage(author: 'user', text: text.trim()));
      loading = true;
    });
    controller.clear();

    final reply = await gemini.enviarMensaje(text, _construirHistorial());
    setState(() {
      messages.add(ChatMessage(author: 'anmi', text: reply));
      loading = false;
    });
  }

  /*void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    String routeName;
    switch (index) {
      case 0:
        return;
      case 1:
        routeName = '/recursos';
        break;
      case 2:
        routeName = '/acercade';
        break;
      default:
        return;
    }
    Navigator.pushNamed(context, routeName);
    //Navigator.pushReplacementNamed(context, routeName);
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Column(
          children: [
            CircleAvatar(
              radius: 15.r,
              backgroundImage: AssetImage('assets/imgs/AnmiLogo.png'),
            ),
            SizedBox(height: 4.h),
            Text(
              'ANMI Chatbot',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Divider(height: 1.h, color: Colors.grey.shade300),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: messages.length,
              itemBuilder: (context, i) {
                final m = messages[i];
                final isUser = m.author == 'user';
                return Container(
                  margin: EdgeInsets.only(bottom: 16.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment:
                    isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      if (!isUser) ...[
                        CircleAvatar(
                          radius: 20.r,
                          backgroundImage: AssetImage('assets/imgs/sofia_avatar.png'),
                        ),
                        SizedBox(width: 8.w),
                      ],
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: isUser ? Color(0xFF1ebd46) : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            m.text,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: isUser ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      if (!isUser) ...[
                        SizedBox(width: 8.w),
                        Icon(
                          Icons.content_copy,
                          size: 20.sp,
                          color: Colors.grey.shade400,
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
          if (loading) LinearProgressIndicator(color: Color(0xFF1ebd46)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      style: GoogleFonts.plusJakartaSans(fontSize: 14.sp),
                      decoration: InputDecoration(
                        hintText: 'Escríbele a Sofía...',
                        hintStyle: GoogleFonts.plusJakartaSans(
                          fontSize: 14.sp,
                          color: Colors.grey.shade500,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.r),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                      ),
                      onSubmitted: sendMessage,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  CircleAvatar(
                    radius: 24.r,
                    backgroundColor: Color(0xFF1ebd46),
                    child: IconButton(
                      icon: Icon(Icons.send, color: Colors.white, size: 20.sp),
                      onPressed: () => sendMessage(controller.text),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      /*bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Color(0xFF1ebd46),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: GoogleFonts.plusJakartaSans(fontSize: 12.sp),
        unselectedLabelStyle: GoogleFonts.plusJakartaSans(fontSize: 12.sp),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat, size: 24.sp),
            label: 'Chatbot',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book, size: 24.sp),
            label: 'Recursos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info, size: 24.sp),
            label: 'Acerca de',
          ),
        ],
      ),*/
    );
  }
}