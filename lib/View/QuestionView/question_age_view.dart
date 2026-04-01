import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slim30/Core/Routes/app_routes.dart';
import 'package:slim30/Core/Theme/my_colors.dart';
import 'package:slim30/View/QuestionView/widgets/question_bottom_actions.dart';
import 'package:slim30/l10n/generated/app_localizations.dart';

class QuestionAgeView extends StatefulWidget {
  const QuestionAgeView({super.key});

  @override
  State<QuestionAgeView> createState() => _QuestionAgeViewState();
}

class _QuestionAgeViewState extends State<QuestionAgeView> {
  static const int _currentStep = 2;
  static const int _totalSteps = 12;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: 390.w,
          height: 844.h,
          child: Stack(
            children: [
              Positioned(
                right: 24.w,
                top: 87.h,
                child: GestureDetector(
                  onTap: () => Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false),
                  child: Text(
                    l10n.questionSkip,
                    style: GoogleFonts.leagueSpartan(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      height: 15 / 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 24.w,
                top: 129.h,
                width: 342.w,
                child: Column(
                  children: [
                    SizedBox(
                      width: 342.w,
                      child: Text(
                        l10n.questionAgeTitle,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          height: 17 / 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Align(
                      alignment: Alignment.centerRight,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '$_currentStep/',
                              style: GoogleFonts.leagueSpartan(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                height: 17 / 18,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: '$_totalSteps',
                              style: GoogleFonts.leagueSpartan(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                height: 17 / 18,
                                color: const Color(0xFFB3B3B3),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    _ProgressBar(current: _currentStep, total: _totalSteps),
                  ],
                ),
              ),
              Positioned(
                left: 123.w,
                top: 294.h,
                width: 145.w,
                height: 256.15.h,
                child: const _AgePickerPreview(),
              ),
              Positioned(
                left: 24.w,
                top: 743.h,
                width: 342.w,
                child: QuestionBottomActions(
                  onBack: () => Navigator.pop(context),
                  onNext: () {
                    Navigator.pushNamed(context, AppRoutes.questionHeight);
                  },
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 34.h,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AgePickerPreview extends StatelessWidget {
  const _AgePickerPreview();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 145.w,
      height: 256.15.h,
      child: Stack(
        children: [
          Positioned(top: 0, child: _ageLabel('24', const Color(0xFFCECECE))),
          Positioned(
            top: 49.h,
            child: _ageLabel('25', const Color(0xFF434343)),
          ),
          Positioned(top: 98.h, child: _selectedAgeChip('26')),
          Positioned(
            top: 182.h,
            child: _ageLabel('27', const Color(0xFF434343)),
          ),
          Positioned(
            top: 231.h,
            child: _ageLabel('28', const Color(0xFFCECECE)),
          ),
        ],
      ),
    );
  }

  Widget _ageLabel(String text, Color color) {
    return SizedBox(
      width: 145.w,
      height: 25.h,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.leagueSpartan(
            fontSize: 26.7317.sp,
            fontWeight: FontWeight.w500,
            height: 25 / 26.7317,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _selectedAgeChip(String text) {
    return SizedBox(
      width: 140.66.w,
      height: 60.15.h,
      child: Stack(
        children: [
          Positioned(
            left: 16.58.w,
            top: 0,
            child: Container(
              width: 126.25.w,
              height: 60.15.h,
              decoration: BoxDecoration(
                gradient: MyColors.onboardingButtonGradient,
                borderRadius: BorderRadius.circular(6.68293.r),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 44.365.w,
                    top: 15.005.h,
                    child: SizedBox(
                      width: 38.w,
                      height: 31.h,
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 33.4146.sp,
                          fontWeight: FontWeight.w700,
                          height: 31 / 33.4146,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 2.17.w,
            top: 10.h,
            child: CustomPaint(
              size: Size(39.2.w, 28.h),
              painter: _TrianglePainter(),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..color = const Color(0xFF62DDEF);
    final stroke = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.68.w;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, size.height / 2)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, fill);
    canvas.drawPath(path, stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.current, required this.total});

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    final fraction = current / total;
    final fillWidth = 342.w * fraction;

    return SizedBox(
      width: 342.w,
      height: 10.h,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Positioned(
            top: 2.h,
            child: Container(
              width: 342.w,
              height: 6.h,
              decoration: BoxDecoration(
                color: const Color(0xFFEEEEEE),
                borderRadius: BorderRadius.circular(3.r),
              ),
            ),
          ),
          Positioned(
            top: 2.h,
            child: Container(
              width: fillWidth,
              height: 6.h,
              decoration: BoxDecoration(
                gradient: MyColors.onboardingIndicatorGradient,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(1.r),
                  bottomRight: Radius.circular(1.r),
                ),
              ),
            ),
          ),
          Positioned(
            left: fillWidth - 5.w,
            child: Container(
              width: 10.w,
              height: 10.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: MyColors.onboardingIndicatorGradient,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
