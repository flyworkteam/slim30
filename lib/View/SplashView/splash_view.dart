import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slim30/Core/Auth/auth_service.dart';
import 'package:slim30/Core/Routes/app_routes.dart';
import 'package:slim30/Core/Storage/auth_token_store.dart';
import 'package:slim30/Core/Theme/my_colors.dart';
import 'package:slim30/l10n/generated/app_localizations.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 1500), () async {
      if (!mounted) return;

      final token = await AuthTokenStore.getToken();
      if (!mounted) {
        return;
      }

      String initialRoute = AppRoutes.onboardingIntro;
      if (token != null && token.trim().isNotEmpty) {
        final onboardingStatus = await AuthService.getOnboardingStatus();
        if (!mounted) {
          return;
        }
        if (onboardingStatus == OnboardingStatus.completed) {
          initialRoute = AppRoutes.home;
        } else if (onboardingStatus == OnboardingStatus.incomplete) {
          initialRoute = AppRoutes.questionGender;
        } else {
          initialRoute = AppRoutes.onboardingIntro;
        }
      }

      Navigator.pushReplacementNamed(context, initialRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: MyColors.scaffoldBackground,
      body: Center(
        child: SizedBox(
          width: 198.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 160.w,
                height: 160.w,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment(0.08, -1.0),
                    end: Alignment(-0.08, 1.0),
                    colors: [MyColors.splashCardStart, MyColors.splashCardEnd],
                  ),
                  border: Border.all(color: MyColors.splashBorder, width: 0.8),
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 24,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        left: -17.w,
                        right: -17.w,
                        top: -10.h,
                        bottom: -24.h,
                        child: Image.asset(
                          'assets/images/slim30_appicon.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                l10n.splashBrand,
                textAlign: TextAlign.center,
                style: GoogleFonts.leagueSpartan(
                  fontSize: 42.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                  height: 39 / 42,
                  color: MyColors.splashText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
