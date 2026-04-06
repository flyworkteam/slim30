import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slim30/Core/Network/onboarding_api.dart';
import 'package:slim30/Core/Routes/app_routes.dart';
import 'package:slim30/Core/Theme/my_colors.dart';
import 'package:slim30/View/QuestionView/widgets/question_bottom_actions.dart';
import 'package:slim30/l10n/generated/app_localizations.dart';

class QuestionWeightView extends StatefulWidget {
  const QuestionWeightView({super.key});

  @override
  State<QuestionWeightView> createState() => _QuestionWeightViewState();
}

class _QuestionWeightViewState extends State<QuestionWeightView> {
  static const int _currentStep = 4;
  static const int _totalSteps = 12;
  int _selectedWeight = 70;
  bool _hasSelectedWeight = false;

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
                        l10n.questionWeightTitle,
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
                      child: Text(
                        '$_currentStep/$_totalSteps',
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          height: 17 / 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    _ProgressBar(current: _currentStep, total: _totalSteps),
                  ],
                ),
              ),
              Positioned(
                left: 30.w,
                top: 296.h,
                width: 330.w,
                height: 257.h,
                child: _WeightPicker(
                  initialSelected: _selectedWeight,
                  onChanged: (value) {
                    setState(() {
                      _selectedWeight = value;
                      _hasSelectedWeight = true;
                    });
                  },
                ),
              ),
              Positioned(
                left: 24.w,
                top: 743.h,
                width: 342.w,
                child: QuestionBottomActions(
                  onBack: () => Navigator.pop(context),
                  onNext: _hasSelectedWeight
                      ? () {
                          OnboardingApi.tryUpsertAnswer('weight_kg', _selectedWeight);
                          Navigator.pushNamed(
                            context,
                            AppRoutes.questionTargetWeight,
                          );
                        }
                      : null,
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

class _WeightPicker extends StatefulWidget {
  const _WeightPicker({
    required this.initialSelected,
    required this.onChanged,
  });

  final int initialSelected;
  final ValueChanged<int> onChanged;

  @override
  State<_WeightPicker> createState() => _WeightPickerState();
}

class _WeightPickerState extends State<_WeightPicker> {
  static const int _min = 40;
  static const int _max = 140;
  static const double _rulerLeft = 17;
  static const double _rulerTop = 135;
  static const double _rulerWidth = 297;
  static const double _selectedValueWidth = 80;
  static const double _pointerWidth = 39.2;
  static const double _tickLabelWidth = 40;
  late int _selected;
  double _dragCarry = 0;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialSelected.clamp(_min, _max).toInt();
  }

  void _onHorizontalDrag(double dx) {
    _dragCarry += dx;
    const stepPx = 6.0;
    final step = (_dragCarry / stepPx).truncate();
    if (step == 0) return;
    _dragCarry -= step * stepPx;
    final next = (_selected - step).clamp(_min, _max);
    if (next != _selected) {
      setState(() => _selected = next);
      widget.onChanged(_selected);
    }
  }

  String _label(int delta) {
    final v = _selected + delta;
    if (v < _min || v > _max) return '';
    return '$v';
  }

  @override
  Widget build(BuildContext context) {
    final rulerCenterX = _rulerLeft + (_rulerWidth / 2);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragUpdate: (d) => _onHorizontalDrag(d.delta.dx),
      child: Stack(
        children: [
          Positioned(
            left: 30.w,
            top: 12.h,
            child: Transform.rotate(
              angle: math.pi / 2,
              alignment: Alignment.topLeft,
              child: Container(
                width: 226.w,
                height: 330.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  gradient: const LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color.fromRGBO(255, 255, 255, 0.2),
                      Color.fromRGBO(136, 243, 207, 0.2),
                      Color.fromRGBO(207, 250, 236, 0.2),
                      Color.fromRGBO(255, 255, 255, 0.2),
                    ],
                    stops: [0.0804, 0.2428, 0.7714, 0.9062],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 120.w,
            top: 0,
            width: 90.w,
            height: 32.h,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: Colors.white, width: 1.w),
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
                    'kg',
                    style: GoogleFonts.leagueSpartan(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      height: 17 / 18,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 12.w,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: (rulerCenterX - (_selectedValueWidth / 2)).w,
            top: 92.h,
            child: SizedBox(
              width: _selectedValueWidth.w,
              height: 29.h,
              child: Text(
                '$_selected',
                textAlign: TextAlign.center,
                style: GoogleFonts.leagueSpartan(
                  fontSize: 31.9846.sp,
                  fontWeight: FontWeight.w700,
                  height: 29 / 31.9846,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Positioned(
            left: _rulerLeft.w,
            top: _rulerTop.h,
            width: _rulerWidth.w,
            height: 41.12.h,
            child: CustomPaint(painter: _WeightRulerPainter()),
          ),
          Positioned(
            left: 308.29.w,
            top: 153.28.h,
            child: Container(
              width: 22.85.w,
              height: 0,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFFCECECE),
                  width: 1.14231.w,
                ),
              ),
            ),
          ),
          Positioned(
            left: 314.w,
            top: 153.28.h,
            child: Container(
              width: 22.85.w,
              height: 0,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFFCECECE),
                  width: 1.14231.w,
                ),
              ),
            ),
          ),
          Positioned(
            left: (41 + (23 - _tickLabelWidth) / 2).w,
            top: 185.h,
            child: _tickLabel(_label(-20), const Color(0xFFCECECE)),
          ),
          Positioned(
            left: (103 + (23 - _tickLabelWidth) / 2).w,
            top: 185.h,
            child: _tickLabel(_label(-10), const Color(0xFF434343)),
          ),
          Positioned(
            left: (229 + (23 - _tickLabelWidth) / 2).w,
            top: 185.h,
            child: _tickLabel(_label(10), const Color(0xFF434343)),
          ),
          Positioned(
            left: (291 + (23 - _tickLabelWidth) / 2).w,
            top: 185.h,
            child: _tickLabel(_label(20), const Color(0xFFCECECE)),
          ),
          Positioned(
            left: (rulerCenterX - (_pointerWidth / 2)).w,
            top: 229.h,
            child: CustomPaint(
              size: Size(_pointerWidth.w, 28.h),
              painter: _BottomPointerPainter(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tickLabel(String text, Color color) {
    return SizedBox(
      width: _tickLabelWidth.w,
      height: 18.h,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.leagueSpartan(
          fontSize: 20.sp,
          fontWeight: FontWeight.w500,
          height: 18 / 20,
          color: color,
        ),
      ),
    );
  }
}

class _WeightRulerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final minor = Paint()
      ..color = const Color(0xFFCECECE)
      ..strokeWidth = 1.14231.w;
    final selected = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.28461.w;

    const spacing = 5.71;
    final lines = (size.width / spacing).floor();
    final centerX = size.width / 2;

    for (var i = 0; i <= lines; i++) {
      final x = i * spacing;
      final isCenter = (x - centerX).abs() < spacing / 2;
      final isMajor = i % 10 == 0;
      final startY = isCenter || isMajor ? 0.0 : size.height - 22.85.h;
      final endY = isCenter ? 51.4.h : size.height;
      canvas.drawLine(
        Offset(x, startY),
        Offset(x, endY),
        isCenter ? selected : minor,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BottomPointerPainter extends CustomPainter {
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
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
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
    final fillWidth = 113.w;
    final dotLeft = 108.w;

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
            left: dotLeft,
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
