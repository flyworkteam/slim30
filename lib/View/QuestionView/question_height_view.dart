import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slim30/Core/Network/onboarding_api.dart';
import 'package:slim30/Core/Routes/app_routes.dart';
import 'package:slim30/Core/Theme/my_colors.dart';
import 'package:slim30/View/QuestionView/widgets/question_bottom_actions.dart';
import 'package:slim30/l10n/generated/app_localizations.dart';

class QuestionHeightView extends StatelessWidget {
  const QuestionHeightView({super.key});

  static const int _currentStep = 3;
  static const int _totalSteps = 12;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Center(
        child: SizedBox(
          width: 390.w,
          height: 844.h,
          child: Stack(
            children: [
              const Positioned.fill(
                child: ColoredBox(color: Color(0xFFF2F2F2)),
              ),
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
                        l10n.questionHeightTitle,
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
                left: 64.w,
                top: 238.12.h,
                width: 262.w,
                height: 458.75.h,
                child: const _HeightPickerPreview(),
              ),
              Positioned(
                left: 24.w,
                top: 743.h,
                width: 342.w,
                child: QuestionBottomActions(
                  onBack: () => Navigator.pop(context),
                  onNext: () async {
                    await OnboardingApi.upsertAnswer('height_cm', 170);
                    if (!context.mounted) return;
                    Navigator.pushNamed(context, AppRoutes.questionWeight);
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

class _HeightPickerPreview extends StatefulWidget {
  const _HeightPickerPreview();

  @override
  State<_HeightPickerPreview> createState() => _HeightPickerPreviewState();
}

class _HeightPickerPreviewState extends State<_HeightPickerPreview> {
  static const int _minHeight = 140;
  static const int _maxHeight = 200;
  int _selectedHeight = 170;
  double _dragCarry = 0;

  void _changeByDelta(double dy) {
    _dragCarry += dy;
    const stepPx = 6.0;
    final step = (_dragCarry / stepPx).truncate();
    if (step == 0) return;
    _dragCarry -= step * stepPx;

    final next = (_selectedHeight + step).clamp(_minHeight, _maxHeight);
    if (next != _selectedHeight) {
      setState(() => _selectedHeight = next);
    }
  }

  String _labelValue(int delta) {
    final value = _selectedHeight + delta;
    if (value < _minHeight || value > _maxHeight) return '';
    return '$value';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragUpdate: (details) => _changeByDelta(details.delta.dy),
      onTapUp: (details) {
        final centerY = 219.h;
        if (details.localPosition.dy < centerY - 20.h) {
          setState(
            () => _selectedHeight = (_selectedHeight - 1).clamp(
              _minHeight,
              _maxHeight,
            ),
          );
        } else if (details.localPosition.dy > centerY + 20.h) {
          setState(
            () => _selectedHeight = (_selectedHeight + 1).clamp(
              _minHeight,
              _maxHeight,
            ),
          );
        }
      },
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 15.06.h,
            width: 262.w,
            height: 443.69.h,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11.5985.r),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(255, 255, 255, 0.2),
                    Color.fromRGBO(136, 243, 207, 0.2),
                    Color.fromRGBO(207, 250, 236, 0.2),
                    Color.fromRGBO(255, 255, 255, 0.2),
                  ],
                  stops: [0.0905, 0.2956, 0.7058, 0.9793],
                ),
              ),
            ),
          ),
          Positioned(
            left: 46.18.w,
            top: 201.77.h,
            width: 115.w,
            height: 36.h,
            child: Text(
              '$_selectedHeight cm',
              textAlign: TextAlign.center,
              style: GoogleFonts.leagueSpartan(
                fontSize: 38.756.sp,
                fontWeight: FontWeight.w700,
                height: 36 / 38.756,
                color: Colors.black,
              ),
            ),
          ),
          Positioned(
            left: 52.8.w,
            top: 238.12.h,
            width: 104.4.w,
            height: 32.12.h,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0383.r),
                border: Border.all(color: Colors.white, width: 1.15985.w),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFCDFFDD),
                    Color(0xFFCFFFEF),
                    Color(0xFFD2F9FF),
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'cm',
                    style: GoogleFonts.leagueSpartan(
                      fontSize: 20.8773.sp,
                      fontWeight: FontWeight.w500,
                      height: 19 / 20.8773,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 5.8.w),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 14.w,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 150.66.w,
            top: 36.14.h,
            child: _rulerLabel(_labelValue(-30), const Color(0xFFCECECE)),
          ),
          Positioned(
            left: 150.66.w,
            top: 95.36.h,
            child: _rulerLabel(_labelValue(-20), const Color(0xFFCECECE)),
          ),
          Positioned(
            left: 150.25.w,
            top: 152.59.h,
            child: _rulerLabel(_labelValue(-10), const Color(0xFF434343)),
          ),
          Positioned(
            left: 150.66.w,
            top: 271.03.h,
            child: _rulerLabel(_labelValue(10), const Color(0xFF434343)),
          ),
          Positioned(
            left: 150.66.w,
            top: 329.26.h,
            child: _rulerLabel(_labelValue(20), const Color(0xFFCECECE)),
          ),
          Positioned(
            left: 147.65.w,
            top: 386.48.h,
            child: _rulerLabel(_labelValue(30), const Color(0xFFCECECE)),
          ),
          Positioned(
            left: 190.81.w,
            top: 47.18.h,
            width: 41.75.w,
            height: 349.1.h,
            child: CustomPaint(painter: _HeightRulerPainter()),
          ),
          Positioned(
            left: 242.4.w,
            top: 216.88.h,
            child: CustomPaint(
              size: Size(39.2.w, 28.h),
              painter: _RightPointerPainter(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rulerLabel(String value, Color color) {
    return SizedBox(
      width: 40.w,
      height: 21.h,
      child: Text(
        value,
        textAlign: TextAlign.center,
        style: GoogleFonts.leagueSpartan(
          fontSize: 23.197.sp,
          fontWeight: FontWeight.w500,
          height: 21 / 23.197,
          color: color,
        ),
      ),
    );
  }
}

class _HeightRulerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final minor = Paint()
      ..color = const Color(0xFFCECECE)
      ..strokeWidth = 1.15985.w;
    final selected = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.3197.w;

    const spacing = 5.8;
    final centerY = size.height / 2;
    final lineCount = (size.height / spacing).floor();

    for (var i = 0; i <= lineCount; i++) {
      final y = i * spacing;
      final isCenter = (y - centerY).abs() < spacing / 2;
      final isMajor = i % 10 == 0;

      final startX = isCenter || isMajor ? 0.0 : size.width - 23.2.w;
      final endX = isCenter ? 52.19.w : size.width;
      canvas.drawLine(
        Offset(startX, y),
        Offset(endX, y),
        isCenter ? selected : minor,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RightPointerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFFFAFA), Color(0xFF77FFD1), Color(0xFF37E3FD)],
      ).createShader(Offset.zero & size);

    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.68.w
      ..color = Colors.white;

    final path = Path()
      ..moveTo(size.width, 0)
      ..lineTo(0, size.height / 2)
      ..lineTo(size.width, size.height)
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
