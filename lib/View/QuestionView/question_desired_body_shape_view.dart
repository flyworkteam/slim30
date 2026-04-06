import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slim30/Core/Network/onboarding_api.dart';
import 'package:slim30/Core/Routes/app_routes.dart';
import 'package:slim30/Core/Theme/my_colors.dart';
import 'package:slim30/View/QuestionView/widgets/question_bottom_actions.dart';
import 'package:slim30/l10n/generated/app_localizations.dart';

enum _DesiredBodyShape { slim, overweight, curvy, muscular }

class QuestionDesiredBodyShapeView extends StatefulWidget {
  const QuestionDesiredBodyShapeView({super.key});

  @override
  State<QuestionDesiredBodyShapeView> createState() =>
      _QuestionDesiredBodyShapeViewState();
}

class _QuestionDesiredBodyShapeViewState
    extends State<QuestionDesiredBodyShapeView> {
  _DesiredBodyShape? _selected;

  static const int _currentStep = 9;
  static const int _totalSteps = 12;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final items = [
      _Item(
        _DesiredBodyShape.slim,
        'iconstack.io - (Body Weight).svg',
        l10n.questionBodyShapeSlim,
      ),
      _Item(
        _DesiredBodyShape.overweight,
        'iconstack.io - (Tape Measure).svg',
        l10n.questionBodyShapeOverweight,
      ),
      _Item(
        _DesiredBodyShape.curvy,
        'icon_weight.svg',
        l10n.questionBodyShapeCurvy,
      ),
      _Item(
        _DesiredBodyShape.muscular,
        'iconstack.io - (Body Part Muscle).svg',
        l10n.questionBodyShapeMuscular,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: 390.w,
          height: 844.h,
          child: Stack(
            children: [
              // ── Skip ────────────────────────────────────────────
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

              // ── Header ───────────────────────────────────────────
              Positioned(
                left: 24.w,
                top: 129.h,
                width: 342.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.questionDesiredBodyShapeTitle,
                      style: GoogleFonts.leagueSpartan(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        height: 17 / 18,
                        color: Colors.black,
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

              // ── 2x2 grid ─────────────────────────────────────────
              Positioned(
                left: 24.w,
                top: 236.h,
                width: 342.w,
                child: Column(
                  children: [
                    for (int row = 0; row < 2; row++) ...[
                      Row(
                        children: [
                          for (int col = 0; col < 2; col++) ...[
                            _ShapeCard(
                              item: items[row * 2 + col],
                              selected: _selected == items[row * 2 + col].shape,
                              onTap: () => setState(
                                () => _selected = items[row * 2 + col].shape,
                              ),
                            ),
                            if (col == 0) SizedBox(width: 12.w),
                          ],
                        ],
                      ),
                      if (row < 1) SizedBox(height: 12.h),
                    ],
                  ],
                ),
              ),

              // ── Bottom navigation ─────────────────────────────────
              Positioned(
                left: 24.w,
                top: 743.h,
                width: 342.w,
                child: QuestionBottomActions(
                  onBack: () => Navigator.pop(context),
                  onNext: _selected != null
                      ? () {
                          OnboardingApi.tryUpsertAnswer('target_body_shape', _selected!.name);
                          Navigator.pushNamed(
                            context,
                            AppRoutes.questionWorkoutDays,
                          );
                        }
                      : null,
                ),
              ),

              // ── Home indicator ────────────────────────────────────
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

class _Item {
  const _Item(this.shape, this.icon, this.label);
  final _DesiredBodyShape shape;
  final String icon;
  final String label;
}

class _ShapeCard extends StatelessWidget {
  const _ShapeCard({
    required this.item,
    required this.selected,
    required this.onTap,
  });
  final _Item item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 165.w,
        height: 111.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          gradient: selected ? MyColors.onboardingButtonGradient : null,
          color: selected ? null : const Color(0xFFFBFBFB),
          border: Border.all(color: const Color(0xFFF2F2F2), width: 1),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/images/icons/${item.icon}',
                width: 48.w,
                height: 48.h,
              ),
              SizedBox(height: 17.h),
              Text(
                item.label,
                style: GoogleFonts.leagueSpartan(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  height: 15 / 16,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.current, required this.total});
  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    final fillWidth = 342.w * (current / total);
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
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(1),
                  bottomRight: Radius.circular(1),
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
