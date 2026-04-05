import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slim30/Core/Routes/app_routes.dart';
import 'package:slim30/Core/Storage/user_prefs.dart';
import 'package:slim30/l10n/generated/app_localizations.dart';

class WorkoutProgramArgs {
  const WorkoutProgramArgs({
    required this.dayNumber,
    required this.programTitle,
  });

  final int dayNumber;
  final String programTitle;
}

class WorkoutProgramView extends StatefulWidget {
  const WorkoutProgramView({super.key});

  @override
  State<WorkoutProgramView> createState() => _WorkoutProgramViewState();
}

class _WorkoutProgramViewState extends State<WorkoutProgramView> {
  static const _iconBase = 'assets/images/icons/homePage';
  static const _defaultImageFolder = 'woman';
  UserGender _gender = UserGender.unspecified;

  @override
  void initState() {
    super.initState();
    _loadGender();
  }

  Future<void> _loadGender() async {
    final gender = await UserPrefs.getGender();
    if (!mounted) return;
    setState(() => _gender = gender);
  }

  String _languageCode(BuildContext context) =>
      Localizations.localeOf(context).languageCode;

  _ProgramLocale _locale(BuildContext context) {
    final code = _languageCode(context);
    return _localeByCode[code] ?? _localeByCode['en']!;
  }

  String _folderByGender() {
    if (_gender == UserGender.male) {
      return 'man';
    }

    if (_gender == UserGender.female) {
      return 'woman';
    }

    return _defaultImageFolder;
  }

