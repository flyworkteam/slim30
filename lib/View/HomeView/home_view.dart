import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slim30/Core/Routes/app_routes.dart';
import 'package:slim30/Riverpod/Models/app_models.dart';
import 'package:slim30/Riverpod/Providers/backend_providers.dart';
import 'package:slim30/Riverpod/Providers/workout/workout_program_provider.dart';
import 'package:slim30/l10n/generated/app_localizations.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  static const _iconBase = 'assets/images/icons/homePage';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(homeDashboardProvider);
    final completedDaysAsync = ref.watch(completedProgressDaysProvider);
    final completedDays = completedDaysAsync.valueOrNull ?? <int>{};

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
                      _Header(
                        iconBase: _iconBase,
                        dashboard: dashboardAsync.valueOrNull,
                      ),
                      SizedBox(height: 34.h),
                      _DayStrip(completedDays: completedDays),
                      SizedBox(height: 40.h),
                      _TodayWorkoutCard(),
                      SizedBox(height: 40.h),
                      _CompletedDays(completedDays: completedDays),
                      SizedBox(height: 40.h),
                      _ProgressSection(
                        iconBase: _iconBase,
                        dashboard: dashboardAsync.valueOrNull,
                        completedDays: completedDays,
                      ),
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
  const _Header({required this.iconBase, required this.dashboard});

  final String iconBase;
  final HomeDashboardModel? dashboard;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final profile = dashboard?.profile;
    final profileName = (profile?.name.trim().isNotEmpty ?? false)
        ? profile!.name.trim()
        : 'User';
    final greetingBase = l10n.homeGreeting.trim();
    final greetingLine = greetingBase.toLowerCase().contains('evrim')
        ? profileName
        : '$greetingBase $profileName'.trim();
    final profileAvatarUrl = profile?.avatarUrl?.trim();

    return Row(
      children: [
        _HeaderAvatar(name: profileName, avatarUrl: profileAvatarUrl),
        SizedBox(width: 9.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greetingLine,
                style: GoogleFonts.leagueSpartan(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  height: 13 / 14,
                ),
              ),
              SizedBox(height: 7.h),
              Text(
                profile?.email?.trim().isNotEmpty == true
                    ? profile!.email!.trim()
                    : l10n.homeWelcome,
                style: GoogleFonts.leagueSpartan(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  height: 11 / 12,
                ),
              ),
            ],
          ),
        ),
        _PremiumBadge(
          iconBase: iconBase,
          isPremium: true,
          label: l10n.homePremium,
        ),
        SizedBox(width: 8.w),
        InkWell(
          onTap: () => Navigator.of(context).pushNamed(AppRoutes.notifications),
          borderRadius: BorderRadius.circular(30.r),
          child: Container(
            width: 34.w,
            height: 34.w,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(30.r),
            ),
            padding: EdgeInsets.all(7.w),
            child: SvgPicture.asset('$iconBase/iconsax-notification-bing.svg'),
          ),
        ),
      ],
    );
  }
}

class _HeaderAvatar extends StatelessWidget {
  const _HeaderAvatar({required this.name, required this.avatarUrl});

  final String name;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final initials = _initials(name);

    return Container(
      width: 38.w,
      height: 38.w,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFF5F5F5),
      ),
      clipBehavior: Clip.antiAlias,
      child: avatarUrl != null && avatarUrl!.isNotEmpty
          ? Image.network(
              avatarUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _AvatarInitials(initials: initials);
              },
            )
          : _AvatarInitials(initials: initials),
    );
  }

  String _initials(String raw) {
    final parts = raw
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList(growable: false);

    if (parts.isEmpty) {
      return 'U';
    }

    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }
}

