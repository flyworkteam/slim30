import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class WorkoutDayCompleteView extends StatelessWidget {
  const WorkoutDayCompleteView({super.key});

  @override
  Widget build(BuildContext context) {
    final copy = _WorkoutDayCompleteCopy.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: 390.w,
          height: 844.h,
          child: SafeArea(
            bottom: false,
            child: Stack(
              children: [
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(
                      painter: _WorkoutCompletionConfettiPainter(),
                    ),
                  ),
                ),
                Positioned(
                  left: 24.w,
                  top: 57.h,
                  child: Semantics(
                    label: MaterialLocalizations.of(context).backButtonTooltip,
                    button: true,
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      borderRadius: BorderRadius.circular(20.r),
                      child: Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFF3F3F3),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 22.w,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 24.w,
                  right: 24.w,
                  top: 190.h,
                  child: Container(
                    height: 430.h,
                    padding: EdgeInsets.symmetric(
                      horizontal: 28.w,
                      vertical: 48.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2FFF6),
                      borderRadius: BorderRadius.circular(30.r),
                      border: Border.all(color: const Color(0xFFE2F1E7)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(28, 41, 33, 0.04),
                          blurRadius: 16,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 124.w,
                          height: 124.w,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF33E164),
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.check_rounded,
                            size: 82.w,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 62.h),
                        Text(
                          copy.title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.leagueSpartan(
                            fontSize: 42.sp,
                            fontWeight: FontWeight.w700,
                            height: 0.92,
                            letterSpacing: -0.7,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 18.h),
                        Text(
                          copy.subtitle,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.leagueSpartan(
                            fontSize: 26.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.08,
                            letterSpacing: -0.35,
                            color: const Color(0xFF434343),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 8.h,
                  child: Center(
                    child: Container(
                      width: 144.w,
                      height: 5.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D0D0D),
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WorkoutDayCompleteCopy {
  const _WorkoutDayCompleteCopy({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  static _WorkoutDayCompleteCopy of(BuildContext context) {
    switch (Localizations.localeOf(context).languageCode) {
      case 'tr':
        return const _WorkoutDayCompleteCopy(
          title: 'Güç sende!',
          subtitle: 'Kaslarını hisset ve ilerle.',
        );
      default:
        return const _WorkoutDayCompleteCopy(
          title: 'You are strong!',
          subtitle: 'Feel your muscles and keep moving.',
        );
    }
  }
}

class _WorkoutCompletionConfettiPainter extends CustomPainter {
  static const List<_ConfettiPiece> _pieces = [
    _ConfettiPiece(0.05, 0.06, 18, -0.6, _ConfettiShape.arc, Color(0xFFBEE8FF)),
    _ConfettiPiece(0.18, 0.12, 10, 0.4, _ConfettiShape.rect, Color(0xFFCFF4D0)),
    _ConfettiPiece(0.34, 0.14, 24, -0.1, _ConfettiShape.arc, Color(0xFFA8E2FF)),
    _ConfettiPiece(0.47, 0.18, 16, -0.2, _ConfettiShape.arc, Color(0xFFF7D79D)),
    _ConfettiPiece(0.79, 0.08, 28, 0.1, _ConfettiShape.arc, Color(0xFFF9C3CB)),
    _ConfettiPiece(0.90, 0.03, 20, 0.8, _ConfettiShape.rect, Color(0xFFF8CBD2)),
    _ConfettiPiece(0.11, 0.22, 22, 0.2, _ConfettiShape.arc, Color(0xFFB9E7FF)),
    _ConfettiPiece(
      0.45,
      0.21,
      26,
      -0.15,
      _ConfettiShape.rect,
      Color(0xFFC5ECB6),
    ),
    _ConfettiPiece(0.64, 0.27, 12, 0.9, _ConfettiShape.arc, Color(0xFFC3EFAA)),
    _ConfettiPiece(0.97, 0.29, 26, 0.0, _ConfettiShape.arc, Color(0xFFAEDFFF)),
    _ConfettiPiece(0.02, 0.36, 14, 0.9, _ConfettiShape.arc, Color(0xFFC1F1D4)),
    _ConfettiPiece(0.05, 0.48, 12, -0.3, _ConfettiShape.arc, Color(0xFFF8D2C5)),
    _ConfettiPiece(0.88, 0.43, 18, 0.15, _ConfettiShape.arc, Color(0xFFBAE1FF)),
    _ConfettiPiece(0.08, 0.62, 14, -0.5, _ConfettiShape.arc, Color(0xFFC8EFAA)),
    _ConfettiPiece(0.31, 0.81, 24, 1.0, _ConfettiShape.arc, Color(0xFFC6EFA5)),
    _ConfettiPiece(0.14, 0.90, 15, 0.35, _ConfettiShape.arc, Color(0xFFF6DE9D)),
    _ConfettiPiece(
      0.18,
      0.93,
      26,
      -0.1,
      _ConfettiShape.rect,
      Color(0xFFF8DE9E),
    ),
    _ConfettiPiece(0.37, 0.95, 24, 0.15, _ConfettiShape.arc, Color(0xFFF7DF9E)),
    _ConfettiPiece(
      0.47,
      0.90,
      18,
      -0.25,
      _ConfettiShape.arc,
      Color(0xFFF7E0A7),
    ),
    _ConfettiPiece(0.66, 0.88, 23, -0.1, _ConfettiShape.arc, Color(0xFFAFE0FF)),
    _ConfettiPiece(0.69, 0.94, 28, 0.12, _ConfettiShape.arc, Color(0xFFF4DBA0)),
    _ConfettiPiece(
      0.87,
      0.90,
      24,
      -0.05,
      _ConfettiShape.arc,
      Color(0xFFB7DFFF),
    ),
    _ConfettiPiece(0.93, 0.82, 18, 0.2, _ConfettiShape.arc, Color(0xFFF3D79D)),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (final piece in _pieces) {
      final center = Offset(size.width * piece.dx, size.height * piece.dy);
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(piece.rotation);

      switch (piece.shape) {
        case _ConfettiShape.arc:
          _paintArc(canvas, piece);
          break;
        case _ConfettiShape.rect:
          _paintRect(canvas, piece);
          break;
      }

      canvas.restore();
    }
  }

  void _paintArc(Canvas canvas, _ConfettiPiece piece) {
    final rect = Rect.fromCenter(
      center: Offset.zero,
      width: piece.size * 1.9,
      height: piece.size,
    );
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          piece.color.withValues(alpha: 0.0),
          piece.color,
          piece.color.withValues(alpha: 0.0),
        ],
      ).createShader(rect);
    canvas.drawArc(rect, 0, math.pi, true, paint);
  }

  void _paintRect(Canvas canvas, _ConfettiPiece piece) {
    final rect = Rect.fromCenter(
      center: Offset.zero,
      width: piece.size * 1.8,
      height: piece.size * 0.8,
    );
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          piece.color.withValues(alpha: 0.25),
          piece.color,
          piece.color.withValues(alpha: 0.25),
        ],
      ).createShader(rect);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(piece.size * 0.2)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

enum _ConfettiShape { arc, rect }

class _ConfettiPiece {
  const _ConfettiPiece(
    this.dx,
    this.dy,
    this.size,
    this.rotation,
    this.shape,
    this.color,
  );

  final double dx;
  final double dy;
  final double size;
  final double rotation;
  final _ConfettiShape shape;
  final Color color;
}
