import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slim30/Core/Network/onboarding_api.dart';
import 'package:slim30/Core/Routes/app_routes.dart';
import 'package:slim30/Core/Theme/my_colors.dart';
import 'package:slim30/View/QuestionView/widgets/question_bottom_actions.dart';
import 'package:slim30/l10n/generated/app_localizations.dart';

enum _WorkoutType { cardio, pilates, running, stretching, hiit, weight }

class QuestionWorkoutView extends StatefulWidget {
  const QuestionWorkoutView({super.key});

  @override
  State<QuestionWorkoutView> createState() => _QuestionWorkoutViewState();
}

class _QuestionWorkoutViewState extends State<QuestionWorkoutView> {
  _WorkoutType? _selected;

  static const int _currentStep = 6;
  static const int _totalSteps = 12;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final items = [
      _WorkoutItem(
        _WorkoutType.cardio,
        'icon_cardio.svg',
        l10n.questionWorkoutCardio,
      ),
      _WorkoutItem(
        _WorkoutType.pilates,
        'icon_pilates.svg',
        l10n.questionWorkoutPilates,
      ),
      _WorkoutItem(
        _WorkoutType.running,
        'icon_running.svg',
        l10n.questionWorkoutRunning,
      ),
      _WorkoutItem(
        _WorkoutType.stretching,
        'icon_stretching.svg',
        l10n.questionWorkoutStretching,
      ),
      _WorkoutItem(
        _WorkoutType.hiit,
        'icon_hiit.svg',
        l10n.questionWorkoutHiit,
      ),
      _WorkoutItem(
        _WorkoutType.weight,
        'icon_weight.svg',
        l10n.questionWorkoutWeight,
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

              // ── Header: title + progress ─────────────────────────
              Positioned(
                left: 24.w,
                top: 129.h,
                width: 342.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.questionWorkoutTitle,
                      style: GoogleFonts.leagueSpartan(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        height: 17 / 18,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
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

              // ── 2x3 workout grid ─────────────────────────────────
              Positioned(
                left: 24.w,
                top: 236.h,
                width: 342.w,
                child: Column(
                  children: [
                    for (int row = 0; row < 3; row++) ...[
                      Row(
                        children: [
                          for (int col = 0; col < 2; col++) ...[
                            _WorkoutCard(
                              item: items[row * 2 + col],
                              selected: _selected == items[row * 2 + col].type,
                              onTap: () => setState(
                                () => _selected = items[row * 2 + col].type,
                              ),
                            ),
                            if (col == 0) SizedBox(width: 12.w),
                          ],
                        ],
                      ),
                      if (row < 2) SizedBox(height: 12.h),
                    ],
                  ],
                ),
              ),

              // ── Bottom navigation ────────────────────────────────
              Positioned(
                left: 24.w,
                top: 743.h,
                width: 342.w,
                child: QuestionBottomActions(
                  onBack: () => Navigator.pop(context),
                  onNext: _selected != null
                      ? () async {
                          await OnboardingApi.upsertAnswer('preferred_workout', _selected!.name);
                          if (!mounted) return;
                          Navigator.pushNamed(
                            context,
                            AppRoutes.questionActivity,
                          );
                        }
                      : null,
                ),
              ),

              // ── Home indicator ───────────────────────────────────
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

// ── Data ──────────────────────────────────────────────────────────────────────

class _WorkoutItem {
  const _WorkoutItem(this.type, this.icon, this.label);
  final _WorkoutType type;
  final String icon;
  final String label;
}

// ── Workout card ──────────────────────────────────────────────────────────────

class _WorkoutCard extends StatelessWidget {
  const _WorkoutCard({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _WorkoutItem item;
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

// ── Progress bar ──────────────────────────────────────────────────────────────

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
