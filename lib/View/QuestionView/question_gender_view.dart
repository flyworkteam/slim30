import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slim30/Core/Storage/user_prefs.dart';
import 'package:slim30/Core/Network/onboarding_api.dart';
import 'package:slim30/Core/Routes/app_routes.dart';
import 'package:slim30/Core/Theme/my_colors.dart';
import 'package:slim30/View/QuestionView/widgets/question_bottom_actions.dart';
import 'package:slim30/l10n/generated/app_localizations.dart';

enum _Gender { female, male, unspecified }

extension on _Gender {
  UserGender toUserGender() {
    switch (this) {
      case _Gender.female:
        return UserGender.female;
      case _Gender.male:
        return UserGender.male;
      case _Gender.unspecified:
        return UserGender.unspecified;
    }
  }
}

class QuestionGenderView extends StatefulWidget {
  const QuestionGenderView({super.key});

  @override
  State<QuestionGenderView> createState() => _QuestionGenderViewState();
}

class _QuestionGenderViewState extends State<QuestionGenderView> {
  _Gender? _selected;

  static const int _currentStep = 1;
  static const int _totalSteps = 12;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
                  onTap: () async {
                    final navigator = Navigator.of(context);
                    await UserPrefs.setGender(UserGender.unspecified);
                    if (!mounted) return;
                    navigator.pushNamedAndRemoveUntil(
                      AppRoutes.home,
                      (route) => false,
                    );
                  },
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
                    // Question title
                    SizedBox(
                      width: 342.w,
                      child: Text(
                        l10n.questionGenderTitle,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          height: 17 / 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    // Step counter
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
                    // Progress bar
                    _ProgressBar(current: _currentStep, total: _totalSteps),
                  ],
                ),
              ),

              // ── Gender cards ─────────────────────────────────────
              Positioned(
                left: 24.w,
                top: 252.h,
                width: 342.w,
                child: Column(
                  children: [
                    // Female & Male cards side by side
                    SizedBox(
                      width: 324.w,
                      child: Row(
                        children: [
                          _GenderCard(
                            imagePath: 'assets/images/woman.jpg',
                            label: l10n.questionGenderFemale,
                            selected: _selected == _Gender.female,
                            onTap: () async {
                              setState(() => _selected = _Gender.female);
                              await UserPrefs.setGender(UserGender.female);
                            },
                          ),
                          SizedBox(width: 16.w),
                          _GenderCard(
                            imagePath: 'assets/images/man.jpg',
                            label: l10n.questionGenderMale,
                            selected: _selected == _Gender.male,
                            onTap: () async {
                              setState(() => _selected = _Gender.male);
                              await UserPrefs.setGender(UserGender.male);
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 27.h),
                    // Prefer not to say
                    _UnspecifiedOption(
                      label: l10n.questionGenderUnspecified,
                      selected: _selected == _Gender.unspecified,
                      onTap: () async {
                        setState(() => _selected = _Gender.unspecified);
                        await UserPrefs.setGender(UserGender.unspecified);
                      },
                    ),
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
                  onNext: _selected == null
                      ? null
                      : () {
                          final selected = _selected!;
                          UserPrefs.setGender(selected.toUserGender());
                          OnboardingApi.tryUpsertAnswer('gender', selected.name);
                          Navigator.pushNamed(context, AppRoutes.questionAge);
                        },
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

// ── Progress bar ──────────────────────────────────────────────────────────────

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.current, required this.total});

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    final fraction = current / total;
    final fillWidth = 342.w * fraction;

    return SizedBox(
      width: 342.w,
      height: 10.h,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          // Background track
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
          // Gradient fill
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
          // Dot at fill edge
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

// ── Gender card ───────────────────────────────────────────────────────────────

class _GenderCard extends StatelessWidget {
  const _GenderCard({
    required this.imagePath,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String imagePath;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 154.w,
        height: 218.h,
        child: Stack(
          children: [
            Container(
              width: 154.w,
              height: 218.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                gradient: selected ? MyColors.onboardingButtonGradient : null,
                color: selected ? null : Colors.white,
                border: selected
                    ? null
                    : Border.all(color: const Color(0xFFF1F1F1), width: 1),
              ),
            ),
            Positioned(
              left: 6.w,
              top: 7.h,
              child: SizedBox(
                width: 141.w,
                height: 207.h,
                child: Column(
                  children: [
                    SizedBox(
                      width: 141.w,
                      height: 184.h,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                          alignment: const Alignment(0.9, 0),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    SizedBox(
                      width: 141.w,
                      height: 15.h,
                      child: Center(
                        child: Text(
                          label,
                          style: GoogleFonts.leagueSpartan(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            height: 15 / 16,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
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

// ── "Prefer not to say" option ────────────────────────────────────────────────

class _UnspecifiedOption extends StatelessWidget {
  const _UnspecifiedOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 342.w,
        height: 44.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: selected ? const Color(0xFF66F393) : const Color(0xFFEBEBEB),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/icons/iconsax-slash.svg',
              width: 16.w,
              height: 16.h,
            ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: GoogleFonts.leagueSpartan(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                height: 15 / 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