  _DayContent _dayContent(BuildContext context, int dayNumber) {
    final locale = _locale(context);
    final folder = _folderByGender();
    final isTr = _languageCode(context) == 'tr';

    String path(String name) => 'assets/images/$folder/$name';
    String fallbackPath(String name) =>
        'assets/images/$_defaultImageFolder/$name';

    List<_ExerciseItem> defaultItems = [
      _ExerciseItem(
        title: locale.jumpingJack,
        sets: locale.sets40Sec,
        rest: locale.rest30Sec,
        imagePath: path('Jumping Jack.png'),
        fallbackImagePath: fallbackPath('Jumping Jack.png'),
        cardHeight: 91,
        locked: true,
      ),
      _ExerciseItem(
        title: locale.bodyweightSquat,
        sets: locale.sets20Reps,
        rest: locale.rest30Sec,
        imagePath: path('Bodyweight Squat.png'),
        fallbackImagePath: fallbackPath('Bodyweight Squat.png'),
        cardHeight: 91,
      ),
      _ExerciseItem(
        title: locale.modifiedPushUp,
        sets: locale.sets12Reps,
        rest: locale.rest30Sec,
        imagePath: path('Modified Push-Up.png'),
        fallbackImagePath: fallbackPath('Modified Push-Up.png'),
        cardHeight: 91,
        locked: true,
      ),
      _ExerciseItem(
        title: locale.standingKneeDrive,
        sets: locale.sets20RepsPerSide,
        rest: locale.rest30Sec,
        imagePath: path('Standing Knee Drive.png'),
        fallbackImagePath: fallbackPath('Standing Knee Drive.png'),
        cardHeight: 91,
      ),
      _ExerciseItem(
        title: locale.gluteBridge,
        sets: locale.sets20Reps,
        rest: locale.rest30Sec,
        imagePath: path('Glute Bridge.png'),
        fallbackImagePath: fallbackPath('Glute Bridge.png'),
        cardHeight: 91,
      ),
      _ExerciseItem(
        title: locale.marchingPlank,
        sets: locale.sets30Sec,
        rest: locale.rest30Sec,
        imagePath: path('Marching Plank.png'),
        fallbackImagePath: fallbackPath('Marching Plank.png'),
        cardHeight: 91,
      ),
      _ExerciseItem(
        title: locale.lowImpactMountainClimber,
        sets: locale.sets30Sec,
        rest: locale.rest30Sec,
        imagePath: path('Mountain Climber.png'),
        fallbackImagePath: fallbackPath('Mountain Climber.png'),
        cardHeight: 108,
      ),
      _ExerciseItem(
        title: locale.shadowBoxingMedium,
        sets: locale.sets40Sec,
        rest: locale.rest30Sec,
        imagePath: path('Shadow Boxing\u00A0.png'),
        fallbackImagePath: fallbackPath('Shadow Boxing\u00A0.png'),
        cardHeight: 108,
      ),
    ];

    if (!isTr) {
      return _DayContent(items: defaultItems);
    }

    switch (dayNumber) {
      case 2:
        return _DayContent(
          items: [
            _ExerciseItem(
              title: 'High Knees (kontrollu tempo)',
              sets: '3 set x 40 saniye',
              rest: 'Set arasi: 30 sn',
              imagePath: path('High Knees\u00A0.png'),
              fallbackImagePath: fallbackPath('High Knees\u00A0.png'),
              cardHeight: 91,
            ),
            _ExerciseItem(
              title: 'Reverse Lunge',
              sets: '3 set x 15 tekrar (sag + sol)',
              rest: 'Set arasi: 30 sn',
              imagePath: path('Reverse Lunge.png'),
              fallbackImagePath: fallbackPath('Reverse Lunge.png'),
              cardHeight: 91,
            ),
            _ExerciseItem(
              title: 'Sumo Squat',
              sets: '3 set x 20 tekrar',
              rest: 'Set arasi: 30 sn',
              imagePath: path('Sumo Squat\u00A0.png'),
              fallbackImagePath: fallbackPath('Sumo Squat\u00A0.png'),
              cardHeight: 91,
            ),
            _ExerciseItem(
              title: 'Step Back Kick',
              sets: '3 set x 20 tekrar (sag + sol)',
              rest: 'Set arasi: 30 sn',
              imagePath: path('Step Back Kick\u00A0.png'),
              fallbackImagePath: fallbackPath('Step Back Kick\u00A0.png'),
              cardHeight: 91,
            ),
            _ExerciseItem(
              title: 'Wall Sit',
              sets: '3 set x 40 saniye',
              rest: 'Set arasi: 30 sn',
              imagePath: path('Wall Sit.png'),
              fallbackImagePath: fallbackPath('Wall Sit.png'),
              cardHeight: 91,
            ),
            _ExerciseItem(
              title: 'Standing Calf Raise',
              sets: '3 set x 25 tekrar',
              rest: 'Set arasi: 25 sn',
              imagePath: path('Standing Calf Raise.png'),
              fallbackImagePath: fallbackPath('Standing Calf Raise.png'),
              cardHeight: 91,
            ),
            _ExerciseItem(
              title: 'Side Step Squat',
              sets: '3 set x 20 tekrar (toplam)',
              rest: 'Set arasi: 30 sn',
              imagePath: path('Side Step Squat.png'),
              fallbackImagePath: fallbackPath('Side Step Squat.png'),
              cardHeight: 91,
            ),
            _ExerciseItem(
              title: 'Fast Feet Shuffle',
              sets: '3 set x 40 saniye',
              rest: 'Set arasi: 30 sn',
              imagePath: path('Fast Feet Shuffle.png'),
              fallbackImagePath: fallbackPath('Fast Feet Shuffle.png'),
              cardHeight: 91,
            ),
          ],
        );
      case 3:
        return _DayContent(
          items: [
            _ExerciseItem(
              title: 'Burpee (ziplamasiz yapilabilir)',
              sets: '3 set x 12 tekrar',
              rest: 'Set arasi: 40 sn',
              imagePath: path('Burpee.png'),
              fallbackImagePath: fallbackPath('Burpee.png'),
              cardHeight: 91,
            ),
            _ExerciseItem(
              title: 'Jump Squat',
              sets: '3 set x 15 tekrar',
              rest: 'Set arasi: 40 sn',
              imagePath: path('Jump Squat.png'),
              fallbackImagePath: fallbackPath('Jump Squat.png'),
              cardHeight: 91,
            ),
            _ExerciseItem(
              title: 'Mountain Climber (hizli tempo)',
              sets: '3 set x 45 saniye',
              rest: 'Set arasi: 30 sn',
              imagePath: path('Mountain Climber.png'),
              fallbackImagePath: fallbackPath('Mountain Climber.png'),
              cardHeight: 108,
            ),
            _ExerciseItem(
              title: 'Skater Jump',
              sets: '3 set x 30 saniye',
              rest: 'Set arasi: 30 sn',
              imagePath: path('Skater Jump.png'),
              fallbackImagePath: fallbackPath('Skater Jump.png'),
              cardHeight: 91,
            ),
            _ExerciseItem(
              title: 'Plank Jack',
              sets: '3 set x 30 saniye',
              rest: 'Set arasi: 30 sn',
              imagePath: path('Plank Jack.png'),
              fallbackImagePath: fallbackPath('Plank Jack.png'),
              cardHeight: 91,
            ),
            _ExerciseItem(
              title: 'Butt Kicks',
              sets: '3 set x 45 saniye',
              rest: 'Set arasi: 30 sn',
              imagePath: path('Butt Kicks.png'),
              fallbackImagePath: fallbackPath('Butt Kicks.png'),
              cardHeight: 91,
            ),
            _ExerciseItem(
              title: 'Squat Thrust',
              sets: '3 set x 15 tekrar',
              rest: 'Set arasi: 40 sn',
              imagePath: path('Squat Thrust.png'),
              fallbackImagePath: fallbackPath('Squat Thrust.png'),
              cardHeight: 91,
            ),
            _ExerciseItem(
              title: 'Shadow Boxing (yuksek tempo)',
              sets: '3 set x 45 saniye',
              rest: 'Set arasi: 30 sn',
              imagePath: path('Shadow Boxing\u00A0.png'),
              fallbackImagePath: fallbackPath('Shadow Boxing\u00A0.png'),
              cardHeight: 108,
            ),
          ],
        );
      case 4:
        return const _DayContent(
          items: [],
          recoveryLines: [
            'Bugun yogun yag yakim antrenmani yok.',
            '30-40 dakika tempolu yuruyus onerilir.',
            'Hafif esneme ve mobilite calismasi yapilir.',
            'Bol su icilir.',
          ],
        );
      case 5:
        return _DayContent(
          items: [
            _ExerciseItem(
              title: 'Jumping Jack',
              sets: '3 set x 50 saniye',
              rest: 'Set arasi: 25 sn',
              imagePath: path('Jumping Jack.png'),
              fallbackImagePath: fallbackPath('Jumping Jack.png'),
              cardHeight: 91,
            ),
            _ExerciseItem(
              title: 'Bodyweight Squat',
              sets: '3 set x 25 tekrar',
              rest: 'Set arasi: 25 sn',
              imagePath: path('Bodyweight Squat.png'),
              fallbackImagePath: fallbackPath('Bodyweight Squat.png'),
              cardHeight: 91,
            ),
            _ExerciseItem(
              title: 'Push-Up',
              sets: '3 set x 15 tekrar',
              rest: 'Set arasi: 30 sn',
              imagePath: path('Modified Push-Up.png'),
              fallbackImagePath: fallbackPath('Modified Push-Up.png'),
              cardHeight: 91,
            ),
            _ExerciseItem(
              title: 'Walking Lunge',
              sets: '3 set x 18 tekrar (sag + sol)',
              rest: 'Set arasi: 30 sn',
              imagePath: path('Walking Lunge.png'),
              fallbackImagePath: fallbackPath('Walking Lunge.png'),
              cardHeight: 91,
            ),
            _ExerciseItem(
              title: 'Glute Bridge',
              sets: '3 set x 20 tekrar',
              rest: 'Set arasi: 25 sn',
              imagePath: path('Glute Bridge.png'),
              fallbackImagePath: fallbackPath('Glute Bridge.png'),
              cardHeight: 91,
            ),
            _ExerciseItem(
              title: 'Plank to Push-Up',
              sets: '3 set x 35 saniye',
              rest: 'Set arasi: 30 sn',
              imagePath: path('Plank.png'),
              fallbackImagePath: fallbackPath('Plank.png'),
              cardHeight: 91,
            ),
            _ExerciseItem(
              title: 'Mountain Climber',
              sets: '3 set x 45 saniye',
              rest: 'Set arasi: 30 sn',
              imagePath: path('Mountain Climber.png'),
              fallbackImagePath: fallbackPath('Mountain Climber.png'),
              cardHeight: 108,
            ),
            _ExerciseItem(
              title: 'Shadow Boxing (yuksek tempo)',
              sets: '3 set x 50 saniye',
              rest: 'Set arasi: 25 sn',
              imagePath: path('Shadow Boxing\u00A0.png'),
              fallbackImagePath: fallbackPath('Shadow Boxing\u00A0.png'),
              cardHeight: 108,
            ),
          ],
        );
      case 6:
        return _DayContent(
          items: [
            _ExerciseItem(
              title: 'High Knees',
              sets: '3 set x 50 saniye',
              rest: 'Set arasi: 25 sn',
              imagePath: path('High Knees\u00A0.png'),
              fallbackImagePath: fallbackPath('High Knees\u00A0.png'),
              cardHeight: 91,
            ),
            _ExerciseItem(
              title: 'Jump Squat',
              sets: '3 set x 18 tekrar',
              rest: 'Set arasi: 35 sn',
              imagePath: path('Jump Squat.png'),
              fallbackImagePath: fallbackPath('Jump Squat.png'),
              cardHeight: 91,
            ),
            _ExerciseItem(
              title: 'Reverse Lunge + Knee Drive',
              sets: '3 set x 15 tekrar (sag + sol)',
              rest: 'Set arasi: 30 sn',
              imagePath: path('Reverse Lunge.png'),
              fallbackImagePath: fallbackPath('Reverse Lunge.png'),
              cardHeight: 108,
            ),
            _ExerciseItem(
              title: 'Sumo Squat Pulse',
              sets: '3 set x 25 tekrar',
              rest: 'Set arasi: 30 sn',
              imagePath: path('Sumo Squat\u00A0.png'),
              fallbackImagePath: fallbackPath('Sumo Squat\u00A0.png'),
              cardHeight: 91,
            ),
            _ExerciseItem(
              title: 'Wall Sit',
              sets: '3 set x 50 saniye',
              rest: 'Set arasi: 30 sn',
              imagePath: path('Wall Sit.png'),
              fallbackImagePath: fallbackPath('Wall Sit.png'),
              cardHeight: 91,
            ),
            _ExerciseItem(
              title: 'Side Lunge',
              sets: '3 set x 18 tekrar (sag + sol)',
              rest: 'Set arasi: 30 sn',
              imagePath: path('Side Lunge.png'),
              fallbackImagePath: fallbackPath('Side Lunge.png'),
              cardHeight: 91,
            ),
            _ExerciseItem(
              title: 'Fast Feet Shuffle',
              sets: '3 set x 50 saniye',
              rest: 'Set arasi: 25 sn',
              imagePath: path('Fast Feet Shuffle.png'),
              fallbackImagePath: fallbackPath('Fast Feet Shuffle.png'),
              cardHeight: 91,
            ),
            _ExerciseItem(
              title: 'Butt Kicks',
              sets: '3 set x 50 saniye',
              rest: 'Set arasi: 25 sn',
              imagePath: path('Butt Kicks.png'),
              fallbackImagePath: fallbackPath('Butt Kicks.png'),
              cardHeight: 91,
            ),
          ],
        );
      case 7:
        return _DayContent(
          items: [
            _ExerciseItem(
              title: 'Burpee',
              sets: '3 set x 15 tekrar',
              rest: 'Set arasi: 40 sn',
              imagePath: path('Burpee.png'),
              fallbackImagePath: fallbackPath('Burpee.png'),
              cardHeight: 91,
            ),
            _ExerciseItem(
              title: 'Skater Jump',
              sets: '3 set x 40 saniye',
              rest: 'Set arasi: 30 sn',
              imagePath: path('Skater Jump.png'),
              fallbackImagePath: fallbackPath('Skater Jump.png'),
              cardHeight: 91,
            ),
            _ExerciseItem(
              title: 'Mountain Climber (hizli tempo)',
              sets: '3 set x 50 saniye',
              rest: 'Set arasi: 30 sn',
              imagePath: path('Mountain Climber.png'),
              fallbackImagePath: fallbackPath('Mountain Climber.png'),
              cardHeight: 108,
            ),
            _ExerciseItem(
              title: 'Squat Thrust',
              sets: '3 set x 18 tekrar',
              rest: 'Set arasi: 35 sn',
              imagePath: path('Squat Thrust.png'),
              fallbackImagePath: fallbackPath('Squat Thrust.png'),
              cardHeight: 91,
            ),
            _ExerciseItem(
              title: 'Plank Jack',
              sets: '3 set x 40 saniye',
              rest: 'Set arasi: 30 sn',
              imagePath: path('Plank Jack.png'),
              fallbackImagePath: fallbackPath('Plank Jack.png'),
              cardHeight: 91,
            ),
            _ExerciseItem(
              title: 'Jumping Lunge',
              sets: '3 set x 15 tekrar (sag + sol)',
              rest: 'Set arasi: 40 sn',
              imagePath: path('Walking Lunge.png'),
              fallbackImagePath: fallbackPath('Walking Lunge.png'),
              cardHeight: 91,
            ),
            _ExerciseItem(
              title: 'High Knees',
              sets: '3 set x 50 saniye',
              rest: 'Set arasi: 25 sn',
              imagePath: path('High Knees\u00A0.png'),
              fallbackImagePath: fallbackPath('High Knees\u00A0.png'),
              cardHeight: 91,
            ),
            _ExerciseItem(
              title: 'Shadow Boxing (maksimum tempo)',
              sets: '3 set x 50 saniye',
              rest: 'Set arasi: 25 sn',
              imagePath: path('Shadow Boxing\u00A0.png'),
              fallbackImagePath: fallbackPath('Shadow Boxing\u00A0.png'),
              cardHeight: 108,
            ),
          ],
        );
      case 8:
        return const _DayContent(
          items: [],
          recoveryLines: [
            '40 dakika tempolu yuruyus veya hafif bisiklet.',
            '10-15 dakika esneme.',
            'Kalca, hamstring ve sirt mobilitesi.',
            'Bol su + protein agirlikli beslenme.',
          ],
        );
      default:
        return _DayContent(items: defaultItems);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = _locale(context);
    final args = ModalRoute.of(context)?.settings.arguments;
    final data = args is WorkoutProgramArgs
        ? args
        : WorkoutProgramArgs(
            dayNumber: 1,
            programTitle: locale.defaultProgramTitle,
          );

    final dayContent = _dayContent(context, data.dayNumber);
    final items = dayContent.items;

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
                    padding: EdgeInsets.fromLTRB(24.w, 30.h, 24.w, 90.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 342.w,
                          height: 28.h,
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () => Navigator.of(context).pop(),
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
                              Expanded(
                                child: Text(
                                  locale.dayTitle(
                                    data.dayNumber,
                                    data.programTitle,
                                  ),
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
                        ),
                        SizedBox(height: 30.h),
                        Text(
                          locale.program,
                          style: GoogleFonts.leagueSpartan(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            height: 17 / 18,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        if (dayContent.recoveryLines != null)
                          Container(
                            width: 342.w,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 16.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5FEFF),
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                color: const Color.fromRGBO(
                                  241,
                                  241,
                                  241,
                                  0.73,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (
                                  var i = 0;
                                  i < dayContent.recoveryLines!.length;
                                  i++
                                ) ...[
                                  Text(
                                    dayContent.recoveryLines![i],
                                    style: GoogleFonts.leagueSpartan(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      height: 1.2,
                                      color: const Color(0xFF535353),
                                    ),
                                  ),
                                  if (i != dayContent.recoveryLines!.length - 1)
                                    SizedBox(height: 10.h),
                                ],
                              ],
                            ),
                          )
                        else
                          SizedBox(
                            width: 342.w,
                            child: Column(
                              children: [
                                for (var i = 0; i < items.length; i++) ...[
                                  _ExerciseCard(
                                    item: items[i],
                                    iconBase: _iconBase,
                                    light: i.isEven,
                                  ),
                                  if (i != items.length - 1)
                                    SizedBox(height: 17.h),
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

class _ExerciseCard extends StatelessWidget {
  const _ExerciseCard({
    required this.item,
    required this.iconBase,
    required this.light,
  });

  final _ExerciseItem item;
  final String iconBase;
  final bool light;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 342.w,
      height: item.cardHeight.h,
      decoration: BoxDecoration(
        color: light ? const Color(0xFFF3FFF7) : const Color(0xFFF5FEFF),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color.fromRGBO(241, 241, 241, 0.73)),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.r),
                bottomLeft: Radius.circular(10.r),
              ),
              child: Image.asset(
                item.imagePath,
                width: 124.w,
                height: item.cardHeight.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    item.fallbackImagePath,
                    width: 124.w,
                    height: item.cardHeight.h,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 124.w,
                        height: item.cardHeight.h,
                        color: const Color(0xFFEDEDED),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Positioned(
            left: 140.w,
            top: ((item.cardHeight - 59) / 2).h,
            child: SizedBox(
              width: 157.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: item.cardHeight == 108 ? 2 : 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.leagueSpartan(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      height: 17 / 18,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      SvgPicture.asset(
                        '$iconBase/iconsax-weight.svg',
                        width: 14.w,
                        height: 14.h,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF535353),
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          item.sets,
                          style: GoogleFonts.leagueSpartan(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            height: 11 / 12,
                            color: const Color(0xFF535353),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      SvgPicture.asset(
                        '$iconBase/iconsax-clock.svg',
                        width: 14.w,
                        height: 14.h,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF535353),
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          item.rest,
                          style: GoogleFonts.leagueSpartan(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            height: 11 / 12,
                            color: const Color(0xFF535353),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (item.locked)
            Positioned(
              right: 19.w,
              top: 68.h,
              child: Icon(
                Icons.lock_rounded,
                size: 14.w,
                color: const Color(0xFFB8B8B8),
              ),
            ),
        ],
      ),
    );
  }
}

class _ExerciseItem {
  const _ExerciseItem({
    required this.title,
    required this.sets,
    required this.rest,
    required this.imagePath,
    required this.fallbackImagePath,
    required this.cardHeight,
    this.locked = false,
  });

  final String title;
  final String sets;
  final String rest;
  final String imagePath;
  final String fallbackImagePath;
  final double cardHeight;
  final bool locked;
}

class _DayContent {
  const _DayContent({required this.items, this.recoveryLines});

  final List<_ExerciseItem> items;
  final List<String>? recoveryLines;
}

class _ProgramLocale {
  const _ProgramLocale({
    required this.program,
    required this.defaultProgramTitle,
    required this.dayPrefix,
    required this.dayConnector,
    required this.jumpingJack,
    required this.bodyweightSquat,
    required this.modifiedPushUp,
    required this.standingKneeDrive,
    required this.gluteBridge,
    required this.marchingPlank,
    required this.lowImpactMountainClimber,
    required this.shadowBoxingMedium,
    required this.sets40Sec,
    required this.sets20Reps,
    required this.sets12Reps,
    required this.sets20RepsPerSide,
    required this.sets30Sec,
    required this.rest30Sec,
  });

  final String program;
  final String defaultProgramTitle;
  final String dayPrefix;
  final String dayConnector;
  final String jumpingJack;
  final String bodyweightSquat;
  final String modifiedPushUp;
  final String standingKneeDrive;
  final String gluteBridge;
  final String marchingPlank;
  final String lowImpactMountainClimber;
  final String shadowBoxingMedium;
  final String sets40Sec;
  final String sets20Reps;
  final String sets12Reps;
  final String sets20RepsPerSide;
  final String sets30Sec;
  final String rest30Sec;

  String dayTitle(int dayNumber, String title) =>
      '$dayPrefix$dayNumber$dayConnector$title';
}

const Map<String, _ProgramLocale> _localeByCode = {
  'tr': _ProgramLocale(
    program: 'Program',
    defaultProgramTitle: 'Yag Yakim Aktivasyonu',
    dayPrefix: 'Gun ',
    dayConnector: ' : ',
    jumpingJack: 'Jumping Jack',
    bodyweightSquat: 'Bodyweight Squat',
    modifiedPushUp: 'Modified Push-Up',
    standingKneeDrive: 'Standing Knee Drive',
    gluteBridge: 'Glute Bridge',
    marchingPlank: 'Marching Plank',
    lowImpactMountainClimber: 'Low Impact Mountain Climber',
    shadowBoxingMedium: 'Shadow Boxing (orta tempo)',
    sets40Sec: '3 set x 40 sn',
    sets20Reps: '3 set x 20 tekrar',
    sets12Reps: '3 set x 12 tekrar',
    sets20RepsPerSide: '3 set x 20 tekrar (sag + sol)',
    sets30Sec: '3 set x 30 sn',
    rest30Sec: 'Set arasi: 30 sn',
  ),
  'en': _ProgramLocale(
    program: 'Program',
    defaultProgramTitle: 'Fat Burn Activation',
    dayPrefix: 'Day ',
    dayConnector: ': ',
    jumpingJack: 'Jumping Jack',
    bodyweightSquat: 'Bodyweight Squat',
    modifiedPushUp: 'Modified Push-Up',
    standingKneeDrive: 'Standing Knee Drive',
    gluteBridge: 'Glute Bridge',
    marchingPlank: 'Marching Plank',
    lowImpactMountainClimber: 'Low Impact Mountain Climber',
    shadowBoxingMedium: 'Shadow Boxing (medium pace)',
    sets40Sec: '3 sets x 40 sec',
    sets20Reps: '3 sets x 20 reps',
    sets12Reps: '3 sets x 12 reps',
    sets20RepsPerSide: '3 sets x 20 reps (right + left)',
    sets30Sec: '3 sets x 30 sec',
    rest30Sec: 'Rest between sets: 30 sec',
  ),
  'de': _ProgramLocale(
    program: 'Programm',
    defaultProgramTitle: 'Fettverbrennungs-Aktivierung',
    dayPrefix: 'Tag ',
    dayConnector: ': ',
    jumpingJack: 'Hampelmann',
    bodyweightSquat: 'Kniebeuge mit eigenem Körpergewicht',
    modifiedPushUp: 'Modifizierter Liegestütz',
    standingKneeDrive: 'Stehender Kniehub',
    gluteBridge: 'Glute Bridge',
    marchingPlank: 'Marchierende Planke',
    lowImpactMountainClimber: 'Schonender Mountain Climber',
    shadowBoxingMedium: 'Schattenboxen (mittleres Tempo)',
    sets40Sec: '3 Sätze x 40 Sek.',
    sets20Reps: '3 Sätze x 20 Wdh.',
    sets12Reps: '3 Sätze x 12 Wdh.',
    sets20RepsPerSide: '3 Sätze x 20 Wdh. (rechts + links)',
    sets30Sec: '3 Sätze x 30 Sek.',
    rest30Sec: 'Pause zwischen Sätzen: 30 Sek.',
  ),
  'es': _ProgramLocale(
    program: 'Programa',
    defaultProgramTitle: 'Activacion de quema de grasa',
    dayPrefix: 'Día ',
    dayConnector: ': ',
    jumpingJack: 'Jumping Jack',
    bodyweightSquat: 'Sentadilla con peso corporal',
    modifiedPushUp: 'Flexión modificada',
    standingKneeDrive: 'Elevación de rodilla de pie',
    gluteBridge: 'Puente de glúteos',
    marchingPlank: 'Plancha marchando',
    lowImpactMountainClimber: 'Escalador de bajo impacto',
    shadowBoxingMedium: 'Boxeo de sombra (ritmo medio)',
    sets40Sec: '3 series x 40 s',
    sets20Reps: '3 series x 20 rep.',
    sets12Reps: '3 series x 12 rep.',
    sets20RepsPerSide: '3 series x 20 rep. (derecha + izquierda)',
    sets30Sec: '3 series x 30 s',
    rest30Sec: 'Descanso entre series: 30 s',
  ),
  'fr': _ProgramLocale(
    program: 'Programme',
    defaultProgramTitle: 'Activation brule-graisse',
    dayPrefix: 'Jour ',
    dayConnector: ' : ',
    jumpingJack: 'Jumping Jack',
    bodyweightSquat: 'Squat au poids du corps',
    modifiedPushUp: 'Pompe modifiée',
    standingKneeDrive: 'Montée de genou debout',
    gluteBridge: 'Pont fessier',
    marchingPlank: 'Planche en marche',
    lowImpactMountainClimber: 'Mountain climber faible impact',
    shadowBoxingMedium: 'Shadow boxing (rythme moyen)',
    sets40Sec: '3 series x 40 s',
    sets20Reps: '3 series x 20 rep.',
    sets12Reps: '3 series x 12 rep.',
    sets20RepsPerSide: '3 series x 20 rep. (droite + gauche)',
    sets30Sec: '3 series x 30 s',
    rest30Sec: 'Repos entre les séries : 30 s',
  ),
  'hi': _ProgramLocale(
    program: 'प्रोग्राम',
    defaultProgramTitle: 'फैट बर्न एक्टिवेशन',
    dayPrefix: 'दिन ',
    dayConnector: ': ',
    jumpingJack: 'जंपिंग जैक',
    bodyweightSquat: 'बॉडीवेट स्क्वाट',
    modifiedPushUp: 'संशोधित पुश-अप',
    standingKneeDrive: 'खड़े होकर घुटना उठाना',
    gluteBridge: 'ग्लूट ब्रिज',
    marchingPlank: 'मार्चिंग प्लैंक',
    lowImpactMountainClimber: 'लो इम्पैक्ट माउंटेन क्लाइंबर',
    shadowBoxingMedium: 'शैडो बॉक्सिंग (मध्यम गति)',
    sets40Sec: '3 सेट x 40 सेक',
    sets20Reps: '3 सेट x 20 रेप्स',
    sets12Reps: '3 सेट x 12 रेप्स',
    sets20RepsPerSide: '3 सेट x 20 रेप्स (दायां + बायां)',
    sets30Sec: '3 सेट x 30 सेक',
    rest30Sec: 'सेट के बीच आराम: 30 सेक',
  ),
  'it': _ProgramLocale(
    program: 'Programma',
    defaultProgramTitle: 'Attivazione brucia grassi',
    dayPrefix: 'Giorno ',
    dayConnector: ': ',
    jumpingJack: 'Jumping Jack',
    bodyweightSquat: 'Squat a corpo libero',
    modifiedPushUp: 'Push-up modificato',
    standingKneeDrive: 'Slancio del ginocchio in piedi',
    gluteBridge: 'Ponte per glutei',
    marchingPlank: 'Plank marciato',
    lowImpactMountainClimber: 'Mountain climber a basso impatto',
    shadowBoxingMedium: 'Shadow boxing (ritmo medio)',
    sets40Sec: '3 serie x 40 sec',
    sets20Reps: '3 serie x 20 rip.',
    sets12Reps: '3 serie x 12 rip.',
    sets20RepsPerSide: '3 serie x 20 rip. (destra + sinistra)',
    sets30Sec: '3 serie x 30 sec',
    rest30Sec: 'Recupero tra le serie: 30 sec',
  ),
  'ja': _ProgramLocale(
    program: 'プログラム',
    defaultProgramTitle: '脂肪燃焼アクティベーション',
    dayPrefix: '',
    dayConnector: '日目: ',
    jumpingJack: 'ジャンピングジャック',
    bodyweightSquat: '自重スクワット',
    modifiedPushUp: 'モディファイド・プッシュアップ',
    standingKneeDrive: 'スタンディング・ニードライブ',
    gluteBridge: 'グルートブリッジ',
    marchingPlank: 'マーチングプランク',
    lowImpactMountainClimber: '低衝撃マウンテンクライマー',
    shadowBoxingMedium: 'シャドーボクシング（中強度）',
    sets40Sec: '3セット x 40秒',
    sets20Reps: '3セット x 20回',
    sets12Reps: '3セット x 12回',
    sets20RepsPerSide: '3セット x 20回（右 + 左）',
    sets30Sec: '3セット x 30秒',
    rest30Sec: 'セット間休憩: 30秒',
  ),
  'ko': _ProgramLocale(
    program: '프로그램',
    defaultProgramTitle: '지방 연소 활성화',
    dayPrefix: '',
    dayConnector: '일차: ',
    jumpingJack: '점핑 잭',
    bodyweightSquat: '맨몸 스쿼트',
    modifiedPushUp: '수정 푸시업',
    standingKneeDrive: '스탠딩 니 드라이브',
    gluteBridge: '글루트 브리지',
    marchingPlank: '마칭 플랭크',
    lowImpactMountainClimber: '저강도 마운틴 클라이머',
    shadowBoxingMedium: '쉐도우 복싱 (중간 강도)',
    sets40Sec: '3세트 x 40초',
    sets20Reps: '3세트 x 20회',
    sets12Reps: '3세트 x 12회',
    sets20RepsPerSide: '3세트 x 20회 (오른쪽 + 왼쪽)',
    sets30Sec: '3세트 x 30초',
    rest30Sec: '세트 사이 휴식: 30초',
  ),
  'pt': _ProgramLocale(
    program: 'Programa',
    defaultProgramTitle: 'Ativacao de queima de gordura',
    dayPrefix: 'Dia ',
    dayConnector: ': ',
    jumpingJack: 'Jumping Jack',
    bodyweightSquat: 'Agachamento com peso corporal',
    modifiedPushUp: 'Flexão modificada',
    standingKneeDrive: 'Elevação de joelho em pé',
    gluteBridge: 'Ponte de glúteos',
    marchingPlank: 'Prancha marchando',
    lowImpactMountainClimber: 'Mountain climber de baixo impacto',
    shadowBoxingMedium: 'Boxe de sombra (ritmo médio)',
    sets40Sec: '3 series x 40 s',
    sets20Reps: '3 series x 20 rep.',
    sets12Reps: '3 series x 12 rep.',
    sets20RepsPerSide: '3 series x 20 rep. (direita + esquerda)',
    sets30Sec: '3 series x 30 s',
    rest30Sec: 'Descanso entre séries: 30 s',
  ),
  'ru': _ProgramLocale(
    program: 'Программа',
    defaultProgramTitle: 'Активация жиросжигания',
    dayPrefix: 'День ',
    dayConnector: ': ',
    jumpingJack: 'Джампинг джек',
    bodyweightSquat: 'Приседания с собственным весом',
    modifiedPushUp: 'Модифицированные отжимания',
    standingKneeDrive: 'Подъем колена стоя',
    gluteBridge: 'Ягодичный мостик',
    marchingPlank: 'Планка с шагами',
    lowImpactMountainClimber: 'Низкоударный альпинист',
    shadowBoxingMedium: 'Бой с тенью (средний темп)',
    sets40Sec: '3 подхода x 40 сек',
    sets20Reps: '3 подхода x 20 повторений',
    sets12Reps: '3 подхода x 12 повторений',
    sets20RepsPerSide: '3 подхода x 20 повторений (правая + левая)',
    sets30Sec: '3 подхода x 30 сек',
    rest30Sec: 'Отдых между подходами: 30 сек',
  ),
  'zh': _ProgramLocale(
    program: '训练计划',
    defaultProgramTitle: '燃脂激活',
    dayPrefix: '第',
    dayConnector: '天: ',
    jumpingJack: '开合跳',
    bodyweightSquat: '徒手深蹲',
    modifiedPushUp: '改良俯卧撑',
    standingKneeDrive: '站姿提膝',
    gluteBridge: '臀桥',
    marchingPlank: '行进平板支撑',
    lowImpactMountainClimber: '低冲击登山者',
    shadowBoxingMedium: '影子拳击（中等节奏）',
    sets40Sec: '3组 x 40秒',
    sets20Reps: '3组 x 20次',
    sets12Reps: '3组 x 12次',
    sets20RepsPerSide: '3组 x 20次（右 + 左）',
    sets30Sec: '3组 x 30秒',
    rest30Sec: '组间休息: 30秒',
  ),
};

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
            onTap: () {},
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
