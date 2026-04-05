import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slim30/Core/Routes/app_routes.dart';
import 'package:slim30/l10n/generated/app_localizations.dart';

class ProgressView extends StatefulWidget {
  const ProgressView({super.key});

  @override
  State<ProgressView> createState() => _ProgressViewState();
}

class _ProgressViewState extends State<ProgressView> {
  static const _homeIconBase = 'assets/images/icons/homePage';
  static const _progressIconBase = 'assets/images/icons/progress_icon';

  int _waterCount = 1;
  int _selectedGoalIndex = 1;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final goalOptions = [
      l10n.progressGoalDaily5k,
      l10n.progressGoalDaily10k,
      l10n.progressGoalWeekly40k,
      l10n.progressGoalWeekly50k,
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: 390.w,
          child: Stack(
            children: [
              Positioned.fill(
                child: SafeArea(
                  bottom: false,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(24.w, 40.h, 24.w, 100.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Header(title: l10n.progressTitle),
                        SizedBox(height: 16.h),
                        _TodayWorkoutCard(
                          title: l10n.homeTodayWorkoutTitle,
                          moves: l10n.homeWorkoutMoves,
                          calories: l10n.homeWorkoutCalories,
                          duration: l10n.homeWorkoutDuration,
                          cta: l10n.homeStartNow,
                        ),
                        SizedBox(height: 16.h),
                        _StreakRow(
                          streakDays: '7 Gün',
                          streakLabel: l10n.homeDontBreakChain,
                          dayShortLabels: [
                            l10n.homeDayMonShort,
                            l10n.homeDayTueShort,
                            l10n.homeDayWedShort,
                            l10n.homeDayThuShort,
                            l10n.homeDayFriShort,
                            l10n.homeDaySatShort,
                            l10n.homeDaySunShort,
                          ],
                          dayNumbers: const [
                            '22',
                            '23',
                            '24',
                            '25',
                            '26',
                            '27',
                            '28',
                          ],
                          completedCount: 3,
                        ),
                        SizedBox(height: 24.h),
                        _SectionTitle(text: l10n.progressDailyWorkoutSummary),
                        SizedBox(height: 15.h),
                        _DailySummaryCard(
                          completedTitle: l10n.progressCompletedActivity,
                          completedValue: '6/8',
                          caloriesTitle: l10n.progressCaloriesBurnedLabel,
                          caloriesValue: '140 ${l10n.progressUnitKcal}',
                          muscleLabel: l10n.progressMuscleGainLabel,
                          muscleValue: '+2.1',
                          waistLabel: l10n.progressWaistChangeLabel,
                          waistValue: '-3.2',
                          fatLabel: l10n.progressBodyFatLabel,
                          fatValue: '-4%',
                          movementLabel: l10n.progressMovementCountLabel,
                          movementValue: '20',
                          durationLabel: l10n.progressDurationLabel,
                          durationValue: '40 ${l10n.progressUnitMinute}',
                          successLabel: l10n.progressSuccessPercentLabel,
                          successValue: '%69',
                        ),
                        SizedBox(height: 24.h),
                        _OverallPerformanceRow(
                          overallTitle: l10n.progressOverallPerformanceTitle,
                          overallSubtitle:
                              l10n.progressOverallPerformanceSubtitle,
                          percentage: 82,
                        ),
                        SizedBox(height: 24.h),
                        _SectionTitle(text: l10n.progressGeneralStatusTitle),
                        SizedBox(height: 15.h),
                        _GeneralCaloriesTrendCard(
                          iconPath: '$_progressIconBase/iconsax-weight.svg',
                          title: l10n.progressCaloriesBurnedLabel,
                          value: '140 ${l10n.progressUnitKcal}',
                        ),
                        SizedBox(height: 15.h),
                        _GeneralBodyMetricsCard(
                          muscleLabel: l10n.progressMuscleGainLabel,
                          muscleValue: '+2.1',
                          waistLabel: l10n.progressWaistChangeLabel,
                          waistValue: '-3.2',
                          fatLabel: l10n.progressBodyFatLabel,
                          fatValue: '-4%',
                        ),
                        SizedBox(height: 10.h),
                        _StatTile(
                          iconPath: '$_progressIconBase/iconsax-weight.svg',
                          label: l10n.progressWeightLostLabel,
                          value: '-3.4 ${l10n.progressUnitKg}',
                        ),
                        SizedBox(height: 10.h),
                        _StatTile(
                          iconPath:
                              '$_progressIconBase/iconsax-activity (1).svg',
                          label: l10n.progressHeartRateLabel,
                          value: '80 ${l10n.progressUnitBpm}',
                        ),
                        SizedBox(height: 10.h),
                        _StatTile(
                          iconPath: '$_progressIconBase/iconsax-activity.svg',
                          label: l10n.progressTotalCompletedLabel,
                          value: '12',
                        ),
                        SizedBox(height: 10.h),
                        _StatTile(
                          iconPath: '$_progressIconBase/iconsax-drop.svg',
                          label: l10n.progressHydrationLabel,
                          value: '%72',
                        ),
                        SizedBox(height: 10.h),
                        _StatTile(
                          iconPath: '$_progressIconBase/iconsax-moon.svg',
                          label: l10n.progressSleepLabel,
                          value: '8 ${l10n.progressUnitHour}',
                        ),
                        SizedBox(height: 24.h),
                        _RewardCard(
                          title: l10n.progressRewardTitle,
                          subtitle: l10n.progressRewardSubtitle,
                        ),
                        SizedBox(height: 18.h),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _GoalInfoCard(
                              iconPath: '$_progressIconBase/Group 277.svg',
                              title: l10n.progressStepsTitle,
                              subtitle: goalOptions[_selectedGoalIndex],
                              selectedGoalIndex: _selectedGoalIndex,
                              goalOptions: goalOptions,
                              editIconPath:
                                  '$_progressIconBase/Clip path group.svg',
                              onGoalChanged: (newIndex) {
                                setState(() {
                                  _selectedGoalIndex = newIndex;
                                });
                              },
                            ),
                            SizedBox(height: 10.h),
                            _WaterCard(
                              iconPath: '$_progressIconBase/Group 278.svg',
                              title: l10n.progressWaterTitle,
                              subtitle: l10n.progressWaterSubtitle,
                              count: _waterCount,
                              onMinus: () {
                                setState(() {
                                  _waterCount = (_waterCount - 1).clamp(0, 9);
                                });
                              },
                              onPlus: () {
                                setState(() {
                                  _waterCount = (_waterCount + 1).clamp(0, 9);
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _BottomBar(iconBase: _homeIconBase),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Semantics(
          label: l10n.questionBack,
          button: true,
          child: InkWell(
            onTap: () =>
                Navigator.pushReplacementNamed(context, AppRoutes.home),
            borderRadius: BorderRadius.circular(14.r),
            child: Container(
              width: 28.w,
              height: 28.w,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(14.r),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 14.w,
                color: Colors.black,
              ),
            ),
          ),
        ),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.leagueSpartan(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              height: 1,
            ),
          ),
        ),
        SizedBox(width: 28.w),
      ],
    );
  }
}

class _TodayWorkoutCard extends StatelessWidget {
  const _TodayWorkoutCard({
    required this.title,
    required this.moves,
    required this.calories,
    required this.duration,
    required this.cta,
  });

  final String title;
  final String moves;
  final String calories;
  final String duration;
  final String cta;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 342.w,
      height: 154.h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Stack(
          children: [
            Container(color: const Color(0xFF97F1FF)),
            Positioned(
              right: 0,
              bottom: 0,
              child: SvgPicture.asset(
                'assets/images/icons/progress_icon/Vector.svg',
                width: 82.w,
                height: 89.h,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              left: 15.w,
              top: (154.h - 117.h) / 2,
              child: SizedBox(
                width: 260.w,
                height: 117.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 260.w,
                      height: 21.h,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.center,
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: GoogleFonts.leagueSpartan(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                            letterSpacing: -0.011,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    SizedBox(
                      width: 240.w,
                      height: 54.h,
                      child: Center(
                        child: SizedBox(
                          width: 204.w,
                          height: 26.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _WorkoutStat(text: moves, width: 45.w),
                              SizedBox(width: 20.w),
                              _WorkoutLineDivider(),
                              SizedBox(width: 20.w),
                              _WorkoutStat(text: calories, width: 24.w),
                              SizedBox(width: 20.w),
                              _WorkoutLineDivider(),
                              SizedBox(width: 20.w),
                              _WorkoutStat(text: duration, width: 39.w),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Container(
                      width: 116.w,
                      height: 32.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: Text(
                        cta,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          height: 13 / 14,
                          letterSpacing: -0.011,
                          color: const Color(0xFF171717),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkoutStat extends StatelessWidget {
  const _WorkoutStat({required this.text, required this.width});

  final String text;
  final double width;

  @override
  Widget build(BuildContext context) {
    final parts = text.trim().split(RegExp(r'\s+'));
    final firstLine = parts.isNotEmpty ? parts.first : text;
    final secondLine = parts.length > 1 ? parts.skip(1).join(' ') : '';

    return SizedBox(
      width: width,
      height: 26.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: width,
            height: 13.h,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
              child: Text(
                firstLine,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: GoogleFonts.leagueSpartan(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  height: 13 / 14,
                  letterSpacing: -0.011,
                ),
              ),
            ),
          ),
          SizedBox(
            width: width,
            height: 13.h,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
              child: Text(
                secondLine,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: GoogleFonts.leagueSpartan(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  height: 13 / 14,
                  letterSpacing: -0.011,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkoutLineDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1.w, height: 23.h, color: Colors.black);
  }
}

class _StreakRow extends StatelessWidget {
  const _StreakRow({
    required this.streakDays,
    required this.streakLabel,
    required this.dayShortLabels,
    required this.dayNumbers,
    required this.completedCount,
  });

  final String streakDays;
  final String streakLabel;
  final List<String> dayShortLabels;
  final List<String> dayNumbers;
  final int completedCount;

  @override
  Widget build(BuildContext context) {
    assert(dayShortLabels.length == dayNumbers.length);
    final safeLength = math.min(dayShortLabels.length, dayNumbers.length);
    final clampedCompletedCount = completedCount.clamp(0, safeLength);

    return SizedBox(
      width: 342.w,
      height: 88.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 75.w,
            height: 88.h,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/images/icons/progress_icon/iconsax-fire.svg',
                  width: 40.w,
                  height: 40.w,
                ),
                SizedBox(height: 6.h),
                SizedBox(
                  width: 75.w,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 19.h,
                        child: Center(
                          child: Text(
                            streakDays,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.leagueSpartan(
                              fontSize: 20.7.sp,
                              fontWeight: FontWeight.w500,
                              height: 19 / 20.7,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Container(
                        width: 75.w,
                        height: 17.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE9FFF3),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Text(
                          streakLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.leagueSpartan(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            height: 9 / 10,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          SizedBox(
            width: 251.w,
            height: 87.h,
            child: Row(
              children: List.generate(safeLength, (index) {
                final isCompleted = index < clampedCompletedCount;
                return Padding(
                  padding: EdgeInsets.only(
                    right: index == safeLength - 1 ? 0 : 9.w,
                  ),
                  child: _StreakDayPill(
                    label: dayShortLabels[index],
                    value: dayNumbers[index],
                    isCompleted: isCompleted,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _StreakDayPill extends StatelessWidget {
  const _StreakDayPill({
    required this.label,
    required this.value,
    required this.isCompleted,
  });

  final String label;
  final String value;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28.w,
      height: 87.h,
      decoration: BoxDecoration(
        gradient: isCompleted
            ? const LinearGradient(
                begin: Alignment(-0.75, -1),
                end: Alignment(0.9, 1),
                colors: [
                  Color(0xFF66F393),
                  Color(0xFF88F3CF),
                  Color(0xFFA3F3FF),
                ],
                stops: [0.0553, 0.7147, 1],
              )
            : null,
        color: isCompleted ? null : const Color(0xFFF2FFF8),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(253, 238, 238, 0.41),
            blurRadius: 2,
            offset: Offset.zero,
          ),
        ],
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(4.w, 8.h, 4.w, 8.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.leagueSpartan(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                height: 1.5,
                letterSpacing: -0.011,
                color: isCompleted ? Colors.white : Colors.black,
              ),
            ),
            isCompleted
                ? Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      size: 14.w,
                      color: const Color(0xFF32EA6E),
                    ),
                  )
                : Text(
                    value,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.leagueSpartan(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                      letterSpacing: -0.011,
                      color: Colors.black,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class _OverallPerformanceRow extends StatelessWidget {
  const _OverallPerformanceRow({
    required this.overallTitle,
    required this.overallSubtitle,
    required this.percentage,
  });

  final String overallTitle;
  final String overallSubtitle;
  final int percentage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 342.w,
      height: 86.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 219.w,
            height: 38.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  overallTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.leagueSpartan(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    height: 17 / 18,
                    letterSpacing: -0.011,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  overallSubtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.leagueSpartan(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w300,
                    height: 13 / 14,
                    letterSpacing: -0.011,
                    color: const Color(0xFF646464),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 15.w),
          SizedBox(
            width: 87.06.w,
            height: 86.69.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 81.75.w,
                  height: 81.75.w,
                  child: CircularProgressIndicator(
                    value: percentage / 100,
                    strokeWidth: 8.w,
                    backgroundColor: const Color(0xFFD3FFE1),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF32EA6E),
                    ),
                  ),
                ),
                Text(
                  '%$percentage',
                  style: GoogleFonts.leagueSpartan(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w500,
                    height: 22 / 24,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.leagueSpartan(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _DailySummaryCard extends StatelessWidget {
  const _DailySummaryCard({
    required this.completedTitle,
    required this.completedValue,
    required this.caloriesTitle,
    required this.caloriesValue,
    required this.muscleLabel,
    required this.muscleValue,
    required this.waistLabel,
    required this.waistValue,
    required this.fatLabel,
    required this.fatValue,
    required this.movementLabel,
    required this.movementValue,
    required this.durationLabel,
    required this.durationValue,
    required this.successLabel,
    required this.successValue,
  });

  final String completedTitle;
  final String completedValue;
  final String caloriesTitle;
  final String caloriesValue;
  final String muscleLabel;
  final String muscleValue;
  final String waistLabel;
  final String waistValue;
  final String fatLabel;
  final String fatValue;
  final String movementLabel;
  final String movementValue;
  final String durationLabel;
  final String durationValue;
  final String successLabel;
  final String successValue;

  @override
  Widget build(BuildContext context) {
    final caloriesParts = caloriesValue.trim().split(RegExp(r'\s+'));
    final caloriesAmount = caloriesParts.isNotEmpty ? caloriesParts.first : '';
    final caloriesUnit = caloriesParts.length > 1
        ? caloriesParts.skip(1).join(' ')
        : '';

    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 131.w,
              height: 123.h,
              decoration: BoxDecoration(
                color: const Color(0xFF97F1FF),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: 13.w,
                    top: 14.h,
                    width: 114.w,
                    child: Text(
                      completedTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.leagueSpartan(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        height: 1,
                        letterSpacing: -0.011,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 41.h,
                    left: 2.w,
                    child: _CompletedActivityRingGauge(value: 6 / 8),
                  ),
                  Positioned(
                    left: 2.w,
                    top: 70.h,
                    width: 87.w,
                    child: Text(
                      completedValue,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.visible,
                      style: GoogleFonts.leagueSpartan(
                        fontSize: 24.709.sp,
                        fontWeight: FontWeight.w500,
                        height: 23 / 24.709,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 9.w,
                    top: 28.h,
                    child: Transform.rotate(
                      angle: 16.37 * math.pi / 180,
                      child: Container(
                        width: 9.13.w,
                        height: 106.43.h,
                        color: const Color.fromRGBO(255, 218, 223, 0.17),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 2.w,
                    top: 71.6.h,
                    child: Transform.rotate(
                      angle: 13.42 * math.pi / 180,
                      child: Container(
                        width: 10.w,
                        height: 63.72.h,
                        color: const Color.fromRGBO(255, 218, 223, 0.17),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 7.w),
            Expanded(
              child: Container(
                height: 123.h,
                padding: EdgeInsets.fromLTRB(12.w, 11.h, 12.w, 11.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFE1FBFF),
                  border: Border.all(
                    color: const Color.fromRGBO(254, 105, 129, 0.07),
                  ),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 24.h,
                      child: Row(
                        children: [
                          Container(
                            width: 24.w,
                            height: 24.w,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEFDFF),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            alignment: Alignment.center,
                            child: SvgPicture.asset(
                              'assets/images/icons/progress_icon/iconsax-weight.svg',
                              width: 14.w,
                              height: 14.w,
                            ),
                          ),
                          SizedBox(width: 5.w),
                          Expanded(
                            child: Text(
                              caloriesTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.leagueSpartan(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                height: 13 / 14,
                                letterSpacing: -0.011,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                    SizedBox(
                      height: 73.h,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 57.w,
                            height: 57.w,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 53.52.w,
                                  height: 53.52.w,
                                  child: CircularProgressIndicator(
                                    value: 0.72,
                                    strokeWidth: 7.w,
                                    backgroundColor: const Color(0xFFF3FDFF),
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          Color(0xFF2ED3EC),
                                        ),
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      caloriesAmount,
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.leagueSpartan(
                                        fontSize: 16.18.sp,
                                        fontWeight: FontWeight.w500,
                                        height: 15 / 16.18,
                                        color: const Color(0xFF1DCEE9),
                                      ),
                                    ),
                                    if (caloriesUnit.isNotEmpty)
                                      Text(
                                        caloriesUnit,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.leagueSpartan(
                                          fontSize: 16.18.sp,
                                          fontWeight: FontWeight.w500,
                                          height: 15 / 16.18,
                                          color: Colors.black,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 14.w),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: 21.h,
                                  child: _MiniMetricRow(
                                    iconPath:
                                        'assets/images/icons/progress_icon/iconsax-activity.svg',
                                    label: muscleLabel,
                                    value: muscleValue,
                                  ),
                                ),
                                SizedBox(
                                  height: 21.h,
                                  child: _MiniMetricRow(
                                    iconPath:
                                        'assets/images/icons/progress_icon/iconsax-paragraphspacing.svg',
                                    label: waistLabel,
                                    value: waistValue,
                                  ),
                                ),
                                SizedBox(
                                  height: 21.h,
                                  child: _MiniMetricRow(
                                    iconPath:
                                        'assets/images/icons/progress_icon/iconsax-weight (1).svg',
                                    label: fatLabel,
                                    value: fatValue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        Row(
          children: [
            Expanded(
              child: _SummaryMiniCard(
                bgColor: const Color(0xFFCAFFE2),
                iconPath:
                    'assets/images/icons/progress_icon/iconsax-thorchain-(rune).svg',
                title: movementLabel,
                value: movementValue,
              ),
            ),
            SizedBox(width: 6.w),
            Expanded(
              child: _SummaryMiniCard(
                bgColor: const Color(0xFFE1FBFF),
                iconPath:
                    'assets/images/icons/progress_icon/iconsax-ai-sand-timer.svg',
                title: durationLabel,
                value: durationValue,
              ),
            ),
            SizedBox(width: 6.w),
            Expanded(
              child: _SummaryMiniCard(
                bgColor: const Color(0xFFCAFFE2),
                iconPath: 'assets/images/icons/progress_icon/iconsax-award.svg',
                title: successLabel,
                value: successValue,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MiniMetricRow extends StatelessWidget {
  const _MiniMetricRow({
    required this.iconPath,
    required this.label,
    required this.value,
  });

  final String iconPath;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(iconPath, width: 14.w, height: 14.w),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.leagueSpartan(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  height: 0.9,
                  color: const Color(0xFF575353),
                ),
              ),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.leagueSpartan(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  height: 0.9,
                  color: const Color(0xFF1DCEE9),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CompletedActivityRingGauge extends StatelessWidget {
  const _CompletedActivityRingGauge({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 87.w,
      height: 87.h,
      child: CustomPaint(
        painter: _CompletedActivityRingPainter(
          progress: value.clamp(0.0, 1.0),
          backgroundColor: Colors.white,
          progressColor: const Color(0xFF181818),
          strokeWidth: 10.w,
        ),
      ),
    );
  }
}

class _CompletedActivityRingPainter extends CustomPainter {
  _CompletedActivityRingPainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  final double progress;
  final Color backgroundColor;
  final Color progressColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = (81.75.w / 2) - strokeWidth / 2;
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);

    final backgroundPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..color = backgroundColor;

    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..color = progressColor;

    const startAngle = 145 * math.pi / 180;
    const totalSweep = 250 * math.pi / 180;
    canvas.drawArc(rect, startAngle, totalSweep, false, backgroundPaint);
    canvas.drawArc(
      rect,
      startAngle,
      totalSweep * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CompletedActivityRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

class _SummaryMiniCard extends StatelessWidget {
  const _SummaryMiniCard({
    required this.bgColor,
    required this.iconPath,
    required this.title,
    required this.value,
  });

  final Color bgColor;
  final String iconPath;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 96.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.leagueSpartan(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 6.h),
          SvgPicture.asset(iconPath, width: 36.w, height: 36.w),
          SizedBox(height: 6.h),
          Text(
            value,
            style: GoogleFonts.leagueSpartan(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.iconPath,
    required this.label,
    required this.value,
  });

  final String iconPath;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 342.w,
      height: 40.h,
      padding: EdgeInsets.symmetric(horizontal: 11.w),
      decoration: BoxDecoration(
        color: const Color(0xFFEEFDFF),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Container(
            width: 28.w,
            height: 28.w,
            decoration: BoxDecoration(
              color: const Color(0xFFEEFDFF),
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(14.r),
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(iconPath, width: 14.w, height: 14.w),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.leagueSpartan(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.leagueSpartan(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF13A3B9),
            ),
          ),
        ],
      ),
    );
  }
}

class _GeneralCaloriesTrendCard extends StatelessWidget {
  const _GeneralCaloriesTrendCard({
    required this.iconPath,
    required this.title,
    required this.value,
  });

  final String iconPath;

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    const fillHeights = <double>[
      39,
      46,
      29,
      36,
      44,
      42,
      30,
      48,
      41,
      23,
      37,
      18,
      36,
      46,
    ];

    return Container(
      width: 342.w,
      height: 112.h,
      padding: EdgeInsets.fromLTRB(15.w, 7.h, 15.w, 7.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFF1F1F1)),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(iconPath, width: 14.w, height: 14.w),
              SizedBox(width: 3.w),
              Flexible(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.leagueSpartan(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    height: 11 / 12,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Text(
            value,
            style: GoogleFonts.leagueSpartan(
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
              height: 18 / 20,
            ),
          ),
          SizedBox(height: 7.h),
          SizedBox(
            width: 231.w,
            height: 53.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: fillHeights.asMap().entries.map((entry) {
                final index = entry.key;
                final fillHeight = entry.value;
                return Padding(
                  padding: EdgeInsets.only(
                    right: index == fillHeights.length - 1 ? 0 : 7.w,
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: 10.w,
                      height: 53.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD3FFE1),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.r),
                          topRight: Radius.circular(20.r),
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: 10.w,
                          height: fillHeight.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFF32EA6E),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.r),
                              topRight: Radius.circular(20.r),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _GeneralBodyMetricsCard extends StatelessWidget {
  const _GeneralBodyMetricsCard({
    required this.muscleLabel,
    required this.muscleValue,
    required this.waistLabel,
    required this.waistValue,
    required this.fatLabel,
    required this.fatValue,
  });

  final String muscleLabel;
  final String muscleValue;
  final String waistLabel;
  final String waistValue;
  final String fatLabel;
  final String fatValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 342.w,
      height: 112.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFF1F1F1)),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _GeneralCircleMetric(
            label: muscleLabel,
            value: muscleValue,
            width: 97.w,
            progress: 0.86,
          ),
          _GeneralCircleMetric(
            label: waistLabel,
            value: waistValue,
            width: 105.w,
            progress: 0.84,
          ),
          _GeneralCircleMetric(
            label: fatLabel,
            value: fatValue,
            width: 97.w,
            progress: 0.82,
          ),
        ],
      ),
    );
  }
}

class _GeneralCircleMetric extends StatelessWidget {
  const _GeneralCircleMetric({
    required this.label,
    required this.value,
    required this.width,
    required this.progress,
  });

  final String label;
  final String value;
  final double width;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const labelBlockHeightFactor = 22.0;
          const gapFactor = 3.0;
          final baseRingDiameter = (constraints.maxWidth * 0.66)
              .clamp(58.w, 72.w)
              .toDouble();
          final maxRingByHeight = constraints.hasBoundedHeight
              ? (constraints.maxHeight - labelBlockHeightFactor.h - gapFactor.h)
                    .clamp(44.w, 200.w)
                    .toDouble()
              : baseRingDiameter;
          final ringDiameter = baseRingDiameter > maxRingByHeight
              ? maxRingByHeight
              : baseRingDiameter;
          final ringStroke = (ringDiameter * 0.075).clamp(4.w, 6.w).toDouble();

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: ringDiameter,
                height: ringDiameter,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: progress,
                      strokeWidth: ringStroke,
                      strokeCap: StrokeCap.round,
                      backgroundColor: const Color(0xFFD3FFE1),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF32EA6E),
                      ),
                    ),
                    Text(
                      value,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.leagueSpartan(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3.h),
              SizedBox(
                height: 22.h,
                child: Center(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.leagueSpartan(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _RewardCard extends StatelessWidget {
  const _RewardCard({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 338.w,
          constraints: BoxConstraints(minHeight: 62.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFEFE),
            border: Border.all(color: const Color(0xFFF1F1F1)),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.leagueSpartan(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.leagueSpartan(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 20.w,
          top: 10.h,
          child: Text('⚡️', style: TextStyle(fontSize: 14.sp)),
        ),
        Positioned(
          left: 48.w,
          top: 6.h,
          child: Text('💥', style: TextStyle(fontSize: 10.sp)),
        ),
        Positioned(
          left: 44.w,
          bottom: 8.h,
          child: Text('🤩', style: TextStyle(fontSize: 14.sp)),
        ),
        Positioned(
          right: 22.w,
          top: 8.h,
          child: Text('🎉', style: TextStyle(fontSize: 14.sp)),
        ),
        Positioned(
          right: 28.w,
          bottom: 8.h,
          child: Text('🛍️', style: TextStyle(fontSize: 14.sp)),
        ),
      ],
    );
  }
}

class _GoalInfoCard extends StatelessWidget {
  const _GoalInfoCard({
    required this.iconPath,
    required this.title,
    required this.subtitle,
    required this.editIconPath,
    required this.selectedGoalIndex,
    required this.goalOptions,
    required this.onGoalChanged,
  });

  final String iconPath;
  final String title;
  final String subtitle;
  final String editIconPath;
  final int selectedGoalIndex;
  final List<String> goalOptions;
  final ValueChanged<int> onGoalChanged;

  @override
  Widget build(BuildContext context) {
    final editButtonKey = GlobalKey();

    return Container(
      width: 342.w,
      constraints: BoxConstraints(minHeight: 92.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFEDEDED)),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 60.w,
            height: 52.h,
            child: SvgPicture.asset(
              iconPath,
              fit: BoxFit.contain,
              alignment: Alignment.centerLeft,
              clipBehavior: Clip.none,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.leagueSpartan(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.leagueSpartan(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          InkWell(
            onTap: () async {
              final editContext = editButtonKey.currentContext;
              if (editContext == null) {
                return;
              }

              final buttonRenderObject = editContext.findRenderObject();
              if (buttonRenderObject is! RenderBox) {
                return;
              }

              final overlayRenderObject = Overlay.of(
                context,
              ).context.findRenderObject();
              if (overlayRenderObject is! RenderBox) {
                return;
              }

              final overlayBox = overlayRenderObject;
              final buttonTopLeft = buttonRenderObject.localToGlobal(
                Offset.zero,
                ancestor: overlayBox,
              );
              final buttonSize = buttonRenderObject.size;

              final popupWidth = 85.w;
              final popupHeight = 82.h;
              final left =
                  (buttonTopLeft.dx + buttonSize.width + 14.w - popupWidth)
                      .clamp(8.0, overlayBox.size.width - popupWidth - 8.0)
                      .toDouble();
              final top = (buttonTopLeft.dy + buttonSize.height - 1.h)
                  .clamp(8.0, overlayBox.size.height - popupHeight - 8.0)
                  .toDouble();

              final selected = await showMenu<String>(
                context: context,
                color: const Color(0xFFD3FFE1),
                elevation: 0,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.r),
                  side: const BorderSide(
                    color: Color.fromRGBO(235, 235, 235, 0.11),
                  ),
                ),
                menuPadding: EdgeInsets.zero,
                constraints: BoxConstraints.tightFor(
                  width: popupWidth,
                  height: popupHeight,
                ),
                position: RelativeRect.fromLTRB(
                  left,
                  top,
                  overlayBox.size.width - left - popupWidth,
                  overlayBox.size.height - top - popupHeight,
                ),
                items: goalOptions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final goal = entry.value;
                  final highlighted = index == selectedGoalIndex;
                  final rowHeights = [20.h, 19.h, 20.h, 23.h];
                  final rowHeight = rowHeights[index];
                  return PopupMenuItem<String>(
                    value: goal,
                    height: rowHeight,
                    padding: EdgeInsets.zero,
                    child: SizedBox(
                      height: rowHeight,
                      child: Container(
                        alignment: Alignment.center,
                        color: highlighted
                            ? const Color(0xFF32EA6E)
                            : Colors.transparent,
                        child: Text(
                          goal,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.leagueSpartan(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400,
                            height: 1,
                            letterSpacing: -0.11,
                            color: highlighted
                                ? Colors.white
                                : const Color(0xFF302F2F),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );

              if (selected != null) {
                final newIndex = goalOptions.indexOf(selected);
                if (newIndex != -1) {
                  onGoalChanged(newIndex);
                }
              }
            },
            borderRadius: BorderRadius.circular(14.r),
            child: Container(
              key: editButtonKey,
              width: 28.w,
              height: 28.w,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF4BFE84),
                    Color(0xFF88F3CF),
                    Color(0xFF5AE3F7),
                  ],
                  stops: [0.0553, 0.7147, 1.0],
                ),
                borderRadius: BorderRadius.circular(14.r),
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                editIconPath,
                width: 16.w,
                height: 16.w,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WaterCard extends StatelessWidget {
  const _WaterCard({
    required this.iconPath,
    required this.title,
    required this.subtitle,
    required this.count,
    required this.onMinus,
    required this.onPlus,
  });

  final String iconPath;
  final String title;
  final String subtitle;
  final int count;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 342.w,
      constraints: BoxConstraints(minHeight: 92.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFEDEDED)),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(iconPath, width: 44.w, height: 52.h),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _CounterButton(icon: Icons.remove, onTap: onMinus),
              SizedBox(width: 6.w),
              Container(
                width: 22.w,
                height: 22.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFF2ED3EC),
                  borderRadius: BorderRadius.circular(11.r),
                ),
                child: Text(
                  '$count',
                  style: GoogleFonts.montserrat(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(width: 6.w),
              _CounterButton(icon: Icons.add, onTap: onPlus),
            ],
          ),
        ],
      ),
    );
  }
}

class _CounterButton extends StatelessWidget {
  const _CounterButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(11.r),
      child: Container(
        width: 22.w,
        height: 22.w,
        decoration: BoxDecoration(
          color: const Color(0xFFEEFDFF),
          borderRadius: BorderRadius.circular(11.r),
        ),
        child: Icon(icon, size: 14.w, color: Colors.black),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.iconBase});

  final String iconBase;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: 390.w,
      height: 68.h,
      decoration: BoxDecoration(
        color: const Color(0xFFFDFDFD),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.r),
          topRight: Radius.circular(10.r),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.08),
            blurRadius: 1,
            offset: Offset(0, -0.6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _BottomItem(
            iconPath: '$iconBase/iconsax-home-2.svg',
            label: l10n.homeTabHome,
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(AppRoutes.home),
          ),
          SizedBox(width: 4.w),
          _BottomItem(
            iconPath: '$iconBase/iconsax-health.svg',
            label: l10n.homeTabWorkout,
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(AppRoutes.workout),
          ),
          SizedBox(width: 4.w),
          _BottomItem(
            iconPath: '$iconBase/iconsax-chart-square.svg',
            label: l10n.homeTabProgress,
            active: true,
            onTap: () {},
          ),
          SizedBox(width: 4.w),
          _BottomItem(
            iconPath: '$iconBase/iconsax-user.svg',
            label: l10n.homeTabProfile,
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(AppRoutes.profile),
          ),
        ],
      ),
    );
  }
}

class _BottomItem extends StatelessWidget {
  const _BottomItem({
    required this.iconPath,
    required this.label,
    this.active = false,
    this.onTap,
  });

  final String iconPath;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 94.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 28.w,
              height: 28.w,
              colorFilter: active
                  ? const ColorFilter.mode(Color(0xFF01A2F1), BlendMode.srcIn)
                  : null,
            ),
            SizedBox(height: 7.h),
            Text(
              label,
              style: GoogleFonts.leagueSpartan(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: active ? const Color(0xFF01A2F1) : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
