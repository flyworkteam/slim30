import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slim30/Core/Routes/app_routes.dart';
import 'package:slim30/Riverpod/Providers/workout/workout_program_provider.dart';
import 'package:slim30/l10n/generated/app_localizations.dart';
import 'package:slim30/View/WorkoutView/workout_program_view.dart';

class WorkoutView extends ConsumerWidget {
  const WorkoutView({super.key});

  static const _iconBase = 'assets/images/icons/homePage';

  static const List<String> _dayTitlesTr = [
    'Yag Yakim Aktivasyon',
    'Alt Vucut + Kardiyo',
    'HIIT Yakici',
    'Aktif Dinlenme',
    'Guc + Kardiyo Artisi',
    'Alt Vucut Yakici',
    'HIIT Metabolik Sok',
    'Aktif Dinlenme',
    'Full Body Metabolik',
    'Alt Vucut Guc + Kardiyo',
    'HIIT Ileri Seviye',
    'Aktif Dinlenme',
    'Devre Antrenmani (Full Body)',
    'Alt Vucut Metabolik',
    'HIIT Patlayici',
    'Aktif Dinlenme',
    'Super Devre Full Body',
    'Alt Vucut Yakim Zirvesi',
    'HIIT Maksimum',
    'Aktif Dinlenme',
    'Kontrollu Devre (Full Body)',
    'Alt Vucut + Core Sikilasma',
    'HIIT Final Yakici',
    'Aktif Dinlenme',
    'Metabolik Devre 2.0',
    'Alt Vucut Guclu Final',
    'HIIT Son Zirve',
    'Aktif Dinlenme',
    'Full Body Sikilastirma',
    'Final Challenge',
  ];

  static const List<String> _dayTitlesEn = [
    'Fat Burn Activation',
    'Lower Body + Cardio',
    'HIIT Burner',
    'Active Recovery',
    'Strength + Cardio Boost',
    'Lower Body Burner',
    'HIIT Metabolic Shock',
    'Active Recovery',
    'Full Body Metabolic',
    'Lower Body Strength + Cardio',
    'HIIT Advanced Level',
    'Active Recovery',
    'Circuit Workout (Full Body)',
    'Lower Body Metabolic',
    'HIIT Explosive',
    'Active Recovery',
    'Super Circuit Full Body',
    'Lower Body Burn Peak',
    'HIIT Maximum',
    'Active Recovery',
    'Controlled Circuit (Full Body)',
    'Lower Body + Core Tightening',
    'HIIT Final Burn',
    'Active Recovery',
    'Metabolic Circuit 2.0',
    'Lower Body Strong Final',
    'HIIT Final Peak',
    'Active Recovery',
    'Full Body Tightening',
    'Final Challenge',
  ];

  static const Map<String, List<String>> _dayTitlesByLanguage = {
    'tr': _dayTitlesTr,
    'en': _dayTitlesEn,
    'de': _dayTitlesEn,
    'es': _dayTitlesEn,
    'fr': _dayTitlesEn,
    'hi': _dayTitlesEn,
    'it': _dayTitlesEn,
    'ja': _dayTitlesEn,
    'ko': _dayTitlesEn,
    'pt': _dayTitlesEn,
    'ru': _dayTitlesEn,
    'zh': _dayTitlesEn,
  };

