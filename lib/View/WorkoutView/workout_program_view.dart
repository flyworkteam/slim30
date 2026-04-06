import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slim30/Core/Routes/app_routes.dart';
import 'package:slim30/Core/Storage/user_prefs.dart';
import 'package:slim30/Riverpod/Models/workout_day_model.dart';
import 'package:slim30/Riverpod/Providers/workout/workout_program_provider.dart';
import 'package:slim30/l10n/generated/app_localizations.dart';
import 'package:slim30/View/WorkoutView/workout_program_locale_data.dart';
import 'package:slim30/View/WorkoutView/workout_detail_view.dart';
import 'package:slim30/View/WorkoutView/exercise_video_catalog.dart';

class WorkoutProgramArgs {
  const WorkoutProgramArgs({
    required this.dayNumber,
    required this.programTitle,
  });

  final int dayNumber;
  final String programTitle;
}

class WorkoutProgramView extends ConsumerStatefulWidget {
  const WorkoutProgramView({super.key});

  @override
  ConsumerState<WorkoutProgramView> createState() => _WorkoutProgramViewState();
}

class _WorkoutProgramViewState extends ConsumerState<WorkoutProgramView> {
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

  ProgramLocale _locale(BuildContext context) {
    final code = _languageCode(context);
    return workoutProgramLocaleByCode[code] ??
        workoutProgramLocaleByCode['en']!;
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
    final isEn = _languageCode(context) == 'en';

    String path(String name) => 'assets/images/$folder/$name';
    String fallbackPath(String name) =>
        'assets/images/$_defaultImageFolder/$name';

    const recoveryLineTrToEn = {
      'Bugun yogun yag yakim antrenmani yok.':
          'No intense fat-burning workout today.',
      '30-40 dakika tempolu yuruyus onerilir.':
          'A 30-40 minute brisk walk is recommended.',
      'Hafif esneme ve mobilite calismasi yapilir.':
          'Do light stretching and mobility work.',
      'Bol su icilir.': 'Drink plenty of water.',
      '40 dakika tempolu yuruyus veya hafif bisiklet.':
          '40 minutes brisk walk or light cycling.',
      '10-15 dakika esneme.': '10-15 minutes of stretching.',
      'Kalca, hamstring ve sirt mobilitesi.':
          'Hip, hamstring and back mobility.',
      'Bol su + protein agirlikli beslenme.':
          'Plenty of water + protein-focused nutrition.',
      '45 dakika tempolu yuruyus': '45 minutes brisk walk.',
      'Hafif esneme': 'Light stretching.',
      'Kalca - hamstring - omuz mobilitesi':
          'Hip - hamstring - shoulder mobility.',
      'Bol su + tuz dengesi': 'Plenty of water + electrolyte balance.',
      '45-50 dakika tempolu yuruyus': '45-50 minutes brisk walk.',
      'Derin esneme': 'Deep stretching.',
      'Kalca fleksorleri + hamstring + omuz mobilitesi':
          'Hip flexor + hamstring + shoulder mobility.',
      'Su tuketimi artirilir': 'Increase water intake.',
      'Uyku suresi 7-8 saat olmali': 'Sleep duration should be 7-8 hours.',
      '45-60 dakika tempolu yuruyus': '45-60 minutes brisk walk.',
      'Hafif mobilite': 'Light mobility work.',
      'Kalca - hamstring - sirt acma': 'Open up hips - hamstrings - back.',
      'Bol su': 'Drink plenty of water.',
      'Yeterli protein': 'Get enough protein.',
      'Kalca - sirt - omuz mobilitesi': 'Hip - back - shoulder mobility.',
      'Uykuya dikkat': 'Pay attention to sleep quality.',
      'Su tuketimi yuksek tutulur': 'Keep water intake high.',
      'Mobilite': 'Mobility work.',
      'Uyku': 'Sleep and recovery.',
    };

    String translateTextForNonTr(String text) {
      var t = recoveryLineTrToEn[text] ?? text;
      t = t
          .replaceAll('Set arasi:', 'Rest:')
          .replaceAll('set x', 'sets x')
          .replaceAll('tekrar', 'reps')
          .replaceAll('saniye', 'sec')
          .replaceAll('sag + sol', 'right + left')
          .replaceAll('toplam', 'total')
          .replaceAll('maksimum tekrar', 'max reps')
          .replaceAll('maksimum sure', 'max time')
          .replaceAll('Devre:', 'Circuit:')
          .replaceAll('Devre bitince:', 'After circuit:')
          .replaceAll('Devre ici gecis', 'Transition')
          .replaceAll('tur', 'rounds')
          .replaceAll('Sonda:', 'Finish:')
          .replaceAll('yuruyus', 'walk')
          .replaceAll('derin nefes', 'deep breathing')
          .replaceAll('kontrollu tempo', 'controlled pace')
          .replaceAll('hizli tempo', 'fast pace')
          .replaceAll('yuksek tempo', 'high pace')
          .replaceAll('orta tempo', 'medium pace')
          .replaceAll('maksimum tempo', 'max pace');
      return t;
    }

    _DayContent finalizeDayContent(_DayContent content) {
      if (isTr || !isEn) {
        return content;
      }

      return _DayContent(
        items: [
          for (final item in content.items)
            _ExerciseItem(
              title: translateTextForNonTr(item.title),
              sets: translateTextForNonTr(item.sets),
              rest: translateTextForNonTr(item.rest),
              imagePath: item.imagePath,
              fallbackImagePath: item.fallbackImagePath,
              cardHeight: item.cardHeight,
              locked: item.locked,
            ),
        ],
        recoveryLines: content.recoveryLines
            ?.map(translateTextForNonTr)
            .toList(growable: false),
      );
    }

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

    switch (dayNumber) {
      case 2:
        return finalizeDayContent(
          _DayContent(
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
          ),
        );
      case 3:
        return finalizeDayContent(
          _DayContent(
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
          ),
        );
      case 4:
        return finalizeDayContent(
          const _DayContent(
            items: [],
            recoveryLines: [
              'Bugun yogun yag yakim antrenmani yok.',
              '30-40 dakika tempolu yuruyus onerilir.',
              'Hafif esneme ve mobilite calismasi yapilir.',
              'Bol su icilir.',
            ],
          ),
        );
      case 5:
        return finalizeDayContent(
          _DayContent(
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
          ),
        );
      case 6:
        return finalizeDayContent(
          _DayContent(
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
          ),
        );
      case 7:
        return finalizeDayContent(
          _DayContent(
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
          ),
        );
      case 8:
        return finalizeDayContent(
          const _DayContent(
            items: [],
            recoveryLines: [
              '40 dakika tempolu yuruyus veya hafif bisiklet.',
              '10-15 dakika esneme.',
              'Kalca, hamstring ve sirt mobilitesi.',
              'Bol su + protein agirlikli beslenme.',
            ],
          ),
        );
      case 9:
        return finalizeDayContent(
          _DayContent(
            items: [
              _ExerciseItem(
                title: 'Jump Rope',
                sets: '3 set x 60 saniye',
                rest: 'Set arasi: 30 sn',
                imagePath: path('Jump Rope.png'),
                fallbackImagePath: fallbackPath('Jump Rope.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Bodyweight Squat',
                sets: '3 set x 30 tekrar',
                rest: 'Set arasi: 25 sn',
                imagePath: path('Bodyweight Squat.png'),
                fallbackImagePath: fallbackPath('Bodyweight Squat.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Push-Up',
                sets: '3 set x 18 tekrar',
                rest: 'Set arasi: 30 sn',
                imagePath: path('Modified Push-Up.png'),
                fallbackImagePath: fallbackPath('Modified Push-Up.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Alternating Reverse Lunge',
                sets: '3 set x 20 tekrar (sag + sol)',
                rest: 'Set arasi: 30 sn',
                imagePath: path('Reverse Lunge.png'),
                fallbackImagePath: fallbackPath('Reverse Lunge.png'),
                cardHeight: 108,
              ),
              _ExerciseItem(
                title: 'Glute Bridge March',
                sets: '3 set x 30 saniye',
                rest: 'Set arasi: 30 sn',
                imagePath: path('Glute Bridge March.png'),
                fallbackImagePath: fallbackPath('Glute Bridge March.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Plank',
                sets: '3 set x 50 saniye',
                rest: 'Set arasi: 30 sn',
                imagePath: path('Plank.png'),
                fallbackImagePath: fallbackPath('Plank.png'),
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
                title: 'Shadow Boxing (yuksek tempo)',
                sets: '3 set x 60 saniye',
                rest: 'Set arasi: 30 sn',
                imagePath: path('Shadow Boxing\u00A0.png'),
                fallbackImagePath: fallbackPath('Shadow Boxing\u00A0.png'),
                cardHeight: 108,
              ),
            ],
          ),
        );
      case 10:
        return finalizeDayContent(
          _DayContent(
            items: [
              _ExerciseItem(
                title: 'High Knees',
                sets: '3 set x 60 saniye',
                rest: 'Set arasi: 25 sn',
                imagePath: path('High Knees\u00A0.png'),
                fallbackImagePath: fallbackPath('High Knees\u00A0.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Jump Squat',
                sets: '3 set x 20 tekrar',
                rest: 'Set arasi: 35 sn',
                imagePath: path('Jump Squat.png'),
                fallbackImagePath: fallbackPath('Jump Squat.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Walking Lunge',
                sets: '3 set x 20 tekrar (sag + sol)',
                rest: 'Set arasi: 30 sn',
                imagePath: path('Walking Lunge.png'),
                fallbackImagePath: fallbackPath('Walking Lunge.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Sumo Squat',
                sets: '3 set x 30 tekrar',
                rest: 'Set arasi: 30 sn',
                imagePath: path('Sumo Squat\u00A0.png'),
                fallbackImagePath: fallbackPath('Sumo Squat\u00A0.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Wall Sit',
                sets: '3 set x 60 saniye',
                rest: 'Set arasi: 30 sn',
                imagePath: path('Wall Sit.png'),
                fallbackImagePath: fallbackPath('Wall Sit.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Side Lunge',
                sets: '3 set x 20 tekrar (sag + sol)',
                rest: 'Set arasi: 30 sn',
                imagePath: path('Side Lunge.png'),
                fallbackImagePath: fallbackPath('Side Lunge.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Fast Feet Shuffle',
                sets: '3 set x 60 saniye',
                rest: 'Set arasi: 25 sn',
                imagePath: path('Fast Feet Shuffle.png'),
                fallbackImagePath: fallbackPath('Fast Feet Shuffle.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Butt Kicks',
                sets: '3 set x 60 saniye',
                rest: 'Set arasi: 25 sn',
                imagePath: path('Butt Kicks.png'),
                fallbackImagePath: fallbackPath('Butt Kicks.png'),
                cardHeight: 91,
              ),
            ],
          ),
        );
      case 11:
        return finalizeDayContent(
          _DayContent(
            items: [
              _ExerciseItem(
                title: 'Burpee',
                sets: '3 set x 18 tekrar',
                rest: 'Set arasi: 40 sn',
                imagePath: path('Burpee.png'),
                fallbackImagePath: fallbackPath('Burpee.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Skater Jump',
                sets: '3 set x 45 saniye',
                rest: 'Set arasi: 30 sn',
                imagePath: path('Skater Jump.png'),
                fallbackImagePath: fallbackPath('Skater Jump.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Mountain Climber',
                sets: '3 set x 60 saniye',
                rest: 'Set arasi: 30 sn',
                imagePath: path('Mountain Climber.png'),
                fallbackImagePath: fallbackPath('Mountain Climber.png'),
                cardHeight: 108,
              ),
              _ExerciseItem(
                title: 'Squat Thrust',
                sets: '3 set x 20 tekrar',
                rest: 'Set arasi: 35 sn',
                imagePath: path('Squat Thrust.png'),
                fallbackImagePath: fallbackPath('Squat Thrust.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Plank Jack',
                sets: '3 set x 45 saniye',
                rest: 'Set arasi: 30 sn',
                imagePath: path('Plank Jack.png'),
                fallbackImagePath: fallbackPath('Plank Jack.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Jumping Lunge',
                sets: '3 set x 18 tekrar (sag + sol)',
                rest: 'Set arasi: 40 sn',
                imagePath: path('Walking Lunge.png'),
                fallbackImagePath: fallbackPath('Walking Lunge.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'High Knees',
                sets: '3 set x 60 saniye',
                rest: 'Set arasi: 25 sn',
                imagePath: path('High Knees\u00A0.png'),
                fallbackImagePath: fallbackPath('High Knees\u00A0.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Shadow Boxing (maksimum tempo)',
                sets: '3 set x 60 saniye',
                rest: 'Set arasi: 25 sn',
                imagePath: path('Shadow Boxing\u00A0.png'),
                fallbackImagePath: fallbackPath('Shadow Boxing\u00A0.png'),
                cardHeight: 108,
              ),
            ],
          ),
        );
      case 12:
        return finalizeDayContent(
          const _DayContent(
            items: [],
            recoveryLines: [
              '45 dakika tempolu yuruyus',
              'Hafif esneme',
              'Kalca - hamstring - omuz mobilitesi',
              'Bol su + tuz dengesi',
            ],
          ),
        );
      case 13:
        return finalizeDayContent(
          _DayContent(
            items: [
              _ExerciseItem(
                title: 'Jump Squat',
                sets: 'Devre: 15 tekrar (3 tur)',
                rest: 'Devre bitince: 60 sn',
                imagePath: path('Jump Squat.png'),
                fallbackImagePath: fallbackPath('Jump Squat.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Push-Up',
                sets: 'Devre: 15 tekrar (3 tur)',
                rest: 'Devre ici gecis',
                imagePath: path('Modified Push-Up.png'),
                fallbackImagePath: fallbackPath('Modified Push-Up.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Mountain Climber',
                sets: 'Devre: 40 saniye (3 tur)',
                rest: 'Devre ici gecis',
                imagePath: path('Mountain Climber.png'),
                fallbackImagePath: fallbackPath('Mountain Climber.png'),
                cardHeight: 108,
              ),
              _ExerciseItem(
                title: 'Reverse Lunge',
                sets: 'Devre: 15 tekrar (sag + sol)',
                rest: 'Devre ici gecis',
                imagePath: path('Reverse Lunge.png'),
                fallbackImagePath: fallbackPath('Reverse Lunge.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Plank',
                sets: '3 set x 60 saniye',
                rest: 'Set arasi: 30 sn',
                imagePath: path('Plank.png'),
                fallbackImagePath: fallbackPath('Plank.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Shadow Boxing',
                sets: '3 set x 60 saniye',
                rest: 'Set arasi: 30 sn',
                imagePath: path('Shadow Boxing\u00A0.png'),
                fallbackImagePath: fallbackPath('Shadow Boxing\u00A0.png'),
                cardHeight: 108,
              ),
            ],
          ),
        );
      case 14:
        return finalizeDayContent(
          _DayContent(
            items: [
              _ExerciseItem(
                title: 'Bodyweight Squat',
                sets: 'Devre: 25 tekrar (4 tur)',
                rest: 'Devre arasi: 45 sn',
                imagePath: path('Bodyweight Squat.png'),
                fallbackImagePath: fallbackPath('Bodyweight Squat.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Walking Lunge',
                sets: 'Devre: 20 tekrar (sag + sol)',
                rest: 'Devre ici gecis',
                imagePath: path('Walking Lunge.png'),
                fallbackImagePath: fallbackPath('Walking Lunge.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'High Knees',
                sets: 'Devre: 45 saniye (4 tur)',
                rest: 'Devre ici gecis',
                imagePath: path('High Knees\u00A0.png'),
                fallbackImagePath: fallbackPath('High Knees\u00A0.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Wall Sit',
                sets: '3 set x 60 saniye',
                rest: 'Set arasi: 30 sn',
                imagePath: path('Wall Sit.png'),
                fallbackImagePath: fallbackPath('Wall Sit.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Glute Bridge',
                sets: '3 set x 25 tekrar',
                rest: 'Set arasi: 30 sn',
                imagePath: path('Glute Bridge.png'),
                fallbackImagePath: fallbackPath('Glute Bridge.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Butt Kicks',
                sets: '3 set x 60 saniye',
                rest: 'Set arasi: 25 sn',
                imagePath: path('Butt Kicks.png'),
                fallbackImagePath: fallbackPath('Butt Kicks.png'),
                cardHeight: 91,
              ),
            ],
          ),
        );
      case 15:
        return finalizeDayContent(
          _DayContent(
            items: [
              _ExerciseItem(
                title: 'Burpee',
                sets: '3 set x 20 tekrar',
                rest: 'Set arasi: 40 sn',
                imagePath: path('Burpee.png'),
                fallbackImagePath: fallbackPath('Burpee.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Skater Jump',
                sets: '3 set x 50 saniye',
                rest: 'Set arasi: 30 sn',
                imagePath: path('Skater Jump.png'),
                fallbackImagePath: fallbackPath('Skater Jump.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Jumping Lunge',
                sets: '3 set x 18 tekrar (sag + sol)',
                rest: 'Set arasi: 40 sn',
                imagePath: path('Walking Lunge.png'),
                fallbackImagePath: fallbackPath('Walking Lunge.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Plank Jack',
                sets: '3 set x 45 saniye',
                rest: 'Set arasi: 30 sn',
                imagePath: path('Plank Jack.png'),
                fallbackImagePath: fallbackPath('Plank Jack.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Fast Feet Shuffle',
                sets: '3 set x 60 saniye',
                rest: 'Set arasi: 25 sn',
                imagePath: path('Fast Feet Shuffle.png'),
                fallbackImagePath: fallbackPath('Fast Feet Shuffle.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Mountain Climber (maksimum tempo)',
                sets: '3 set x 60 saniye',
                rest: 'Set arasi: 30 sn',
                imagePath: path('Mountain Climber.png'),
                fallbackImagePath: fallbackPath('Mountain Climber.png'),
                cardHeight: 108,
              ),
              _ExerciseItem(
                title: 'Shadow Boxing',
                sets: '3 set x 60 saniye',
                rest: 'Set arasi: 25 sn',
                imagePath: path('Shadow Boxing\u00A0.png'),
                fallbackImagePath: fallbackPath('Shadow Boxing\u00A0.png'),
                cardHeight: 108,
              ),
            ],
          ),
        );
      case 16:
        return finalizeDayContent(
          const _DayContent(
            items: [],
            recoveryLines: [
              '45-50 dakika tempolu yuruyus',
              'Derin esneme',
              'Kalca fleksorleri + hamstring + omuz mobilitesi',
              'Su tuketimi artirilir',
              'Uyku suresi 7-8 saat olmali',
            ],
          ),
        );
      case 17:
        return finalizeDayContent(
          _DayContent(
            items: [
              _ExerciseItem(
                title: 'Burpee',
                sets: 'Devre: 15 tekrar (4 tur)',
                rest: 'Devre bitince: 60 sn',
                imagePath: path('Burpee.png'),
                fallbackImagePath: fallbackPath('Burpee.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Bodyweight Squat',
                sets: 'Devre: 30 tekrar (4 tur)',
                rest: 'Devre ici gecis',
                imagePath: path('Bodyweight Squat.png'),
                fallbackImagePath: fallbackPath('Bodyweight Squat.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Push-Up',
                sets: 'Devre: 20 tekrar (4 tur)',
                rest: 'Devre ici gecis',
                imagePath: path('Modified Push-Up.png'),
                fallbackImagePath: fallbackPath('Modified Push-Up.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Mountain Climber',
                sets: 'Devre: 50 saniye (4 tur)',
                rest: 'Devre ici gecis',
                imagePath: path('Mountain Climber.png'),
                fallbackImagePath: fallbackPath('Mountain Climber.png'),
                cardHeight: 108,
              ),
              _ExerciseItem(
                title: 'Jumping Jack',
                sets: 'Devre: 60 saniye (4 tur)',
                rest: 'Devre ici gecis',
                imagePath: path('Jumping Jack.png'),
                fallbackImagePath: fallbackPath('Jumping Jack.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Plank',
                sets: '3 set x 70 saniye',
                rest: 'Set arasi: 30 sn',
                imagePath: path('Plank.png'),
                fallbackImagePath: fallbackPath('Plank.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Shadow Boxing (yuksek tempo)',
                sets: '3 set x 60 saniye',
                rest: 'Set arasi: 25 sn',
                imagePath: path('Shadow Boxing\u00A0.png'),
                fallbackImagePath: fallbackPath('Shadow Boxing\u00A0.png'),
                cardHeight: 108,
              ),
            ],
          ),
        );
      case 18:
        return finalizeDayContent(
          _DayContent(
            items: [
              _ExerciseItem(
                title: 'Jump Squat',
                sets: '3 set x 20 tekrar',
                rest: 'Set arasi: 35 sn',
                imagePath: path('Jump Squat.png'),
                fallbackImagePath: fallbackPath('Jump Squat.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Walking Lunge',
                sets: '3 set x 22 tekrar (sag + sol)',
                rest: 'Set arasi: 30 sn',
                imagePath: path('Walking Lunge.png'),
                fallbackImagePath: fallbackPath('Walking Lunge.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Sumo Squat',
                sets: '3 set x 30 tekrar',
                rest: 'Set arasi: 30 sn',
                imagePath: path('Sumo Squat\u00A0.png'),
                fallbackImagePath: fallbackPath('Sumo Squat\u00A0.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Wall Sit',
                sets: '3 set x 70 saniye',
                rest: 'Set arasi: 30 sn',
                imagePath: path('Wall Sit.png'),
                fallbackImagePath: fallbackPath('Wall Sit.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'High Knees',
                sets: '3 set x 60 saniye',
                rest: 'Set arasi: 25 sn',
                imagePath: path('High Knees\u00A0.png'),
                fallbackImagePath: fallbackPath('High Knees\u00A0.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Side Lunge',
                sets: '3 set x 20 tekrar (sag + sol)',
                rest: 'Set arasi: 30 sn',
                imagePath: path('Side Lunge.png'),
                fallbackImagePath: fallbackPath('Side Lunge.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Butt Kicks',
                sets: '3 set x 60 saniye',
                rest: 'Set arasi: 25 sn',
                imagePath: path('Butt Kicks.png'),
                fallbackImagePath: fallbackPath('Butt Kicks.png'),
                cardHeight: 91,
              ),
            ],
          ),
        );
      case 19:
        return finalizeDayContent(
          _DayContent(
            items: [
              _ExerciseItem(
                title: 'Burpee',
                sets: '3 set x 22 tekrar',
                rest: 'Set arasi: 40 sn',
                imagePath: path('Burpee.png'),
                fallbackImagePath: fallbackPath('Burpee.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Skater Jump',
                sets: '3 set x 60 saniye',
                rest: 'Set arasi: 30 sn',
                imagePath: path('Skater Jump.png'),
                fallbackImagePath: fallbackPath('Skater Jump.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Jumping Lunge',
                sets: '3 set x 20 tekrar (sag + sol)',
                rest: 'Set arasi: 40 sn',
                imagePath: path('Walking Lunge.png'),
                fallbackImagePath: fallbackPath('Walking Lunge.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Plank Jack',
                sets: '3 set x 50 saniye',
                rest: 'Set arasi: 30 sn',
                imagePath: path('Plank Jack.png'),
                fallbackImagePath: fallbackPath('Plank Jack.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Mountain Climber (maksimum tempo)',
                sets: '3 set x 60 saniye',
                rest: 'Set arasi: 30 sn',
                imagePath: path('Mountain Climber.png'),
                fallbackImagePath: fallbackPath('Mountain Climber.png'),
                cardHeight: 108,
              ),
              _ExerciseItem(
                title: 'Fast Feet Shuffle',
                sets: '3 set x 60 saniye',
                rest: 'Set arasi: 25 sn',
                imagePath: path('Fast Feet Shuffle.png'),
                fallbackImagePath: fallbackPath('Fast Feet Shuffle.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Shadow Boxing',
                sets: '3 set x 60 saniye',
                rest: 'Set arasi: 25 sn',
                imagePath: path('Shadow Boxing\u00A0.png'),
                fallbackImagePath: fallbackPath('Shadow Boxing\u00A0.png'),
                cardHeight: 108,
              ),
            ],
          ),
        );
      case 20:
        return finalizeDayContent(
          const _DayContent(
            items: [],
            recoveryLines: [
              '45-60 dakika tempolu yuruyus',
              'Hafif mobilite',
              'Kalca - hamstring - sirt acma',
              'Bol su',
              'Yeterli protein',
            ],
          ),
        );
      case 21:
        return finalizeDayContent(
          _DayContent(
            items: [
              _ExerciseItem(
                title: 'Bodyweight Squat',
                sets: 'Devre: 30 tekrar (4 tur)',
                rest: 'Devre bitince: 60 sn',
                imagePath: path('Bodyweight Squat.png'),
                fallbackImagePath: fallbackPath('Bodyweight Squat.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Push-Up',
                sets: 'Devre: 20 tekrar (4 tur)',
                rest: 'Devre ici gecis',
                imagePath: path('Modified Push-Up.png'),
                fallbackImagePath: fallbackPath('Modified Push-Up.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'High Knees',
                sets: 'Devre: 60 saniye (4 tur)',
                rest: 'Devre ici gecis',
                imagePath: path('High Knees\u00A0.png'),
                fallbackImagePath: fallbackPath('High Knees\u00A0.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Reverse Lunge',
                sets: 'Devre: 20 tekrar (sag + sol)',
                rest: 'Devre ici gecis',
                imagePath: path('Reverse Lunge.png'),
                fallbackImagePath: fallbackPath('Reverse Lunge.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Plank Shoulder Tap',
                sets: '3 set x 30 tekrar (toplam)',
                rest: 'Set arasi: 30 sn',
                imagePath: path('Plank Shoulder Tap.png'),
                fallbackImagePath: fallbackPath('Plank Shoulder Tap.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Jump Rope',
                sets: '3 set x 60 saniye',
                rest: 'Set arasi: 30 sn',
                imagePath: path('Jump Rope.png'),
                fallbackImagePath: fallbackPath('Jump Rope.png'),
                cardHeight: 91,
              ),
            ],
          ),
        );
      case 22:
        return finalizeDayContent(
          _DayContent(
            items: [
              _ExerciseItem(
                title: 'Jump Squat',
                sets: '3 set x 20 tekrar',
                rest: 'Set arasi: 35 sn',
                imagePath: path('Jump Squat.png'),
                fallbackImagePath: fallbackPath('Jump Squat.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Walking Lunge',
                sets: '3 set x 24 tekrar (sag + sol)',
                rest: 'Set arasi: 30 sn',
                imagePath: path('Walking Lunge.png'),
                fallbackImagePath: fallbackPath('Walking Lunge.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Sumo Squat Pulse',
                sets: '3 set x 30 tekrar',
                rest: 'Set arasi: 30 sn',
                imagePath: path('Sumo Squat\u00A0.png'),
                fallbackImagePath: fallbackPath('Sumo Squat\u00A0.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Wall Sit',
                sets: '3 set x 75 saniye',
                rest: 'Set arasi: 30 sn',
                imagePath: path('Wall Sit.png'),
                fallbackImagePath: fallbackPath('Wall Sit.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Glute Bridge March',
                sets: '3 set x 40 saniye',
                rest: 'Set arasi: 30 sn',
                imagePath: path('Glute Bridge March.png'),
                fallbackImagePath: fallbackPath('Glute Bridge March.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Mountain Climber',
                sets: '3 set x 60 saniye',
                rest: 'Set arasi: 30 sn',
                imagePath: path('Mountain Climber.png'),
                fallbackImagePath: fallbackPath('Mountain Climber.png'),
                cardHeight: 108,
              ),
              _ExerciseItem(
                title: 'Butt Kicks',
                sets: '3 set x 60 saniye',
                rest: 'Set arasi: 25 sn',
                imagePath: path('Butt Kicks.png'),
                fallbackImagePath: fallbackPath('Butt Kicks.png'),
                cardHeight: 91,
              ),
            ],
          ),
        );
      case 23:
        return finalizeDayContent(
          _DayContent(
            items: [
              _ExerciseItem(
                title: 'Burpee',
                sets: '3 set x 20 tekrar',
                rest: 'Set arasi: 40 sn',
                imagePath: path('Burpee.png'),
                fallbackImagePath: fallbackPath('Burpee.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Skater Jump',
                sets: '3 set x 60 saniye',
                rest: 'Set arasi: 30 sn',
                imagePath: path('Skater Jump.png'),
                fallbackImagePath: fallbackPath('Skater Jump.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Jumping Lunge',
                sets: '3 set x 20 tekrar (sag + sol)',
                rest: 'Set arasi: 40 sn',
                imagePath: path('Walking Lunge.png'),
                fallbackImagePath: fallbackPath('Walking Lunge.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Plank Jack',
                sets: '3 set x 60 saniye',
                rest: 'Set arasi: 30 sn',
                imagePath: path('Plank Jack.png'),
                fallbackImagePath: fallbackPath('Plank Jack.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Fast Feet Shuffle',
                sets: '3 set x 60 saniye',
                rest: 'Set arasi: 25 sn',
                imagePath: path('Fast Feet Shuffle.png'),
                fallbackImagePath: fallbackPath('Fast Feet Shuffle.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Mountain Climber (maksimum tempo)',
                sets: '3 set x 60 saniye',
                rest: 'Set arasi: 30 sn',
                imagePath: path('Mountain Climber.png'),
                fallbackImagePath: fallbackPath('Mountain Climber.png'),
                cardHeight: 108,
              ),
              _ExerciseItem(
                title: 'Shadow Boxing',
                sets: '3 set x 60 saniye',
                rest: 'Set arasi: 25 sn',
                imagePath: path('Shadow Boxing\u00A0.png'),
                fallbackImagePath: fallbackPath('Shadow Boxing\u00A0.png'),
                cardHeight: 108,
              ),
            ],
          ),
        );
      case 24:
        return finalizeDayContent(
          const _DayContent(
            items: [],
            recoveryLines: [
              '45-60 dakika tempolu yuruyus',
              'Derin esneme',
              'Kalca - sirt - omuz mobilitesi',
              'Uykuya dikkat',
              'Su tuketimi yuksek tutulur',
            ],
          ),
        );
      case 25:
        return finalizeDayContent(
          _DayContent(
            items: [
              _ExerciseItem(
                title: 'Jump Squat',
                sets: 'Devre: 20 tekrar (4 tur)',
                rest: 'Devre bitince: 60 sn',
                imagePath: path('Jump Squat.png'),
                fallbackImagePath: fallbackPath('Jump Squat.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Push-Up',
                sets: 'Devre: 22 tekrar (4 tur)',
                rest: 'Devre ici gecis',
                imagePath: path('Modified Push-Up.png'),
                fallbackImagePath: fallbackPath('Modified Push-Up.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Mountain Climber',
                sets: 'Devre: 60 saniye (4 tur)',
                rest: 'Devre ici gecis',
                imagePath: path('Mountain Climber.png'),
                fallbackImagePath: fallbackPath('Mountain Climber.png'),
                cardHeight: 108,
              ),
              _ExerciseItem(
                title: 'Walking Lunge',
                sets: 'Devre: 24 tekrar (sag + sol)',
                rest: 'Devre ici gecis',
                imagePath: path('Walking Lunge.png'),
                fallbackImagePath: fallbackPath('Walking Lunge.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Jumping Jack',
                sets: 'Devre: 60 saniye (4 tur)',
                rest: 'Devre ici gecis',
                imagePath: path('Jumping Jack.png'),
                fallbackImagePath: fallbackPath('Jumping Jack.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Plank',
                sets: '3 set x 80 saniye',
                rest: 'Set arasi: 30 sn',
                imagePath: path('Plank.png'),
                fallbackImagePath: fallbackPath('Plank.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Shadow Boxing',
                sets: '3 set x 60 saniye',
                rest: 'Set arasi: 25 sn',
                imagePath: path('Shadow Boxing\u00A0.png'),
                fallbackImagePath: fallbackPath('Shadow Boxing\u00A0.png'),
                cardHeight: 108,
              ),
            ],
          ),
        );
      case 26:
        return finalizeDayContent(
          _DayContent(
            items: [
              _ExerciseItem(
                title: 'Bodyweight Squat',
                sets: '3 set x 35 tekrar',
                rest: 'Set arasi: 30 sn',
                imagePath: path('Bodyweight Squat.png'),
                fallbackImagePath: fallbackPath('Bodyweight Squat.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Jumping Lunge',
                sets: '3 set x 22 tekrar (sag + sol)',
                rest: 'Set arasi: 40 sn',
                imagePath: path('Walking Lunge.png'),
                fallbackImagePath: fallbackPath('Walking Lunge.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Sumo Squat',
                sets: '3 set x 35 tekrar',
                rest: 'Set arasi: 30 sn',
                imagePath: path('Sumo Squat\u00A0.png'),
                fallbackImagePath: fallbackPath('Sumo Squat\u00A0.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Wall Sit',
                sets: '3 set x 80 saniye',
                rest: 'Set arasi: 30 sn',
                imagePath: path('Wall Sit.png'),
                fallbackImagePath: fallbackPath('Wall Sit.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'High Knees',
                sets: '3 set x 60 saniye',
                rest: 'Set arasi: 25 sn',
                imagePath: path('High Knees\u00A0.png'),
                fallbackImagePath: fallbackPath('High Knees\u00A0.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Glute Bridge',
                sets: '3 set x 25 tekrar',
                rest: 'Set arasi: 30 sn',
                imagePath: path('Glute Bridge.png'),
                fallbackImagePath: fallbackPath('Glute Bridge.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Butt Kicks',
                sets: '3 set x 60 saniye',
                rest: 'Set arasi: 25 sn',
                imagePath: path('Butt Kicks.png'),
                fallbackImagePath: fallbackPath('Butt Kicks.png'),
                cardHeight: 91,
              ),
            ],
          ),
        );
      case 27:
        return finalizeDayContent(
          _DayContent(
            items: [
              _ExerciseItem(
                title: 'Burpee',
                sets: '3 set x 25 tekrar',
                rest: 'Set arasi: 40 sn',
                imagePath: path('Burpee.png'),
                fallbackImagePath: fallbackPath('Burpee.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Skater Jump',
                sets: '3 set x 60 saniye',
                rest: 'Set arasi: 30 sn',
                imagePath: path('Skater Jump.png'),
                fallbackImagePath: fallbackPath('Skater Jump.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Squat Thrust',
                sets: '3 set x 22 tekrar',
                rest: 'Set arasi: 35 sn',
                imagePath: path('Squat Thrust.png'),
                fallbackImagePath: fallbackPath('Squat Thrust.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Plank Jack',
                sets: '3 set x 60 saniye',
                rest: 'Set arasi: 30 sn',
                imagePath: path('Plank Jack.png'),
                fallbackImagePath: fallbackPath('Plank Jack.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Mountain Climber (maksimum tempo)',
                sets: '3 set x 70 saniye',
                rest: 'Set arasi: 30 sn',
                imagePath: path('Mountain Climber.png'),
                fallbackImagePath: fallbackPath('Mountain Climber.png'),
                cardHeight: 108,
              ),
              _ExerciseItem(
                title: 'Fast Feet Shuffle',
                sets: '3 set x 60 saniye',
                rest: 'Set arasi: 25 sn',
                imagePath: path('Fast Feet Shuffle.png'),
                fallbackImagePath: fallbackPath('Fast Feet Shuffle.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Shadow Boxing',
                sets: '3 set x 60 saniye',
                rest: 'Set arasi: 25 sn',
                imagePath: path('Shadow Boxing\u00A0.png'),
                fallbackImagePath: fallbackPath('Shadow Boxing\u00A0.png'),
                cardHeight: 108,
              ),
            ],
          ),
        );
      case 28:
        return finalizeDayContent(
          const _DayContent(
            items: [],
            recoveryLines: [
              '45-60 dakika tempolu yuruyus',
              'Derin esneme',
              'Mobilite',
              'Bol su',
              'Uyku',
            ],
          ),
        );
      case 29:
        return finalizeDayContent(
          _DayContent(
            items: [
              _ExerciseItem(
                title: 'Bodyweight Squat',
                sets: 'Devre: 30 tekrar (4 tur)',
                rest: 'Devre ici gecis',
                imagePath: path('Bodyweight Squat.png'),
                fallbackImagePath: fallbackPath('Bodyweight Squat.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Push-Up',
                sets: 'Devre: 20 tekrar (4 tur)',
                rest: 'Devre ici gecis',
                imagePath: path('Modified Push-Up.png'),
                fallbackImagePath: fallbackPath('Modified Push-Up.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'High Knees',
                sets: 'Devre: 60 saniye (4 tur)',
                rest: 'Devre ici gecis',
                imagePath: path('High Knees\u00A0.png'),
                fallbackImagePath: fallbackPath('High Knees\u00A0.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Reverse Lunge',
                sets: 'Devre: 20 tekrar (sag + sol)',
                rest: 'Devre ici gecis',
                imagePath: path('Reverse Lunge.png'),
                fallbackImagePath: fallbackPath('Reverse Lunge.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Plank Shoulder Tap',
                sets: '3 set x 30 tekrar',
                rest: 'Set arasi: 30 sn',
                imagePath: path('Plank Shoulder Tap.png'),
                fallbackImagePath: fallbackPath('Plank Shoulder Tap.png'),
                cardHeight: 91,
              ),
              _ExerciseItem(
                title: 'Jump Rope',
                sets: '3 set x 60 saniye',
                rest: 'Set arasi: 30 sn',
                imagePath: path('Jump Rope.png'),
                fallbackImagePath: fallbackPath('Jump Rope.png'),
                cardHeight: 91,
              ),
            ],
          ),
        );
      case 30:
        return finalizeDayContent(
          _DayContent(
            items: [
              _ExerciseItem(
                title: 'Burpee',
                sets: '3 set x maksimum tekrar (60 sn)',
                rest: 'Set arasi: 60 sn',
                imagePath: path('Burpee.png'),
                fallbackImagePath: fallbackPath('Burpee.png'),
                cardHeight: 108,
              ),
              _ExerciseItem(
                title: 'Jump Squat',
                sets: '3 set x maksimum tekrar (45 sn)',
                rest: 'Set arasi: 45 sn',
                imagePath: path('Jump Squat.png'),
                fallbackImagePath: fallbackPath('Jump Squat.png'),
                cardHeight: 108,
              ),
              _ExerciseItem(
                title: 'Mountain Climber',
                sets: '3 set x 75 saniye',
                rest: 'Set arasi: 30 sn',
                imagePath: path('Mountain Climber.png'),
                fallbackImagePath: fallbackPath('Mountain Climber.png'),
                cardHeight: 108,
              ),
              _ExerciseItem(
                title: 'Push-Up',
                sets: '3 set x maksimum tekrar',
                rest: 'Set arasi: 45 sn',
                imagePath: path('Modified Push-Up.png'),
                fallbackImagePath: fallbackPath('Modified Push-Up.png'),
                cardHeight: 108,
              ),
              _ExerciseItem(
                title: 'Plank',
                sets: '1 set x maksimum sure',
                rest: 'Sonda: 5-10 dk yuruyus + derin nefes',
                imagePath: path('Plank.png'),
                fallbackImagePath: fallbackPath('Plank.png'),
                cardHeight: 108,
              ),
            ],
          ),
        );
      default:
        return finalizeDayContent(_DayContent(items: defaultItems));
    }
  }

  _DayContent _remoteDayContent(
    BuildContext context,
    int dayNumber,
    WorkoutDayDetailModel remoteDay,
  ) {
    if (remoteDay.type == 'rest' || remoteDay.exercises.isEmpty) {
      final line = remoteDay.estimatedMinutes > 0
          ? '${remoteDay.title} • ${remoteDay.estimatedMinutes} min'
          : remoteDay.title;
      return _DayContent(items: const <_ExerciseItem>[], recoveryLines: [line]);
    }

    final imagePath =
        'assets/images/antrenman/day${((dayNumber - 1) % 16) + 1}.jpg';
    return _DayContent(
      items: remoteDay.exercises
          .map(
            (exercise) => _ExerciseItem(
              title: exercise.name,
              sets: '${exercise.sets} x ${exercise.reps}',
              rest: _locale(context).rest30Sec,
              imagePath: imagePath,
              fallbackImagePath: imagePath,
              cardHeight: 108,
            ),
          )
          .toList(growable: false),
    );
  }

  int _resolveExerciseDurationSeconds(_ExerciseItem item) {
    final text = '${item.sets} ${item.rest}'.toLowerCase();

    final minuteMatch = RegExp(r'(\d+)\s*(m|min|dk)').firstMatch(text);
    if (minuteMatch != null) {
      final minutes = int.tryParse(minuteMatch.group(1) ?? '0') ?? 0;
      if (minutes > 0) {
        return minutes * 60;
      }
    }

    final secMatch = RegExp(r'(\d+)\s*(s|sec|sn|saniye)').firstMatch(text);
    if (secMatch != null) {
      final seconds = int.tryParse(secMatch.group(1) ?? '0') ?? 0;
      if (seconds > 0) {
        return seconds;
      }
    }

    return 60;
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

    final safeDayNumber = data.dayNumber.clamp(1, 30).toInt();
    final remoteDayAsync = ref.watch(workoutDayDetailProvider(safeDayNumber));
    final remoteDay = remoteDayAsync.valueOrNull;
    final safeProgramTitle = (data.dayNumber >= 1 && data.dayNumber <= 30)
        ? data.programTitle
        : locale.defaultProgramTitle;

    final dayContent = remoteDay != null
        ? _remoteDayContent(context, safeDayNumber, remoteDay)
        : _dayContent(context, safeDayNumber);
    final displayTitle = remoteDay != null && remoteDay.title.trim().isNotEmpty
        ? remoteDay.title
        : safeProgramTitle;
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
                                  locale.dayTitle(safeDayNumber, displayTitle),
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
                                    onTap: items[i].locked
                                        ? null
                                        : () {
                                            final playableItems = items
                                                .where(
                                                  (exercise) =>
                                                      !exercise.locked,
                                                )
                                                .toList(growable: false);
                                            final initialPlayableIndex =
                                                playableItems.indexOf(items[i]);

                                            final detailExercises = playableItems
                                                .map(
                                                  (
                                                    exercise,
                                                  ) => WorkoutDetailExercise(
                                                    title: exercise.title,
                                                    subtitle: exercise.sets,
                                                    imagePath:
                                                        exercise.imagePath,
                                                    videoUrl:
                                                        resolveExerciseVideoUrlByMedia(
                                                          mediaPath: exercise
                                                              .imagePath,
                                                          title: exercise.title,
                                                        ),
                                                    durationSeconds:
                                                        _resolveExerciseDurationSeconds(
                                                          exercise,
                                                        ),
                                                  ),
                                                )
                                                .toList(growable: false);

                                            Navigator.of(context).pushNamed(
                                              AppRoutes.workoutDetail,
                                              arguments: WorkoutDetailArgs(
                                                programTitle: displayTitle,
                                                exercises: detailExercises,
                                                initialIndex:
                                                    initialPlayableIndex < 0
                                                    ? 0
                                                    : initialPlayableIndex,
                                                fixedDurationSeconds: 600,
                                              ),
                                            );
                                          },
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
    this.onTap,
  });

  final _ExerciseItem item;
  final String iconBase;
  final bool light;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          width: 342.w,
          height: item.cardHeight.h,
          decoration: BoxDecoration(
            color: light ? const Color(0xFFF3FFF7) : const Color(0xFFF5FEFF),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: const Color.fromRGBO(241, 241, 241, 0.73),
            ),
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
        ),
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
