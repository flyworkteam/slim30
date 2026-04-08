import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slim30/Core/Theme/my_colors.dart';

class OnboardingShell extends StatelessWidget {
  const OnboardingShell({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.skipLabel,
    required this.continueLabel,
    required this.activeIndex,
    required this.onContinue,
    this.showImageFade = false,
    this.onSkip,
  });

  final String imagePath;
  final String title;
  final String description;
  final String skipLabel;
  final String continueLabel;
  final int activeIndex;
  final VoidCallback onContinue;
  final VoidCallback? onSkip;
  final bool showImageFade;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: 390.w,
          height: 844.h,
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(color: MyColors.scaffoldBackground),
              ),
              Positioned(
                left: 0,
                top: 0,
                width: 390.w,
                height: 444.h,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.r),
                    bottomRight: Radius.circular(10.r),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(imagePath, fit: BoxFit.cover),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: MyColors.onboardingImageOverlay,
                        ),
                      ),
                      if (showImageFade)
                        Positioned(
                          left: 0,
                          top: 326.h,
                          width: 390.w,
                          height: 118.h,
                          child: const DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: MyColors.onboardingImageFade,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 330.w,
                top: 72.h,
                child: GestureDetector(
                  onTap: onSkip,
                  child: Text(
                    skipLabel,
                    style: GoogleFonts.leagueSpartan(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.176,
                      height: 15 / 16,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: -8.w,
                top: 422.h,
                width: 406.w,
                height: 43.h,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.98),
                        blurRadius: 6.15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 24.w,
                top: 465.h,
                width: 342.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.leagueSpartan(
                            color: MyColors.onboardingBody,
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w700,
                            height: 30 / 28,
                            letterSpacing: -0.308,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          description,
                          style: GoogleFonts.leagueSpartan(
                            color: MyColors.onboardingBody,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            height: 15 / 16,
                            letterSpacing: -0.176,
                          ),
                        ),
                        SizedBox(height: 48.h),
                        _PageIndicator(activeIndex: activeIndex),
                      ],
                    ),
                    SizedBox(height: activeIndex == 1 ? 99.h : 106.h),
                    _ContinueButton(
                      label: continueLabel,
                      onPressed: onContinue,
                    ),
                  ],
                ),
              ),
              Positioned(
                left: -4.w,
                right: -6.w,
                bottom: 0,
                height: 34.h,
                child: Stack(
                  children: [
                    Positioned(
                      left: 128.w,
                      bottom: 8.h,
                      child: Container(
                        width: 144.w,
                        height: 5.h,
                        decoration: BoxDecoration(
                          color: MyColors.onboardingHomeIndicator,
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.activeIndex});

  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    Widget buildDot() {
      return Container(
        width: 8.w,
        height: 8.w,
        decoration: const BoxDecoration(
          color: MyColors.onboardingDot,
          shape: BoxShape.circle,
        ),
      );
    }

    Widget buildActive() {
      return Container(
        width: 36.w,
        height: 8.h,
        decoration: BoxDecoration(
          gradient: MyColors.onboardingIndicatorGradient,
          borderRadius: BorderRadius.circular(5.r),
        ),
      );
    }

    final items = <Widget>[
      activeIndex == 0 ? buildActive() : buildDot(),
      SizedBox(width: 4.w),
      activeIndex == 1 ? buildActive() : buildDot(),
      SizedBox(width: 4.w),
      activeIndex == 2 ? buildActive() : buildDot(),
    ];

    return Row(mainAxisSize: MainAxisSize.min, children: items);
  }
}

class _ContinueButton extends StatelessWidget {
  const _ContinueButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 44.h,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: MyColors.onboardingButtonGradient,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10.r),
            onTap: onPressed,
            child: Center(
              child: Text(
                label,
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
      ),
    );
  }
}
