import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'screens/welcome_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/recursos_screen.dart';
import 'screens/acercade_screen.dart';
import 'screens/main_tabs.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    print("Directorio actual (desde Flutter): ${Directory.current.path}");
    await dotenv.load(fileName: ".env");
    print("Archivo .env cargado correctamente");
  } catch (e) {
    print("Error al cargar .env: $e");
  }

  runApp(const AnmiApp());
}

class AnmiApp extends StatelessWidget {
  const AnmiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'ANMI',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: Colors.teal),
          //home: const WelcomeScreen(),
          home: FutureBuilder(
            future: SharedPreferences.getInstance(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return SizedBox();

              final prefs = snapshot.data!;
              final accepted = prefs.getBool('consentAccepted') ?? false;

              if (accepted) {
                return const MainTabs();
              } else {
                return const WelcomeScreen();
              }
            },
          ),
          routes: {
            '/main': (context) => const MainTabs(),
            '/chat': (context) => const ChatScreen(),
            '/recursos': (context) => const RecursosScreen(),
            '/acercade': (context) => const AcercaDeScreen(),
          },
        );
      },
    );
  }
}