  static const Map<String, _WorkoutLocaleText> _localeTextByLanguage = {
    'tr': _WorkoutLocaleText(
      headerTitle: '30 Gunde Kilo Verme',
      completedLabel: 'Tamamlandi',
      dayPrefix: '',
      daySuffix: '.Gun',
    ),
    'en': _WorkoutLocaleText(
      headerTitle: '30-Day Weight Loss',
      completedLabel: 'Completed',
      dayPrefix: 'Day ',
      daySuffix: '',
    ),
    'de': _WorkoutLocaleText(
      headerTitle: '30-Tage Gewichtsverlust',
      completedLabel: 'Abgeschlossen',
      dayPrefix: 'Tag ',
      daySuffix: '',
    ),
    'es': _WorkoutLocaleText(
      headerTitle: 'Perdida de peso en 30 dias',
      completedLabel: 'Completado',
      dayPrefix: 'Dia ',
      daySuffix: '',
    ),
    'fr': _WorkoutLocaleText(
      headerTitle: 'Perte de poids en 30 jours',
      completedLabel: 'Termine',
      dayPrefix: 'Jour ',
      daySuffix: '',
    ),
    'hi': _WorkoutLocaleText(
      headerTitle: '30-day Weight Loss',
      completedLabel: 'Completed',
      dayPrefix: 'Day ',
      daySuffix: '',
    ),
    'it': _WorkoutLocaleText(
      headerTitle: 'Perdita di peso in 30 giorni',
      completedLabel: 'Completato',
      dayPrefix: 'Giorno ',
      daySuffix: '',
    ),
    'ja': _WorkoutLocaleText(
      headerTitle: '30日間減量プラン',
      completedLabel: '完了',
      dayPrefix: 'Day ',
      daySuffix: '',
    ),
    'ko': _WorkoutLocaleText(
      headerTitle: '30일 체중 감량',
      completedLabel: '완료',
      dayPrefix: 'Day ',
      daySuffix: '',
    ),
    'pt': _WorkoutLocaleText(
      headerTitle: 'Perda de peso em 30 dias',
      completedLabel: 'Concluido',
      dayPrefix: 'Dia ',
      daySuffix: '',
    ),
    'ru': _WorkoutLocaleText(
      headerTitle: 'Похудение за 30 дней',
      completedLabel: 'Завершено',
      dayPrefix: 'День ',
      daySuffix: '',
    ),
    'zh': _WorkoutLocaleText(
      headerTitle: '30天减重计划',
      completedLabel: '已完成',
      dayPrefix: 'Day ',
      daySuffix: '',
    ),
  };

  static String _languageCode(BuildContext context) {
    return Localizations.localeOf(context).languageCode;
  }

  static _WorkoutLocaleText _localeText(BuildContext context) {
    final languageCode = _languageCode(context);
    return _localeTextByLanguage[languageCode] ?? _localeTextByLanguage['en']!;
  }

  static List<String> _localizedDayTitles(BuildContext context) {
    final languageCode = _languageCode(context);
    return _dayTitlesByLanguage[languageCode] ?? _dayTitlesEn;
  }

  static String dayLabel(BuildContext context, int dayNumber) {
    final text = _localeText(context);
    if (text.dayPrefix.isNotEmpty) {
      return '${text.dayPrefix}$dayNumber${text.daySuffix}';
    }

    return '$dayNumber${text.daySuffix}';
  }

