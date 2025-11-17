import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AcercaDeScreen extends StatefulWidget {
  const AcercaDeScreen({super.key});

  @override
  State<AcercaDeScreen> createState() => _AcercaDeScreenState();
}

class _AcercaDeScreenState extends State<AcercaDeScreen> {
  /*int _selectedIndex = 2;

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    String routeName;
    switch (index) {
      case 0:
        routeName = '/chat';
        break;
      case 1:
        routeName = '/recursos';
        break;
      case 2:
        return;
      default:
        return;
    }

    Navigator.pushReplacementNamed(context, routeName);
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
              'Acerca de',
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
            child: ListView(
              padding: EdgeInsets.all(16.w),
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 60.r,
                    backgroundImage: AssetImage('assets/imgs/AnmiLogo.png'),
                  ),
                ),
                SizedBox(height: 24.h),
                _buildSection(
                  icon: Icons.people,
                  title: 'Nuestro propósito',
                  description:
                  'ANMI es un proyecto de Responsabilidad Social Universitaria desarrollado como parte del curso de Ética y Derecho Informático. Nuestro objetivo es combatir la anemia infantil mediante el acceso a información confiable sobre nutrición.',
                ),
                SizedBox(height: 20.h),
                _buildSection(
                  icon: Icons.book,
                  title: 'Alcance del proyecto',
                  description:
                  'Esta app proporciona información educativa sobre:\n• Prevención de anemia infantil\n• Alimentos ricos en hierro para bebés de 6–23 meses y más\n• Preparación segura de alimentos nutritivos\n• Importancia de la lactancia materna\n• Pautas nutricionales generales, etc.',
                ),
                SizedBox(height: 20.h),
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.warning,
                        color: Colors.red.shade700,
                        size: 24.sp,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tenga en cuenta',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.red.shade700,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'ANMI no proporciona diagnósticos médicos ni dietas personalizadas. La información ofrecida es de carácter general y educativo. Para consultas específicas, acuda a un especialista.',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.red.shade900,
                              ),
                            ),
                          ],
                        ),

                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'En colaboración con: ',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),

                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12.r),

                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // LOGO A LA IZQUIERDA
                      SizedBox(
                        height: 80.h,
                        width: 80.w,
                        child: Image.asset('assets/imgs/UNMSM_escudo.png'),
                      ),

                      SizedBox(width: 12.w),

                      // TEXTO A LA DERECHA
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Universidad Nacional Mayor de San Marcos\n'
                                  'Facultad de Ingeniería de Sistemas e Informática',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20.h),
              ],

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

  Widget _buildSection({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Color(0xFF1ebd46).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Color(0xFF1ebd46),
            size: 24.sp,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                description,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}