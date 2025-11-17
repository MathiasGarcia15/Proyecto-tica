import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; //Esto sirve para hacer el sistema responsive
import 'package:google_fonts/google_fonts.dart';
import 'consentimiento_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: EdgeInsets.all(16.w), //Responsive
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 65.h), //Responsive
            SizedBox(
              height: 310.h, //Responsive
              width: 310.w,  //Responsive
              child: Image.asset('assets/imgs/fondo_inicial.png'),
            ),
            SizedBox(height: 10.h), //Responsive
            Text(
              'Tu aplicación de apoyo nutricional materno-infantil',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 28.sp, //Responsive
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h), //Responsive
            Text(
              'Bienvenido a ANMI!',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6d6c73)
              )
            ),
            const Spacer(),
            SizedBox(
              height: 100.h, //Responsive
              width: 100.w,  //Responsive
              child: Image.asset('assets/imgs/AnmiLogo.png'),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1ebd46),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                  fixedSize: Size(500.w, 60.h),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h), // ← Responsive
                child: Text(
                  'Siguiente',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20.sp, //Responsive
                    fontWeight: FontWeight.w800,
                  ), //Responsive
                ),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ConsentScreen()),
              ),
            ),
            SizedBox(height: 20.h), //Responsive
          ],
        ),
      ),
    );
  }
}