class _AvatarInitials extends StatelessWidget {
  const _AvatarInitials({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF62DCF4), Color(0xFF66F393)],
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: GoogleFonts.leagueSpartan(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            height: 1,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _PremiumBadge extends StatelessWidget {
  const _PremiumBadge({
    required this.iconBase,
    required this.isPremium,
    required this.label,
  });

  final String iconBase;
  final bool isPremium;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 83.w,
      height: 28.h,
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
      child: Stack(
        children: [
          Positioned(
            left: 6.81.w,
            top: 8.8.h,
            width: 69.38.w,
            height: 12.h,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 1.h,
                  width: 18.38.w,
                  height: 11.h,
                  child: SvgPicture.asset(
                    '$iconBase/iconax-premium.svg',
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned(
                  left: 22.38.w,
                  top: 1.h,
                  width: 47.w,
                  height: 11.h,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      softWrap: false,
                      style: GoogleFonts.leagueSpartan(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        height: 11 / 12,
                        foreground: _badgeTextPaint(isPremium),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Paint _badgeTextPaint(bool isPremium) {
    final paint = Paint();
    if (isPremium) {
      paint.shader = const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Color(0xFFFFEECC), Color(0xFFAD9515)],
      ).createShader(const Rect.fromLTWH(0, 0, 47, 11));
      return paint;
    }

    paint.color = const Color(0xFF9A7808);
    return paint;
  }
}

class _DayStrip extends StatelessWidget {
  const _DayStrip({required this.completedDays});

  final Set<int> completedDays;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final first = now.subtract(Duration(days: now.weekday - 1));
    final labels = [
      l10n.homeDayMonShort,
      l10n.homeDayTueShort,
      l10n.homeDayWedShort,
      l10n.homeDayThuShort,
      l10n.homeDayFriShort,
      l10n.homeDaySatShort,
      l10n.homeDaySunShort,
    ];

    final data = [
      for (var i = 0; i < 7; i++)
        (
          labels[i],
          '${first.add(Duration(days: i)).day}',
          completedDays.contains(i + 1),
        ),
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
                          l10n.homeTodayWorkoutTitle,
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
                              _WorkoutStat(
                                text: l10n.homeWorkoutMoves,
                                width: 45.w,
                              ),
                              SizedBox(width: 20.w),
                              _WorkoutLineDivider(),
                              SizedBox(width: 20.w),
                              _WorkoutStat(
                                text: l10n.homeWorkoutCalories,
                                width: 24.w,
                              ),
                              SizedBox(width: 20.w),
                              _WorkoutLineDivider(),
                              SizedBox(width: 20.w),
                              _WorkoutStat(
                                text: l10n.homeWorkoutDuration,
                                width: 39.w,
                              ),
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
                        l10n.homeStartNow,
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

class _CompletedDays extends StatelessWidget {
  const _CompletedDays({required this.completedDays});

  final Set<int> completedDays;

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
              final done = completedDays.contains(index + 1);
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
  const _ProgressSection({
    required this.iconBase,
    required this.dashboard,
    required this.completedDays,
  });

  final String iconBase;
  final HomeDashboardModel? dashboard;
  final Set<int> completedDays;

  String _formatKg(double value) {
    final trimmed = value.toStringAsFixed(1);
    return trimmed.endsWith('.0')
        ? trimmed.substring(0, trimmed.length - 2)
        : trimmed;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final summaryCompleted = dashboard?.completedDays ?? completedDays.length;
    final totalDays = (dashboard?.totalDays ?? 30).clamp(1, 30);
    final completionRate = ((dashboard?.completionRate ?? 0).toDouble())
        .clamp(0.0, 100.0)
        .toDouble();
    final calories = summaryCompleted * 140;
    final hydrationPercent = completionRate.round().clamp(0, 100);

    final profile = dashboard?.profile;
    final weight = profile?.weightKg;
    final targetWeight = profile?.targetWeightKg;
    final hasWeightGoal =
        weight != null && targetWeight != null && weight > targetWeight;
    final weightToGoal = hasWeightGoal ? (weight - targetWeight) : 0.0;
    final weightValueText = hasWeightGoal
        ? '-${_formatKg(weightToGoal)} kg'
        : '0 kg';

    final successPercent = completionRate.round();
    final completionProgress = completionRate / 100;

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
            Expanded(
              child: _CaloriesCard(
                iconBase: iconBase,
                calories: calories,
                hydrationPercent: hydrationPercent,
              ),
            ),
            SizedBox(width: 9.w),
            Expanded(
              child: _MiddleMetricsCard(
                iconBase: iconBase,
                weightValueText: weightValueText,
                streakDays: summaryCompleted,
              ),
            ),
            SizedBox(width: 9.w),
            Expanded(
              child: _RightMetricsCard(
                iconBase: iconBase,
                completedActivities: summaryCompleted,
                totalDays: totalDays,
                completionProgress: completionProgress,
                successPercent: successPercent,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CaloriesCard extends StatelessWidget {
  const _CaloriesCard({
    required this.iconBase,
    required this.calories,
    required this.hydrationPercent,
  });
  final String iconBase;
  final int calories;
  final int hydrationPercent;

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
                '$calories kcal',
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
                        '%$hydrationPercent',
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
  const _MiddleMetricsCard({
    required this.iconBase,
    required this.weightValueText,
    required this.streakDays,
  });
  final String iconBase;
  final String weightValueText;
  final int streakDays;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        _SmallMetricCard(
          bg: const Color(0xFFE1FBFF),
          icon: '$iconBase/iconsax-weight.svg',
          title: l10n.homeWeightLost,
          value: weightValueText,
          subtitle: l10n.homeAmazing,
          subtitleColor: const Color(0xFF1EBFDA),
        ),
        SizedBox(height: 11.h),
        _SmallMetricCard(
          bg: const Color(0xFFCAFFE2),
          icon: '$iconBase/iconsax-fire.svg',
          title: l10n.homeStreaks,
          value: '$streakDays',
          subtitle: l10n.homeDontBreakChain,
          subtitleColor: const Color(0xFF17CD52),
        ),
      ],
    );
  }
}

class _RightMetricsCard extends StatelessWidget {
  const _RightMetricsCard({
    required this.iconBase,
    required this.completedActivities,
    required this.totalDays,
    required this.completionProgress,
    required this.successPercent,
  });
  final String iconBase;
  final int completedActivities;
  final int totalDays;
  final double completionProgress;
  final int successPercent;

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
                '$completedActivities / $totalDays',
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
                          value: completionProgress,
                          strokeWidth: 6,
                          backgroundColor: const Color(0xFFA4FFC8),
                          color: const Color(0xFF32EA6E),
                        ),
                      ),
                      Text(
                        '%$successPercent',
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
                        '%$successPercent',
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
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(AppRoutes.workout),
          ),
          SizedBox(width: 4.w),
          _BottomItem(
            iconPath: '$iconBase/iconsax-chart-square.svg',
            label: l10n.homeTabProgress,
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(AppRoutes.progress),
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
