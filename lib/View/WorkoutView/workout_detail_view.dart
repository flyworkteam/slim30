import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slim30/l10n/generated/app_localizations.dart';

class WorkoutDetailExercise {
  const WorkoutDetailExercise({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.durationSeconds,
  });

  final String title;
  final String subtitle;
  final String imagePath;
  final int durationSeconds;
}

class WorkoutDetailArgs {
  const WorkoutDetailArgs({
    required this.programTitle,
    required this.exercises,
    required this.initialIndex,
    this.fixedDurationSeconds,
  });

  final String programTitle;
  final List<WorkoutDetailExercise> exercises;
  final int initialIndex;
  final int? fixedDurationSeconds;
}

class WorkoutDetailView extends StatefulWidget {
  const WorkoutDetailView({super.key});

  @override
  State<WorkoutDetailView> createState() => _WorkoutDetailViewState();
}

class _WorkoutDetailViewState extends State<WorkoutDetailView> {
  static const int _defaultSeconds = 600;
  bool _initialized = false;

  late WorkoutDetailArgs _args;
  late int _currentIndex;
  late int _totalSeconds;
  late int _remainingSeconds;
  bool _isRunning = true;
  Timer? _ticker;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initialized) {
      return;
    }

    final l10n = AppLocalizations.of(context)!;

    final modalArgs = ModalRoute.of(context)?.settings.arguments;
    _args = modalArgs is WorkoutDetailArgs
        ? modalArgs
        : WorkoutDetailArgs(
            programTitle: l10n.workoutDetailDefaultProgramTitle,
            exercises: const [],
            initialIndex: 0,
          );

    if (_args.exercises.isEmpty) {
      _args = WorkoutDetailArgs(
        programTitle: l10n.workoutDetailDefaultProgramTitle,
        exercises: [
          WorkoutDetailExercise(
            title: l10n.workoutDetailDefaultExerciseTitle,
            subtitle: l10n.workoutDetailDefaultExerciseSubtitle,
            imagePath: 'assets/images/antrenman/day1.jpg',
            durationSeconds: 40,
          ),
        ],
        initialIndex: 0,
      );
    }

    _currentIndex = _args.initialIndex.clamp(0, _args.exercises.length - 1);
    _resetTimerForCurrentExercise(startRunning: true);
    _initialized = true;
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  WorkoutDetailExercise get _currentExercise => _args.exercises[_currentIndex];
  bool get _isWorkoutCompleted =>
      _currentIndex >= _args.exercises.length - 1 && _remainingSeconds <= 0;

  String _mmss(int totalSeconds) {
    final mm = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final ss = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || !_isRunning) {
        return;
      }

      final nextRemaining = _remainingSeconds - 1;
      if (nextRemaining <= 0) {
        setState(() {
          _remainingSeconds = 0;
          _isRunning = false;
        });
        _stopTicker();
        return;
      }

      setState(() {
        _remainingSeconds = nextRemaining;
      });
    });
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  void _resetTimerForCurrentExercise({required bool startRunning}) {
    final forcedSeconds = _args.fixedDurationSeconds;
    _totalSeconds = (forcedSeconds != null && forcedSeconds > 0)
        ? forcedSeconds
        : (_currentExercise.durationSeconds > 0
              ? _currentExercise.durationSeconds
              : _defaultSeconds);
    _remainingSeconds = _totalSeconds;
    _isRunning = startRunning;
    if (_isRunning) {
      _startTicker();
    } else {
      _stopTicker();
    }
  }

  void _togglePause() {
    if (_remainingSeconds <= 0 || _isWorkoutCompleted) {
      return;
    }

    setState(() {
      _isRunning = !_isRunning;
    });

    if (_isRunning) {
      _startTicker();
    } else {
      _stopTicker();
    }
  }

  void _goNextExercise() {
    if (_currentIndex >= _args.exercises.length - 1) {
      setState(() {
        _remainingSeconds = 0;
        _isRunning = false;
      });
      _stopTicker();
      return;
    }

    setState(() {
      _currentIndex += 1;
      _resetTimerForCurrentExercise(startRunning: true);
    });
  }

  void _goPrevExercise() {
    if (_currentIndex <= 0) {
      return;
    }

    setState(() {
      _currentIndex -= 1;
      _resetTimerForCurrentExercise(startRunning: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final progress = _totalSeconds == 0
        ? 0.0
        : (_totalSeconds - _remainingSeconds) / _totalSeconds;
    final completedPercent = (progress * 100).round();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: 390.w,
          height: 844.h,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                width: 391.w,
                height: 443.h,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.r),
                    bottomRight: Radius.circular(10.r),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        _currentExercise.imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(color: const Color(0xFFEDEDED)),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 25.w,
                top: 92.h,
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(14.r),
                  child: Container(
                    width: 28.w,
                    height: 28.h,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 17.w,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 24.w,
                top: 468.h,
                width: 342.w,
                child: Column(
                  children: [
                    SizedBox(
                      width: 342.w,
                      child: Text(
                        '${_currentIndex + 1}/${_args.exercises.length}',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                          height: 22 / 17,
                          color: const Color(0xFF25E664),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    SizedBox(
                      width: 342.w,
                      child: Text(
                        _currentExercise.title,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          height: 17 / 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    SizedBox(
                      width: 342.w,
                      height: 83.h,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 78.62.w,
                            height: 80.h,
                            child: CustomPaint(
                              painter: _TimerRingPainter(
                                progress: progress.clamp(0.0, 1.0),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            child: Container(
                              width: 10.w,
                              height: 10.h,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFF66F393),
                                    Color(0xFF88F3CF),
                                    Color(0xFFA3F3FF),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Text(
                            _mmss(_remainingSeconds),
                            style: GoogleFonts.montserrat(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w600,
                              height: 22 / 17,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                    SizedBox(
                      width: 342.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${l10n.workoutDetailRemainingLabel}: ${_mmss(_remainingSeconds)}',
                            style: GoogleFonts.leagueSpartan(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              height: 22 / 14,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            '${l10n.workoutDetailCompletedLabel}: %$completedPercent',
                            style: GoogleFonts.leagueSpartan(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              height: 22 / 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 104.w,
                top: 670.h,
                width: 182.w,
                height: 60.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: _goPrevExercise,
                      borderRadius: BorderRadius.circular(20.r),
                      child: SizedBox(
                        width: 40.w,
                        height: 40.h,
                        child: SvgPicture.asset(
                          'assets/images/icons/progress_icon/iconsax-arrow-square-right.svg',
                          width: 40.w,
                          height: 40.h,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: _togglePause,
                      borderRadius: BorderRadius.circular(30.r),
                      child: SizedBox(
                        width: 60.w,
                        height: 60.h,
                        child: _isRunning
                            ? SvgPicture.asset(
                                'assets/images/icons/progress_icon/iconsax-pause-circle.svg',
                                width: 60.w,
                                height: 60.h,
                              )
                            : Container(
                                width: 60.w,
                                height: 60.h,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF32EA6E),
                                ),
                                child: Icon(
                                  Icons.play_arrow,
                                  size: 34.w,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    InkWell(
                      onTap: _goNextExercise,
                      borderRadius: BorderRadius.circular(20.r),
                      child: SizedBox(
                        width: 40.w,
                        height: 40.h,
                        child: SvgPicture.asset(
                          'assets/images/icons/progress_icon/iconsax-arrow-square-right (1).svg',
                          width: 40.w,
                          height: 40.h,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 24.w,
                top: 760.h,
                child: InkWell(
                  onTap: _goNextExercise,
                  borderRadius: BorderRadius.circular(6.r),
                  child: Container(
                    width: 142.w,
                    height: 38.h,
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
                    alignment: Alignment.center,
                    child: Text(
                      l10n.workoutDetailNextMove,
                      style: GoogleFonts.leagueSpartan(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        height: 15 / 16,
                        letterSpacing: -0.176,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
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

class _TimerRingPainter extends CustomPainter {
  const _TimerRingPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide / 2) - 5;
    const startAngle = -1.57079632679;
    final sweep = (6.28318530718 * progress).clamp(0.0, 6.28318530718);

    final backgroundPaint = Paint()
      ..color = const Color(0xFFEFEFEF)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 9;

    final gradientPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF66F393), Color(0xFF88F3CF), Color(0xFFA3F3FF)],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 9;

    canvas.drawCircle(center, radius, backgroundPaint);
    if (sweep > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweep,
        false,
        gradientPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _TimerRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
