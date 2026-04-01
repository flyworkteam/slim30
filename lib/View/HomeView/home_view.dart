import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slim30/Core/Routes/app_routes.dart';
import 'package:slim30/l10n/generated/app_localizations.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  static const _iconBase = 'assets/images/icons/homePage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: 390.w,
          child: Stack(
            children: [
              Positioned.fill(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(24.w, 102.h, 24.w, 100.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Header(iconBase: _iconBase),
                      SizedBox(height: 34.h),
                      _DayStrip(),
                      SizedBox(height: 40.h),
                      _TodayWorkoutCard(),
                      SizedBox(height: 40.h),
                      _CompletedDays(),
                      SizedBox(height: 40.h),
                      _ProgressSection(iconBase: _iconBase),
                      SizedBox(height: 40.h),
                      _ContinueSection(iconBase: _iconBase),
                      SizedBox(height: 40.h),
                      _MoodSection(),
                      SizedBox(height: 40.h),
                      _TransformationSection(),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _BottomBar(iconBase: _iconBase),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.iconBase});

  final String iconBase;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        CircleAvatar(
          radius: 19.r,
          backgroundImage: const AssetImage(
            'assets/images/f62810c637b67734e57a8bfb4985baec89b2e79e.jpg',
          ),
        ),
        SizedBox(width: 9.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.homeGreeting,
                style: GoogleFonts.leagueSpartan(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  height: 13 / 14,
                ),
              ),
              SizedBox(height: 7.h),
              Text(
                l10n.homeWelcome,
                style: GoogleFonts.leagueSpartan(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  height: 11 / 12,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 83.w,
          height: 28.h,
          padding: EdgeInsets.symmetric(horizontal: 7.w),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 251, 230, 0.2),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(207, 154, 74, 0.4),
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
            borderRadius: BorderRadius.circular(40.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SvgPicture.asset(
                '$iconBase/iconax-premium.svg',
                width: 18.w,
                height: 11.h,
              ),
              SizedBox(width: 4.w),
              Flexible(
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFFFFEECC), Color(0xFFAD9515)],
                  ).createShader(bounds),
                  child: Text(
                    l10n.homePremium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.leagueSpartan(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 8.w),
        Container(
          width: 34.w,
          height: 34.w,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(30.r),
          ),
          padding: EdgeInsets.all(7.w),
          child: SvgPicture.asset('$iconBase/iconsax-notification-bing.svg'),
        ),
      ],
    );
  }
}

class _DayStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final data = [
      (l10n.homeDayMonShort, '22', false),
      (l10n.homeDayTueShort, '23', false),
      (l10n.homeDayWedShort, '24', true),
      (l10n.homeDayThuShort, '25', false),
      (l10n.homeDayFriShort, '26', false),
      (l10n.homeDaySatShort, '27', false),
      (l10n.homeDaySunShort, '28', false),
    ];

    return SizedBox(
      height: 69.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: data
            .map((e) => _DayPill(day: e.$1, number: e.$2, selected: e.$3))
            .toList(),
      ),
    );
  }
}

class _DayPill extends StatelessWidget {
  const _DayPill({
    required this.day,
    required this.number,
    required this.selected,
  });

