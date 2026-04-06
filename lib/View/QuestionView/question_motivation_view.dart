import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slim30/Core/Network/onboarding_api.dart';
import 'package:slim30/Core/Routes/app_routes.dart';
import 'package:slim30/View/QuestionView/widgets/question_bottom_actions.dart';
import 'package:slim30/l10n/generated/app_localizations.dart';

class QuestionMotivationView extends StatelessWidget {
  const QuestionMotivationView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 390.w,
          height: 844.h,
          child: Stack(
            children: [
              // ── Full-screen background image with dark overlay ───
              Positioned.fill(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/image-ara.jpg',
                      fit: BoxFit.cover,
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(0, 0, 0, 0.31),
                      ),
                    ),
                  ],
                ),
              ),

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
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              // ── Text block (top: 529) ────────────────────────────
              Positioned(
                left: 24.w,
                top: 529.h,
                width: 342.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main title
                    Text(
                      l10n.motivationTitle,
                      style: GoogleFonts.leagueSpartan(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w700,
                        height: 26 / 28,
                        letterSpacing: -0.308,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    // Subtitle
                    Text(
                      l10n.motivationSubtitle,
                      style: GoogleFonts.leagueSpartan(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w500,
                        height: 22 / 24,
                        letterSpacing: -0.264,
                        color: const Color(0xFFEDEDED),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    // Caption
                    Text(
                      l10n.motivationCaption,
                      style: GoogleFonts.leagueSpartan(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500,
                        height: 18 / 20,
                        letterSpacing: -0.22,
                        color: const Color(0xFFEBEBEB),
                      ),
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
                  onNext: () {
                    OnboardingApi.tryUpsertAnswer('motivation_seen', true);
                    Navigator.pushNamed(context, AppRoutes.questionWorkout);
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
