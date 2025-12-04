import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class RecursosScreen extends StatefulWidget {
  const RecursosScreen({super.key});

  @override
  State<RecursosScreen> createState() => _RecursosScreenState();
}

class _RecursosScreenState extends State<RecursosScreen> {
  /*int _selectedIndex = 1;

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    String routeName;
    switch (index) {
      case 0:
        routeName = '/chat';
        break;
      case 1:
        return;
      case 2:
        routeName = '/acercade';
        break;
      default:
        return;
    }

    Navigator.pushReplacementNamed(context, routeName);
  }*/

  Future<void> _launchURL(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se pudo abrir el enlace')),
          );
        }
      }
    } catch (e) {
      print('Error al abrir el link: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al abrir el link: $e')),
        );
      }
    }
  }

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
              backgroundImage: const AssetImage('assets/imgs/AnmiLogo.png'),
            ),
            SizedBox(height: 4.h),
            Text(
              'Recursos',
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
                _buildRecursoCard(
                  title: 'Norma Técnica de Salud: Prevención y control de la anemia - MINSA',
                  description:
                  'Norma oficial del Ministerio de Salud para la prevención y control de la anemia por deficiencia de hierro en niños, adolescentes, mujeres en edad fértil, gestantes y puérperas.',
                  icon: Icons.health_and_safety,
                  url: 'https://www.gob.pe/institucion/minsa/normas-legales/5440166-251-2024-minsa',
                ),
                SizedBox(height: 16.h),
                _buildRecursoCard(
                  title: 'Guía de alimentación infantil - MINSA',
                  description:
                  'Recomendaciones oficiales del Ministerio de Salud(MINSA) sobre alimentación complementaria y prevencio de la anemia.',
                  icon: Icons.menu_book,
                  url: 'https://cdn.www.gob.pe/uploads/document/file/3287949/Gu%C3%ADas%20alimentarias%20para%20ni%C3%B1as%20y%20ni%C3%B1os%20menores%20de%202%20a%C3%B1os%20de%20edad.pdf?v=1655937897',
                ),
                SizedBox(height: 16.h),
                _buildRecursoCard(
                  title: 'Programa "CUNA MÁS" - Recetas para prevenir la anemia',
                  description:
                  'Se presenta una variedad de recetas elaboradas con alimentos de origen animal ricos en hierro, que ayudarán a nuestras niñas y niños a crecer sanos, inteligentes, felices y sin anemia.',
                  icon: Icons.menu_book,
                  url: 'https://cdn.www.gob.pe/uploads/document/file/286056/minirecetario.pdf?v=1547600928',
                ),
                SizedBox(height: 16.h),
                _buildRecursoCard(
                  title: 'MINSA - Minirecetario para la prevención de anemia en niños y niñas',
                  description:
                  'Una destacada selección de recetas que buscan evitar la anemia en menores de edad.',
                  icon: Icons.menu_book,
                  url: 'https://cdn.www.gob.pe/uploads/document/file/286055/6.-Recetario-ni%C3%B1os.pdf?v=1547600619',
                ),
                SizedBox(height: 16.h),
                _buildRecursoCard(
                  title: 'Guías alimentarias para la población peruana',
                  description:
                  'Describe los principios claves sobre alimentación saludable con la finalidad de orientar a los peruanos sobre temas relacionados a la alimentación y nutrición.',
                  icon: Icons.menu_book,
                  url: 'https://cdn.www.gob.pe/uploads/document/file/382657/Gu%C3%ADas_alimentarias_para_la_poblaci%C3%B3n_peruana20191011-25586-aziozx.pdf?v=1605196509',
                ),
                SizedBox(height: 16.h),
                _buildRecursoCard(
                  title:'Recetario nutritivo para niñas y niños de 6 a 23 meses' ,
                  description: 'Es preciso añadir otros alimentos a la dieta de un niño cuando la lactancia natural ya no basta, se brindan más de 80 recetas además de la suplementación con micronutrientes de cada una.',
                  icon: Icons.menu_book,
                  url: 'https://cdn.www.gob.pe/uploads/document/file/4114920/CENAN-0005.pdf.pdf?v=1676302740',
                ),
              ],
            ),
          ),
        ],
      ),
      /*bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF1ebd46),
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

  Widget _buildRecursoCard({
    required String title,
    required String description,
    required IconData icon,
    required String url,
  }) {
    return GestureDetector(
      onTap: () => _launchURL(url),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: const Color(0xFF1ebd46).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: const Color(0xFF1ebd46),
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
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
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
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Icon(
              Icons.open_in_new,
              color: const Color(0xFF1ebd46),
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }
}