  final String day;
  final String number;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.w,
      height: 69.h,
      decoration: BoxDecoration(
        gradient: selected
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF4BFE84),
                  Color(0xFF88F3CF),
                  Color(0xFF5AE3F7),
                ],
              )
            : null,
        color: selected ? null : const Color(0xFFF2FDFF),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: const [
          BoxShadow(color: Color.fromRGBO(253, 238, 238, 0.41), blurRadius: 2),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: GoogleFonts.leagueSpartan(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: selected ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            number,
            style: GoogleFonts.leagueSpartan(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: selected ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _TodayWorkoutCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: 342.w,
      height: 154.h,
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: const Color(0xFF97F1FF),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.homeTodayWorkoutTitle,
            style: GoogleFonts.leagueSpartan(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            width: 240.w,
            height: 54.h,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _metricText(l10n.homeWorkoutMoves),
                _divider(),
                _metricText(l10n.homeWorkoutCalories),
                _divider(),
                _metricText(l10n.homeWorkoutDuration),
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
              l10n.homeStartNow,
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

  Widget _metricText(String text) {
    return SizedBox(
      width: 58.w,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.leagueSpartan(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          height: 13 / 14,
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 23,
      color: Colors.black,
      margin: const EdgeInsets.symmetric(horizontal: 12),
    );
  }
}

class _CompletedDays extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final days = [
      l10n.homeDayMonShort,
      l10n.homeDayTueShort,
      l10n.homeDayWedShort,
      l10n.homeDayThuShort,
      l10n.homeDayFriShort,
      l10n.homeDaySatShort,
      l10n.homeDaySunShort,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.homeCompletedDaysTitle,
          style: GoogleFonts.leagueSpartan(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 20.h),
        SizedBox(
          width: 328.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(days.length, (index) {
              final done = index < 3;
              return Column(
                children: [
                  Text(
                    days[index],
                    style: GoogleFonts.leagueSpartan(
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Container(
                    width: 28.w,
                    height: 28.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14.r),
                      gradient: done
                          ? const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF66F393),
                                Color(0xFF88F3CF),
                                Color(0xFFA3F3FF),
                              ],
                            )
                          : null,
                      color: done ? null : Colors.white,
                    ),
                    child: done
                        ? Icon(
                            Icons.check_rounded,
                            size: 16.sp,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ],
              );
            }),
          ),
        ),
        SizedBox(height: 20.h),
        Container(
          width: 342.w,
          height: 36.h,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: const Color(0xFFE9FFF3),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(
            l10n.homeKeepGoing,
            style: GoogleFonts.leagueSpartan(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProgressSection extends StatelessWidget {
  const _ProgressSection({required this.iconBase});

  final String iconBase;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.homeProgressTitle,
                style: GoogleFonts.leagueSpartan(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              width: 18.w,
              height: 18.w,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(9.r),
              ),
              child: Icon(Icons.chevron_right_rounded, size: 14.sp),
            ),
          ],
        ),
        SizedBox(height: 15.h),
        Row(
          children: [
            Expanded(child: _CaloriesCard(iconBase: iconBase)),
            SizedBox(width: 9.w),
            Expanded(child: _MiddleMetricsCard(iconBase: iconBase)),
            SizedBox(width: 9.w),
            Expanded(child: _RightMetricsCard(iconBase: iconBase)),
          ],
        ),
      ],
    );
  }
}

class _CaloriesCard extends StatelessWidget {
  const _CaloriesCard({required this.iconBase});
  final String iconBase;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Container(
          height: 127.h,
          padding: EdgeInsets.all(7.w),
          decoration: BoxDecoration(
            color: const Color(0xFFCAFFE2),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: const Color(0xFFF9F9F9)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    '$iconBase/iconsax-weight.svg',
                    width: 14.w,
                    height: 14.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      l10n.homeCaloriesBurned,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.leagueSpartan(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 11.h),
              Text(
                '140 kcal',
                style: GoogleFonts.leagueSpartan(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 11.h),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    39.0,
                    46.0,
                    29.0,
                    36.0,
                    44.0,
                    42.0,
                    48.0,
                  ].map((h) => _MiniBar(height: h)).toList(),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 9.h),
        Container(
          height: 35.h,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: const Color(0xFFE1FBFF),
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(color: const Color(0xFFF9F9F9)),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                '$iconBase/iconsax-drop.svg',
                width: 14.w,
                height: 14.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: FittedBox(
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.scaleDown,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.homeHydrationRate,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          height: 9 / 10,
                        ),
                      ),
                      Text(
                        '%72',
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          height: 11 / 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MiniBar extends StatelessWidget {
  const _MiniBar({required this.height});
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6.w,
      decoration: BoxDecoration(
        color: const Color(0xFFA4FFC8),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: 6.w,
          height: height.h,
          decoration: BoxDecoration(
            color: const Color(0xFF32EA6E),
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),
      ),
    );
  }
}

class _MiddleMetricsCard extends StatelessWidget {
  const _MiddleMetricsCard({required this.iconBase});
  final String iconBase;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        _SmallMetricCard(
          bg: const Color(0xFFE1FBFF),
          icon: '$iconBase/iconsax-weight.svg',
          title: l10n.homeWeightLost,
          value: '-3.4 kg',
          subtitle: l10n.homeAmazing,
          subtitleColor: const Color(0xFF1EBFDA),
        ),
        SizedBox(height: 11.h),
        _SmallMetricCard(
          bg: const Color(0xFFCAFFE2),
          icon: '$iconBase/iconsax-fire.svg',
          title: l10n.homeStreaks,
          value: '7 Gün',
          subtitle: l10n.homeDontBreakChain,
          subtitleColor: const Color(0xFF17CD52),
        ),
      ],
    );
  }
}

