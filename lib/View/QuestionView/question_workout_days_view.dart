import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slim30/Core/Network/onboarding_api.dart';
import 'package:slim30/Core/Routes/app_routes.dart';
import 'package:slim30/Core/Theme/my_colors.dart';
import 'package:slim30/View/QuestionView/widgets/question_bottom_actions.dart';
import 'package:slim30/l10n/generated/app_localizations.dart';

enum _Day { mon, tue, wed, thu, fri, sat, sun }

class QuestionWorkoutDaysView extends StatefulWidget {
  const QuestionWorkoutDaysView({super.key});

  @override
  State<QuestionWorkoutDaysView> createState() =>
      _QuestionWorkoutDaysViewState();
}

class _QuestionWorkoutDaysViewState extends State<QuestionWorkoutDaysView> {
  final Set<_Day> _selected = {};

  static const int _currentStep = 10;
  static const int _totalSteps = 12;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final days = [
      _DayItem(_Day.mon, l10n.questionDayMon),
      _DayItem(_Day.tue, l10n.questionDayTue),
      _DayItem(_Day.wed, l10n.questionDayWed),
      _DayItem(_Day.thu, l10n.questionDayThu),
      _DayItem(_Day.fri, l10n.questionDayFri),
      _DayItem(_Day.sat, l10n.questionDaySat),
      _DayItem(_Day.sun, l10n.questionDaySun),
    ];

    // Split into rows of 3
    final rows = <List<_DayItem>>[];
    for (int i = 0; i < days.length; i += 3) {
      rows.add(days.sublist(i, i + 3 > days.length ? days.length : i + 3));
    }

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
                      l10n.questionWorkoutDaysTitle,
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

              // ── Day pills grid ────────────────────────────────────
              Positioned(
                left: 24.w,
                top: 237.h,
                width: 340.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int r = 0; r < rows.length; r++) ...[
                      Row(
                        children: [
                          for (int c = 0; c < rows[r].length; c++) ...[
                            _DayPill(
                              item: rows[r][c],
                              selected: _selected.contains(rows[r][c].day),
                              onTap: () => setState(() {
                                if (_selected.contains(rows[r][c].day)) {
                                  _selected.remove(rows[r][c].day);
                                } else {
                                  _selected.add(rows[r][c].day);
                                }
                              }),
                            ),
                            if (c < rows[r].length - 1) SizedBox(width: 8.w),
                          ],
                        ],
                      ),
                      if (r < rows.length - 1) SizedBox(height: 12.h),
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
                  onNext: _selected.isNotEmpty
                      ? () async {
                          await OnboardingApi.upsertAnswer(
                            'workout_days',
                            _selected.map((day) => day.name).toList(growable: false),
                          );
                          if (!mounted) return;
                          Navigator.pushNamed(
                            context,
                            AppRoutes.questionWorkoutDuration,
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

class _DayItem {
  const _DayItem(this.day, this.label);
  final _Day day;
  final String label;
}

class _DayPill extends StatelessWidget {
  const _DayPill({
    required this.item,
    required this.selected,
    required this.onTap,
  });
  final _DayItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 108.w,
        height: 48.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          gradient: selected ? MyColors.onboardingButtonGradient : null,
          color: selected ? null : const Color(0xFFFBFBFB),
          border: selected
              ? null
              : Border.all(color: const Color(0xFFF2F2F2), width: 1),
        ),
        alignment: Alignment.center,
        child: Text(
          item.label,
          style: GoogleFonts.leagueSpartan(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            height: 15 / 16,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
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
