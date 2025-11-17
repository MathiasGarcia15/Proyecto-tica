import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'recursos_screen.dart';
import 'acercade_screen.dart';

class MainTabs extends StatefulWidget {
  const MainTabs({super.key});

  @override
  State<MainTabs> createState() => _MainTabsState();
}

class _MainTabsState extends State<MainTabs> {
  int index = 0;

  final screens = const [
    ChatScreen(),
    RecursosScreen(),
    AcercaDeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: index,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        selectedItemColor: const Color(0xFF1ebd46),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chatbot'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Recursos'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Acerca de'),
        ],
      ),
    );
  }
}