  List<_WorkoutDayItem> _fallbackItems(BuildContext context) {
    final dayTitles = _localizedDayTitles(context);

    return List<_WorkoutDayItem>.generate(30, (index) {
      final day = index + 1;
      final state = day == 1
          ? _WorkoutCardState.unlocked
          : _WorkoutCardState.locked;

      return _WorkoutDayItem(
        dayNumber: day,
        title: dayTitles[index],
        imagePath: 'assets/images/antrenman/day${((index % 16) + 1)}.jpg',
        state: state,
      );
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remoteProgram = ref.watch(workoutProgramUiProvider);
    final remoteItems = remoteProgram.valueOrNull;

    final allItems = (remoteItems != null && remoteItems.isNotEmpty)
        ? remoteItems
              .map(
                (item) => _WorkoutDayItem(
                  dayNumber: item.dayNumber,
                  title: item.title,
                  imagePath: item.imagePath,
                  state: item.isCompleted
                      ? _WorkoutCardState.completed
                      : (item.isLocked
                            ? _WorkoutCardState.locked
                            : _WorkoutCardState.unlocked),
                ),
              )
              .toList(growable: false)
        : _fallbackItems(context);

    final rows = <List<_WorkoutDayItem>>[];

    for (var i = 0; i < allItems.length; i += 2) {
      final end = (i + 2) > allItems.length ? allItems.length : (i + 2);
      rows.add(allItems.sublist(i, end));
    }

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
                    padding: EdgeInsets.fromLTRB(24.w, 92.h, 24.w, 100.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const _WorkoutHeader(),
                        SizedBox(height: 30.h),
                        SizedBox(
                          width: 342.w,
                          child: Column(
                            children: [
                              for (
                                var rowIndex = 0;
                                rowIndex < rows.length;
                                rowIndex++
                              ) ...[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _WorkoutDayCard(item: rows[rowIndex][0]),
                                    if (rows[rowIndex].length > 1)
                                      _WorkoutDayCard(item: rows[rowIndex][1])
                                    else
                                      SizedBox(width: 164.w),
                                  ],
                                ),
                                if (rowIndex != rows.length - 1)
                                  SizedBox(height: 14.h),
                              ],
                            ],
                          ),
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
                child: _BottomBar(iconBase: _iconBase),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WorkoutHeader extends StatelessWidget {
  const _WorkoutHeader();

  @override
  Widget build(BuildContext context) {
    final localeText = WorkoutView._localeText(context);

    return SizedBox(
      width: 342.w,
      height: 28.h,
      child: Row(
        children: [
          InkWell(
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(AppRoutes.home),
            borderRadius: BorderRadius.circular(14.r),
            child: Container(
              width: 28.w,
              height: 28.w,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 14.w,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Text(
              localeText.headerTitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.leagueSpartan(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                height: 18 / 20,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _WorkoutCardState { completed, unlocked, locked }

class _WorkoutDayItem {
  const _WorkoutDayItem({
    required this.dayNumber,
    required this.title,
    required this.imagePath,
    required this.state,
  });

  final int dayNumber;
  final String title;
  final String imagePath;
  final _WorkoutCardState state;
}

class _WorkoutDayCard extends StatelessWidget {
  const _WorkoutDayCard({required this.item});

  final _WorkoutDayItem item;

  void _openWorkoutProgram(BuildContext context) {
    Navigator.of(context).pushNamed(
      AppRoutes.workoutProgram,
      arguments: WorkoutProgramArgs(
        dayNumber: item.dayNumber,
        programTitle: item.title,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localeText = WorkoutView._localeText(context);
    final isCompleted = item.state == _WorkoutCardState.completed;
    final isLocked = item.state == _WorkoutCardState.locked;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLocked ? null : () => _openWorkoutProgram(context),
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          width: 164.w,
          height: 196.h,
          decoration: BoxDecoration(
            color: const Color(0xFFF7F7F7),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: const Color(0xFFECECEC)),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 6.h,
                left: 7.w,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: Stack(
                    children: [
                      Image.asset(
                        item.imagePath,
                        width: 150.w,
                        height: 125.h,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        width: 150.w,
                        height: 125.h,
                        color: const Color.fromRGBO(0, 0, 0, 0.2),
                      ),
                    ],
                  ),
                ),
              ),
              if (isLocked)
                Positioned(
                  top: 9.h,
                  right: 24.w,
                  child: Icon(
                    Icons.lock_rounded,
                    size: 12.w,
                    color: const Color(0xFFC1C1C1),
                  ),
                ),
              Positioned(
                top: 138.h,
                left: 12.w,
                child: SizedBox(
                  width: 140.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 140.w,
                        height: 9.h,
                        child: Text(
                          WorkoutView.dayLabel(context, item.dayNumber),
                          style: GoogleFonts.leagueSpartan(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            height: 9 / 10,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      SizedBox(
                        width: 140.w,
                        height: 14.h,
                        child: Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.leagueSpartan(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            height: 11 / 12,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      SizedBox(
                        width: 140.w,
                        height: 15.h,
                        child: isCompleted
                            ? Container(
                                width: 140.w,
                                height: 15.h,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1CD659),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Text(
                                  localeText.completedLabel,
                                  style: GoogleFonts.leagueSpartan(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w400,
                                    height: 9 / 10,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : (isLocked
                                  ? const SizedBox.shrink()
                                  : Align(
                                      alignment: Alignment.centerRight,
                                      child: InkWell(
                                        onTap: () =>
                                            _openWorkoutProgram(context),
                                        child: SvgPicture.asset(
                                          'assets/images/icons/iconsax-play-circle-1.svg',
                                          width: 18.w,
                                          height: 18.h,
                                        ),
                                      ),
                                    )),
                      ),
                    ],
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

class _WorkoutLocaleText {
  const _WorkoutLocaleText({
    required this.headerTitle,
    required this.completedLabel,
    required this.dayPrefix,
    required this.daySuffix,
  });

  final String headerTitle;
  final String completedLabel;
  final String dayPrefix;
  final String daySuffix;
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
            active: true,
            onTap: null,
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
