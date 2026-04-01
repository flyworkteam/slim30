import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slim30/Core/Routes/app_routes.dart';
import 'package:slim30/l10n/generated/app_localizations.dart';

class OnboardingReadyView extends StatelessWidget {
  const OnboardingReadyView({super.key});

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
              // ── Full-screen background image + dark overlay ───────
              Positioned.fill(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/7ac00af7d2a6e9126dfeadaee7adc881ed99509b.jpg',
                      fit: BoxFit.cover,
                      alignment: const Alignment(-0.9, 0),
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(0, 0, 0, 0.2),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Bottom gradient fade ──────────────────────────────
              Positioned(
                left: 0,
                top: 503.h,
                width: 390.w,
                height: 341.h,
                child: Opacity(
                  opacity: 0.66,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x00B7BCBC), Color(0xFF000000)],
                      ),
                    ),
                    child: const SizedBox.expand(),
                  ),
                ),
              ),

              // ── Text block ────────────────────────────────────────
              Positioned(
                left: 24.w,
                top: 615.h,
                width: 342.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.readyTitle,
                      style: GoogleFonts.leagueSpartan(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w700,
                        height: 27 / 28,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      l10n.readySubtitle,
                      style: GoogleFonts.leagueSpartan(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w500,
                        height: 27 / 24,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Ready button ──────────────────────────────────────
              Positioned(
                left: 24.w,
                top: 742.h,
                width: 342.w,
                height: 44.h,
                child: GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.loading),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        stops: [0.0, 0.5843, 1.0],
                        colors: [
                          Color(0xFF62DCF4),
                          Color(0xFF64E6C4),
                          Color(0xFF66F393),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        l10n.readyButton,
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          height: 15 / 16,
                          letterSpacing: -0.011 * 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ── Home indicator (white) ────────────────────────────
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
                        color: Colors.white,
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
