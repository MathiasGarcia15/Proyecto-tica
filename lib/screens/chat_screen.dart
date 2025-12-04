import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/chat_message.dart';
import '../services/gemini_service.dart';

class ChatSession {
  String id;
  String title;
  List<ChatMessage> messages;

  ChatSession({required this.id, required this.title, required this.messages});

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    return ChatSession(
      id: json['id'],
      title: json['title'],
      messages: (json['messages'] as List)
          .map((item) => ChatMessage.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'messages': messages.map((m) => m.toJson()).toList(),
    };
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  late final GeminiService _gemini;
  bool _loading = false;

  List<ChatSession> _chatSessions = [];
  String? _activeChatId;

  @override
  void initState() {
    super.initState();
    _gemini = GeminiService();
    _gemini.cargarDocumentos();
    _loadChats();
  }

  ChatSession get _activeChat {
    if (_activeChatId == null ||
        _chatSessions.every((c) => c.id != _activeChatId)) {
      if (_chatSessions.isNotEmpty) {
        _activeChatId = _chatSessions.first.id;
      }
    }
    return _chatSessions.firstWhere((c) => c.id == _activeChatId,
        orElse: () => ChatSession(id: '-', title: 'Error', messages: []));
  }

  Future<void> _loadChats() async {
    final prefs = await SharedPreferences.getInstance();
    final chatData = prefs.getStringList('chat_history') ?? [];

    if (chatData.isEmpty) {
      _createNewChat();
    } else {
      setState(() {
        _chatSessions = chatData
            .map((data) => ChatSession.fromJson(json.decode(data)))
            .toList();
        _activeChatId = prefs.getString('active_chat_id') ?? _chatSessions.first.id;
      });
    }
  }

  Future<void> _saveChats() async {
    final prefs = await SharedPreferences.getInstance();
    final chatData = _chatSessions.map((c) => json.encode(c.toJson())).toList();
    await prefs.setStringList('chat_history', chatData);
    await prefs.setString('active_chat_id', _activeChatId!);
  }

  void _createNewChat() {
    if (_chatSessions.length >= 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Has alcanzado el límite de 4 chats.')),
      );
      return;
    }
    setState(() {
      final newId = Uuid().v4();
      final newChat = ChatSession(
        id: newId,
        title: 'Chat ${_chatSessions.length + 1}',
        messages: [
          ChatMessage(
            author: 'anmi',
            text:'¡Hola! Soy Sofía, tu asistente nutricional materno-infantil 🥗🍼 Estoy aquí para brindarte información confiable y sencilla sobre la alimentación y el cuidado nutricional de tu bebé. ¿En qué puedo ayudarte hoy?',
          )
        ],
      );
      _chatSessions.add(newChat);
      _activeChatId = newId;
    });
    _saveChats();
  }

  void _switchChat(String id) {
    setState(() {
      _activeChatId = id;
    });
    _saveChats();
    Navigator.of(context).pop(); // Close drawer
  }

  void _deleteChat(String id) {
    if (_chatSessions.length <= 1) {
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No puedes eliminar el único chat existente.')),
      );
      return;
    }

    setState(() {
      _chatSessions.removeWhere((c) => c.id == id);
      if (_activeChatId == id) {
        _activeChatId = _chatSessions.first.id;
      }
    });
    _saveChats();
  }

  Future<void> _editChatTitle(ChatSession chat) async {
    final newTitleController = TextEditingController(text: chat.title);
    final newTitle = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Editar nombre del chat'),
        content: TextField(
          controller: newTitleController,
          autofocus: true,
          decoration: InputDecoration(hintText: 'Nuevo nombre'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(newTitleController.text);
            },
            child: Text('Guardar'),
          ),
        ],
      ),
    );

    if (newTitle != null && newTitle.isNotEmpty) {
      setState(() {
        chat.title = newTitle;
      });
      _saveChats();
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessage(author: 'user', text: text.trim());

    setState(() {
      _activeChat.messages.add(userMessage);
      _loading = true;
    });
    _controller.clear();
    await _saveChats();

    final history = _activeChat.messages
        .map((m) => {
              'role': m.author == 'user' ? 'user' : 'model',
              'content': m.text
            })
        .toList();

    final reply = await _gemini.enviarMensaje(text, history);
    final botMessage = ChatMessage(author: 'anmi', text: reply);

    setState(() {
      _activeChat.messages.add(botMessage);
      _loading = false;
    });
    await _saveChats();
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mensaje copiado al portapapeles')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Column(
          children: [
            CircleAvatar(
              radius: 15.r,
              backgroundImage: AssetImage('assets/imgs/AnmiLogo.png'),
            ),
            SizedBox(height: 4.h),
            Text(
              _activeChat.title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      drawer: _buildDrawer(),
      body: Column(
        children: [
          Divider(height: 1.h, color: Colors.grey.shade300),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: _activeChat.messages.length,
              itemBuilder: (context, i) {
                final m = _activeChat.messages[i];
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
                        InkWell(
                          onTap: () => _copyToClipboard(m.text),
                          borderRadius: BorderRadius.circular(20.r),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(
                              Icons.content_copy,
                              size: 20.sp,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
          if (_loading) LinearProgressIndicator(color: Color(0xFF1ebd46)),
          _buildTextInput(),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF1ebd46),
            ),
            child: Text(
              'Historial de Chats',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Nuevo Chat'),
            onTap: _createNewChat,
          ),
          Divider(),
          ..._chatSessions.map((chat) => ListTile(
            title: Text(chat.title),
            selected: chat.id == _activeChatId,
            onTap: () => _switchChat(chat.id),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.grey.shade600),
                  onPressed: () => _editChatTitle(chat),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.red.shade300),
                  onPressed: () => _deleteChat(chat.id),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildTextInput() {
    return Container(
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
                controller: _controller,
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
                onPressed: () => sendMessage(_controller.text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
