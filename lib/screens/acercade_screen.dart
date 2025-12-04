import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AcercaDeScreen extends StatefulWidget {
  const AcercaDeScreen({super.key});

  @override
  State<AcercaDeScreen> createState() => _AcercaDeScreenState();
}

class _AcercaDeScreenState extends State<AcercaDeScreen> {
  final _reviewController = TextEditingController();
  bool _isEditing = false;
  String? _userId;
  int _rating = 0;

  @override
  void initState() {
    super.initState();
    _userId = FirebaseAuth.instance.currentUser?.uid;
  }

  Future<void> _submitOrUpdateReview() async {
    if ( _userId != null) {
      await FirebaseFirestore.instance.collection('reviews').doc(_userId).set({
        'text': _reviewController.text,
        'rating': _rating,
        'timestamp': FieldValue.serverTimestamp(),
      });

      setState(() {
        _isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('¡Gracias por tu reseña!')),
      );
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
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: Image.asset('assets/imgs/logo-cen.png'),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: Image.asset('assets/imgs/logo-fisi.png'),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: Image.asset('assets/imgs/UNMSM_escudo.png'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Universidad Nacional Mayor de San Marcos\n'
                        'Facultad de Ingeniería de Sistemas e Informática\n'
                        'Centro de Estudiantes de Ingeniería de Sistemas\n'
                        'Centro de Estudiantes de Nutrición UNMSM',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Divider(),
                SizedBox(height: 20.h),
                Text(
                  'Tu Reseña',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 12.h),
                _buildReviewSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarRating(int rating, {bool isStatic = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          onPressed: isStatic
              ? null
              : () {
                  setState(() {
                    _rating = index + 1;
                  });
                },
          icon: Icon(
            index < rating ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 32.sp,
          ),
        );
      }),
    );
  }

  Widget _buildReviewSection() {
    if (_userId == null) {
      return Center(child: Text('No se pudo identificar al usuario.'));
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('reviews').doc(_userId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final hasReview = snapshot.hasData && snapshot.data!.exists;

        if (hasReview && !_isEditing) {
          final reviewData = snapshot.data!.data() as Map<String, dynamic>;
          _reviewController.text = reviewData['text'] ?? '';
          final savedRating = reviewData['rating'] ?? 0;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStarRating(savedRating, isStatic: true),
              SizedBox(height: 12.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  _reviewController.text,
                  style: GoogleFonts.plusJakartaSans(fontSize: 14.sp),
                ),
              ),
              SizedBox(height: 12.h),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _rating = savedRating;
                    _isEditing = true;
                  });
                },
                child: Text('Editar Reseña'),
              ),
            ],
          );
        } else {
          // Load initial rating when starting to edit for the first time
          if (hasReview && _isEditing && _rating == 0) {
            final reviewData = snapshot.data!.data() as Map<String, dynamic>;
            _rating = reviewData['rating'] ?? 0;
          }
          return Column(
            children: [
              _buildStarRating(_rating),
              SizedBox(height: 12.h),
              TextField(
                controller: _reviewController,
                decoration: InputDecoration(
                  labelText: 'Escribe tu reseña',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 12.h),
              ElevatedButton(
                onPressed: _submitOrUpdateReview,
                child: Text(hasReview ? 'Guardar Cambios' : 'Enviar Reseña'),
              ),
            ],
          );
        }
      },
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