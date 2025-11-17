import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chat_screen.dart';
import 'main_tabs.dart';
import 'package:shared_preferences/shared_preferences.dart';



class ConsentScreen extends StatefulWidget {
  const ConsentScreen({super.key});

  @override
  State<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  Future<void> aprobarConsentimiento() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('consentAccepted', true);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainTabs()),
    );
  }

  bool accepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            SizedBox(height: 65.h), //Responsive
            SizedBox(
              height: 120.h, //Responsive
              width: 120.w,  //Responsive
              child: Image.asset('assets/imgs/AnmiLogo.png'),
            ),
            SizedBox(height: 0.04.sh),
            Container(
              width: 250.w,
              child: Text(
                'Asistente Nutricional Materno Infantil',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20.sp,

                  fontWeight: FontWeight.w600,
                    color: Color(0xFF6d6c73)
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 0.02.sh),
            Text(
              'Política de privacidad',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 30.sp,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1f1c2e)
              ),
            ),
            Divider(
              height: 20,       //Altura del espacio
              thickness: 1,     //Grosor de la línea
              color: Color(0xFF6d6c73),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    Text(
                      'ANMI es una herramienta educativa que proporciona información sobre nutrición infantil basada en fuentes oficiales del MINSA Perú y la OMS',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20.h),
                    Text.rich(
                      TextSpan(
                        children: [
                          //1° punto
                          TextSpan(
                            text: '1. No recopilamos tus datos personales\n\n',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1f1c2e),
                            ),
                          ),
                          TextSpan(
                            text: 'ANMI NO solicita ni guarda información personal que pueda identificarte, como nombre, dirección, correo electrónico o número de teléfono. Solo usamos un identificador anónimo en tu dispositivo para registrar que aceptaste esta política. Esto nos ayuda únicamente a recordar tu aceptación, nada más.\n\n',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1f1c2e),
                            ),
                          ),

                          //2° punto
                          TextSpan(
                            text: '2. Información educativa y segura\n\n',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1f1c2e),
                            ),
                          ),
                          TextSpan(
                            text: 'Toda la información que ANMI proporciona es educativa, destinada a enseñarte sobre nutrición infantil y prevención de anemia en bebés de 6 a 12 meses. No personalizamos respuestas basadas en tus datos, ni almacenamos lo que preguntas en la app\n\n',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1f1c2e),
                            ),
                          ),

                          //3° punto
                          TextSpan(
                            text: '3. Tus datos permanecen en tu dispositivo\n\n',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1f1c2e),
                            ),
                          ),
                          TextSpan(
                            text: 'ANMI no envía tus datos a servidores ni comparte información con terceros. Toda la información que se usa para el funcionamiento de la app se queda dentro de tu propio dispositivo.\n\n',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1f1c2e),
                            ),
                          ),
                          //4° punto
                          TextSpan(
                            text: '4. Exención de responsabilidad médica\n\n',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1f1c2e),
                            ),
                          ),
                          TextSpan(
                            text: 'La información que encuentres en ANMI no sustituye la atención médica profesional. Siempre consulta a un especialista en salud infantil o nutrición antes de aplicar cambios en la dieta de tu hijo.\n\n',
                            style: GoogleFonts.plusJakartaSans(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1f1c2e),
                            ),
                          ),
                          //5° punto
                          TextSpan(
                            text: '5. Privacidad y control\n\n',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1f1c2e),
                            ),
                          ),
                          TextSpan(
                            text: 'Tú controlas tu información: si borras la app, todos los datos asociados se eliminan automáticamente. No hay forma de que otros accedan a tu información desde fuera de tu dispositivo.\n\n',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1f1c2e),
                            ),
                          ),

                          //6° punto
                          TextSpan(
                            text: '6. Actualizaciones de la política\n\n',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1f1c2e),
                            ),
                          ),
                          TextSpan(
                            text: 'Esta política puede actualizarse para mejorar la app, cumplir normas legales o añadir funcionalidades, siempre sin recopilar información personal. Te informaremos de cualquier cambio importante.\n\n',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1f1c2e),
                            ),
                          ),

                          //7° punto
                          TextSpan(
                            text: '7. Seguridad de la información\n\n',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1f1c2e),
                            ),
                          ),
                          TextSpan(
                            text: 'Aunque ANMI no almacena información personal, la app protege el identificador anónimo de tu dispositivo para que nadie más pueda usarlo.\n\n',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1f1c2e),
                            ),
                          ),

                        ],
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Checkbox(
                  value: accepted,
                  onChanged: (v) => setState(() => accepted = v ?? false),
                ),
                Expanded(
                  child:
                    Text(
                    'Acepto que ANMI use mis datos para ofrecer información educativa.',
                     style: GoogleFonts.plusJakartaSans(
                       fontSize: 12.sp,
                       fontWeight: FontWeight.w700,
                     ),

                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1ebd46),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                fixedSize: Size(500.w, 60.h),
              ),
              /*
              SI QUIERES VOLVER A VER LA PANTALLA , DESCOMENTA ESTO Y COMENTA LA FUNCION SIGUIENTE
              onPressed: accepted
                  ? () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const ChatScreen()),
              )
                  : null,*/
              onPressed: accepted ? aprobarConsentimiento : null,


              child: Text(
                'Acepto',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}