class _RightMetricsCard extends StatelessWidget {
  const _RightMetricsCard({required this.iconBase});
  final String iconBase;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Container(
          height: 140.h,
          width: double.infinity,
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: const Color(0xFFCAFFE2),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: const Color(0xFFF9F9F9)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    '$iconBase/iconsax-activity.svg',
                    width: 14.w,
                    height: 14.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      l10n.homeTotalCompleted,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.leagueSpartan(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              Text(
                '12 aktivite',
                style: GoogleFonts.leagueSpartan(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 42.w,
                        height: 42.w,
                        child: CircularProgressIndicator(
                          value: 0.32,
                          strokeWidth: 6,
                          backgroundColor: const Color(0xFFA4FFC8),
                          color: const Color(0xFF32EA6E),
                        ),
                      ),
                      Text(
                        '%32',
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 9.h),
        Container(
          width: double.infinity,
          height: 50.h,
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: const Color(0xFFE1FBFF),
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(color: const Color(0xFFF9F9F9)),
          ),
          child: Row(
            children: [
              Expanded(
                child: FittedBox(
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.scaleDown,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.homeSuccessRate,
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        '%69',
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SvgPicture.asset(
                '$iconBase/iconsax-award.svg',
                width: 20.w,
                height: 20.w,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SmallMetricCard extends StatelessWidget {
  const _SmallMetricCard({
    required this.bg,
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.subtitleColor,
  });

  final Color bg;
  final String icon;
  final String title;
  final String value;
  final String subtitle;
  final Color subtitleColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 84.h),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFF9F9F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(icon, width: 14.w, height: 14.w),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.leagueSpartan(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 11.h),
          Text(
            value,
            style: GoogleFonts.leagueSpartan(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 9.h),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.leagueSpartan(
              fontSize: 9.sp,
              fontWeight: FontWeight.w400,
              color: subtitleColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContinueSection extends StatelessWidget {
  const _ContinueSection({required this.iconBase});

  final String iconBase;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.homeContinueTitle,
          style: GoogleFonts.leagueSpartan(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 15.h),
        Container(
          width: 342.w,
          height: 158.h,
          padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 13.h),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFF1F1F1)),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 24.h,
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFF62DDF2),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            l10n.homeWorkoutTag,
                            style: GoogleFonts.leagueSpartan(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF212121),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          l10n.homeCurrentExercise,
                          style: GoogleFonts.leagueSpartan(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            SvgPicture.asset(
                              '$iconBase/iconsax-weight.svg',
                              width: 14.w,
                              height: 14.w,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              l10n.homeSetsAndTime,
                              style: GoogleFonts.leagueSpartan(
                                fontSize: 12.sp,
                                color: const Color(0xFF535353),
                              ),
                            ),
                            SizedBox(width: 14.w),
                            SvgPicture.asset(
                              '$iconBase/iconsax-clock.svg',
                              width: 14.w,
                              height: 14.w,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              l10n.homeRestBetweenSets,
                              style: GoogleFonts.leagueSpartan(
                                fontSize: 12.sp,
                                color: const Color(0xFF535353),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 68.w,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 61.w,
                          height: 61.w,
                          child: CircularProgressIndicator(
                            value: 0.48,
                            strokeWidth: 6,
                            backgroundColor: const Color(0xFFD3FFE1),
                            color: const Color(0xFF32EA6E),
                          ),
                        ),
                        Text(
                          '%48',
                          style: GoogleFonts.leagueSpartan(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 9.h),
              Container(
                width: 295.w,
                height: 27.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.r),
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFF62DCF4),
                      Color(0xFF64E6C4),
                      Color(0xFF66F393),
                    ],
                  ),
                ),
                child: Text(
                  l10n.homeContinueButton,
                  style: GoogleFonts.leagueSpartan(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MoodSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.homeMoodTitle,
                style: GoogleFonts.leagueSpartan(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  height: 1,
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  _MoodChip(
                    emoji: '🥱',
                    label: l10n.homeMoodTired,
                    selected: false,
                  ),
                  _MoodChip(
                    emoji: '🤩',
                    label: l10n.homeMoodEnergetic,
                    selected: true,
                  ),
                  _MoodChip(
                    emoji: '💪🏻',
                    label: l10n.homeMoodStrong,
                    selected: false,
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Image.asset(
                'assets/images/87bd5d4846d8036313a92142cf813f49c5bea8a0.jpg',
                width: 98.w,
                height: 73.h,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              l10n.homeProgramName,
              style: GoogleFonts.leagueSpartan(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '9/30',
              style: GoogleFonts.leagueSpartan(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MoodChip extends StatelessWidget {
  const _MoodChip({
    required this.emoji,
    required this.label,
    required this.selected,
  });

  final String emoji;
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 49.w,
      height: 36.h,
      margin: EdgeInsets.only(right: 4.w),
      decoration: BoxDecoration(
        gradient: selected
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF4BFE84),
                  Color(0xFF88F3CF),
                  Color(0xFF5AE3F7),
                ],
              )
            : null,
        color: selected ? null : const Color(0xFFDFFFE9),
        borderRadius: BorderRadius.circular(3.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              emoji,
              style: GoogleFonts.leagueSpartan(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: GoogleFonts.leagueSpartan(
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TransformationSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.homeTransformationTitle,
          style: GoogleFonts.leagueSpartan(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 15.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _TransformMetric(value: '+2.1', label: l10n.homeMuscleGain),
            _TransformMetric(value: '-3.2', label: l10n.homeWaistChange),
            _TransformMetric(value: '-4%', label: l10n.homeBodyFatChange),
          ],
        ),
      ],
    );
  }
}

class _TransformMetric extends StatelessWidget {
  const _TransformMetric({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 104.w,
      child: Column(
        children: [
          Container(
            width: 58.w,
            height: 58.w,
            decoration: BoxDecoration(
              color: const Color(0xFF32EA6E),
              borderRadius: BorderRadius.circular(29.r),
            ),
            alignment: Alignment.center,
            child: Text(
              value,
              style: GoogleFonts.leagueSpartan(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.leagueSpartan(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              height: 11 / 10,
            ),
          ),
        ],
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
            active: true,
          ),
          SizedBox(width: 4.w),
          _BottomItem(
            iconPath: '$iconBase/iconsax-health.svg',
            label: l10n.homeTabWorkout,
          ),
          SizedBox(width: 4.w),
          _BottomItem(
            iconPath: '$iconBase/iconsax-chart-square.svg',
            label: l10n.homeTabProgress,
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
