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
  String _stepsGoal = 'Gunde 10 Bin';

  Future<void> _openStepsGoalPicker(BuildContext context) async {
    final selected = await showDialog<String>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.08),
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 85.w,
              height: 82.h,
              decoration: BoxDecoration(
                color: const Color(0xFFD3FFE1),
                border: Border.all(
                  color: const Color.fromRGBO(235, 235, 235, 0.11),
                ),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Column(
                children: [
                  _GoalRow(
                    text: 'Gunde 5 Bin',
                    highlighted: false,
                    onTap: () => Navigator.of(dialogContext).pop('Gunde 5 Bin'),
                  ),
                  _GoalRow(
                    text: 'Gunde 10 Bin',
                    highlighted: true,
                    onTap: () =>
                        Navigator.of(dialogContext).pop('Gunde 10 Bin'),
                  ),
                  _GoalRow(
                    text: 'Haftada 40 Bin',
                    highlighted: false,
                    onTap: () =>
                        Navigator.of(dialogContext).pop('Haftada 40 Bin'),
                  ),
                  _GoalRow(
                    text: 'Haftada 50 Bin',
                    highlighted: false,
                    onTap: () =>
                        Navigator.of(dialogContext).pop('Haftada 50 Bin'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (selected != null && mounted) {
      setState(() {
        _stepsGoal = selected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
                        _StreakAndPerformanceRow(
                          streakDays: '7',
                          streakLabel: l10n.homeDontBreakChain,
                          overallTitle: l10n.progressOverallPerformanceTitle,
                          overallSubtitle:
                              l10n.progressOverallPerformanceSubtitle,
                          percentage: 82,
                        ),
                        SizedBox(height: 24.h),
                        _SectionTitle(text: l10n.progressDailyWorkoutSummary),
                        SizedBox(height: 15.h),
                        _DailySummaryCard(
                          completedTitle: l10n.progressCompletedActivity,
                          completedValue: '6/8',
                          caloriesTitle: l10n.progressCaloriesBurnedLabel,
                          caloriesValue: '140 kcal',
                          muscleLabel: l10n.progressMuscleGainLabel,
                          muscleValue: '+2.1',
                          waistLabel: l10n.progressWaistChangeLabel,
                          waistValue: '-3.2',
                          fatLabel: l10n.progressBodyFatLabel,
                          fatValue: '-4%',
                          movementLabel: l10n.progressMovementCountLabel,
                          movementValue: '20',
                          durationLabel: l10n.progressDurationLabel,
                          durationValue:
                              '40 ${l10n.homeWorkoutDuration.split(' ').last}',
                          successLabel: l10n.progressSuccessPercentLabel,
                          successValue: '%69',
                        ),
                        SizedBox(height: 24.h),
                        _SectionTitle(text: l10n.progressGeneralStatusTitle),
                        SizedBox(height: 15.h),
                        _StatTile(
                          iconPath: '$_progressIconBase/iconsax-weight.svg',
                          label: l10n.progressWeightLostLabel,
                          value: '-3.4 kg',
                        ),
                        SizedBox(height: 10.h),
                        _StatTile(
                          iconPath:
                              '$_progressIconBase/iconsax-activity (1).svg',
                          label: l10n.progressHeartRateLabel,
                          value: '80 BPM',
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
                          value:
                              '8 ${l10n.homeWorkoutDuration.split(' ').last}',
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
                              subtitle: _stepsGoal,
                              editIconPath:
                                  '$_progressIconBase/Clip path group.svg',
                              onEditTap: () => _openStepsGoalPicker(context),
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
    return Container(
      width: 342.w,
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: const Color(0xFF97F1FF),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.leagueSpartan(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 18.w),
            decoration: BoxDecoration(
              color: const Color(0xFF84ECFF),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: _WorkoutStat(text: moves)),
                _DividerDot(),
                Expanded(child: _WorkoutStat(text: calories)),
                _DividerDot(),
                Expanded(child: _WorkoutStat(text: duration)),
              ],
            ),
          ),
          SizedBox(height: 8.h),
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
              style: GoogleFonts.leagueSpartan(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF171717),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkoutStat extends StatelessWidget {
  const _WorkoutStat({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: GoogleFonts.leagueSpartan(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _DividerDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6.w),
      width: 4.w,
      height: 4.w,
      decoration: const BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _StreakAndPerformanceRow extends StatelessWidget {
  const _StreakAndPerformanceRow({
    required this.streakDays,
    required this.streakLabel,
    required this.overallTitle,
    required this.overallSubtitle,
    required this.percentage,
  });

  final String streakDays;
  final String streakLabel;
  final String overallTitle;
  final String overallSubtitle;
  final int percentage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/icons/progress_icon/iconsax-fire.svg',
                    width: 40.w,
                    height: 40.w,
                  ),
                  SizedBox(width: 8.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        streakDays,
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 4.h),
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE9FFF3),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Text(
                          streakLabel,
                          style: GoogleFonts.leagueSpartan(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        SizedBox(
          width: 95.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                overallTitle,
                textAlign: TextAlign.right,
                style: GoogleFonts.leagueSpartan(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                overallSubtitle,
                textAlign: TextAlign.right,
                style: GoogleFonts.leagueSpartan(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w300,
                  color: const Color(0xFF646464),
                ),
              ),
              SizedBox(height: 6.h),
              SizedBox(
                width: 74.w,
                height: 74.w,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: percentage / 100,
                      strokeWidth: 8.w,
                      backgroundColor: const Color(0xFFD3FFE1),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF32EA6E),
                      ),
                    ),
                    Text(
                      '%$percentage',
                      style: GoogleFonts.leagueSpartan(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
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
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 131.w,
              constraints: BoxConstraints(minHeight: 123.h),
              padding: EdgeInsets.fromLTRB(13.w, 14.h, 13.w, 10.h),
              decoration: BoxDecoration(
                color: const Color(0xFF97F1FF),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    completedTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.leagueSpartan(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      height: 1,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Center(
                    child: SizedBox(
                      width: 84.w,
                      height: 84.w,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: 6 / 8,
                            strokeWidth: 9.w,
                            backgroundColor: Colors.white,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF181818),
                            ),
                          ),
                          Text(
                            completedValue,
                            style: GoogleFonts.leagueSpartan(
                              fontSize: 26.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 7.w),
            Expanded(
              child: Container(
                constraints: BoxConstraints(minHeight: 123.h),
                padding: EdgeInsets.fromLTRB(12.w, 11.h, 12.w, 11.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFE1FBFF),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      caloriesValue,
                      style: GoogleFonts.leagueSpartan(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1DCEE9),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    _MiniMetricRow(
                      iconPath:
                          'assets/images/icons/progress_icon/iconsax-activity.svg',
                      label: muscleLabel,
                      value: muscleValue,
                    ),
                    SizedBox(height: 2.h),
                    _MiniMetricRow(
                      iconPath:
                          'assets/images/icons/progress_icon/iconsax-paragraphspacing.svg',
                      label: waistLabel,
                      value: waistValue,
                    ),
                    SizedBox(height: 2.h),
                    _MiniMetricRow(
                      iconPath:
                          'assets/images/icons/progress_icon/iconsax-weight (1).svg',
                      label: fatLabel,
                      value: fatValue,
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
      children: [
        SvgPicture.asset(iconPath, width: 14.w, height: 14.w),
        SizedBox(width: 3.w),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.leagueSpartan(
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF575353),
            ),
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          value,
          style: GoogleFonts.leagueSpartan(
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1DCEE9),
          ),
        ),
      ],
    );
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
    this.onEditTap,
  });

  final String iconPath;
  final String title;
  final String subtitle;
  final String editIconPath;
  final VoidCallback? onEditTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 342.w,
      constraints: BoxConstraints(minHeight: 92.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFD3FFE1),
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
            onTap: onEditTap,
            borderRadius: BorderRadius.circular(14.r),
            child: Container(
              width: 28.w,
              height: 28.w,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF4BFE84), Color(0xFF5AE3F7)],
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

class _GoalRow extends StatelessWidget {
  const _GoalRow({
    required this.text,
    required this.highlighted,
    required this.onTap,
  });

  final String text;
  final bool highlighted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 85.w,
        height: 19.h,
        alignment: Alignment.center,
        color: highlighted ? const Color(0xFF32EA6E) : Colors.transparent,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.leagueSpartan(
            fontSize: 10.sp,
            fontWeight: FontWeight.w400,
            height: 0.9,
            letterSpacing: -0.11,
            color: highlighted ? Colors.white : const Color(0xFF302F2F),
          ),
        ),
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
        color: const Color(0xFFE1FBFF),
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
            onTap: () {},
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
