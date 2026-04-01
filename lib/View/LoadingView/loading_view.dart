import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slim30/Core/Routes/app_routes.dart';
import 'package:slim30/l10n/generated/app_localizations.dart';

class LoadingView extends StatefulWidget {
  const LoadingView({super.key});

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _progress = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
              // ── Ambient glow ellipse (top-left) ──────────────────
              Positioned(
                left: -41.w,
                top: -160.h,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                  child: Container(
                    width: 488.w,
                    height: 499.h,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(-0.3, -1),
                        end: Alignment(0, 1),
                        colors: [Color(0xFFE1FBFF), Colors.white],
                        stops: [0.0048, 0.8632],
                      ),
                    ),
                  ),
                ),
              ),

              // ── Photo cluster + text ──────────────────────────────
              Positioned(
                left: 35.w,
                top: 151.h,
                child: Column(
                  children: [
                    // Photo cluster
                    SizedBox(
                      width: 314.w,
                      height: 293.h,
                      child: Stack(
                        children: [
                          // Group 286 — top-left, 87x87, #E3FCFF
                          _CirclePhoto(
                            left: 35, top: 17,
                            outerSize: 87, innerSize: 75,
                            bgColor: const Color(0xFFE3FCFF),
                            imagePath: 'assets/images/1ed975593485976355db78e2cf4d9e0e6a8936b8.jpg',
                          ),
                          // Frame 7608 — top-center, 67x67, #E1FFF8
                          _CirclePhoto(
                            left: 142, top: 0,
                            outerSize: 67, innerSize: 54,
                            bgColor: const Color(0xFFE1FFF8),
                            imagePath: 'assets/images/42ad368b2abd870bcf958844120aabdb0924a41e.png',
                          ),
                          // Group 285 — top-right, 104x104, #EDFFF5
                          _CirclePhoto(
                            left: 213, top: 40,
                            outerSize: 104, innerSize: 84,
                            bgColor: const Color(0xFFEDFFF5),
                            imagePath: 'assets/images/87bd5d4846d8036313a92142cf813f49c5bea8a0.jpg',
                          ),
                          // Group 287 — left-middle, 62x62, #EBFFF4
                          _CirclePhoto(
                            left: 3, top: 124,
                            outerSize: 62, innerSize: 54,
                            bgColor: const Color(0xFFEBFFF4),
                            imagePath: 'assets/images/305faab38359c966a69ca63aa56842d4cd4e991a.png',
                          ),
                          // Frame 7607 — center large, 134x134, #EDFDFF
                          _CirclePhoto(
                            left: 88, top: 95,
                            outerSize: 134, innerSize: 113,
                            bgColor: const Color(0xFFEDFDFF),
                            imagePath: 'assets/images/208270a9e4337f94f4d7592e873eaa7cf85d07be.jpg',
                          ),
                          // Frame 7606 — right-middle, 81x81, #E8FFF2
                          _CirclePhoto(
                            left: 213, top: 179,
                            outerSize: 81, innerSize: 64,
                            bgColor: const Color(0xFFE8FFF2),
                            imagePath: 'assets/images/0861026ede28fb3736fccea4046ce5a69675e25e.png',
                          ),
                          // Group 288 — bottom-left, 77x77, #E1FFF8
                          _CirclePhoto(
                            left: 39, top: 216,
                            outerSize: 77, innerSize: 69,
                            bgColor: const Color(0xFFE1FFF8),
                            imagePath: 'assets/images/f62810c637b67734e57a8bfb4985baec89b2e79e.jpg',
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 197.h),

                    // Text + progress bar
                    SizedBox(
                      width: 320.w,
                      child: Column(
                        children: [
                          Text(
                            l10n.loadingTitle,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.leagueSpartan(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w600,
                              height: 27 / 24,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 47.h),
                          AnimatedBuilder(
                            animation: _progress,
                            builder: (context, _) {
                              final pct = _progress.value;
                              final isDone = pct >= 0.999;
                              return GestureDetector(
                                onTap: isDone
                                    ? () => Navigator.pushNamed(
                                          context, AppRoutes.home)
                                    : null,
                                child: SizedBox(
                                  width: 320.w,
                                  height: 44.h,
                                  child: Stack(
                                    children: [
                                      // Track
                                      Container(
                                        width: 320.w,
                                        height: 44.h,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF3F3F3),
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                        ),
                                      ),
                                      // Fill
                                      Container(
                                        width: 320.w * pct,
                                        height: 44.h,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                          gradient: const LinearGradient(
                                            stops: [0.0, 0.5843, 1.0],
                                            colors: [
                                              Color(0xFF62DCF4),
                                              Color(0xFF64E6C4),
                                              Color(0xFF66F393),
                                            ],
                                          ),
                                        ),
                                      ),
                                      // Label
                                      Positioned.fill(
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            isDone
                                                ? l10n.loadingStart
                                                : '${(pct * 100).toInt()}%',
                                            style: GoogleFonts.leagueSpartan(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                              height: 27 / 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── Home indicator ────────────────────────────────────
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

// ── Circular photo widget ──────────────────────────────────────────────────────

class _CirclePhoto extends StatelessWidget {
  const _CirclePhoto({
    required this.left,
    required this.top,
    required this.outerSize,
    required this.innerSize,
    required this.bgColor,
    required this.imagePath,
  });

  final double left;
  final double top;
  final double outerSize;
  final double innerSize;
  final Color bgColor;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left.w,
      top: top.h,
      child: Container(
        width: outerSize.w,
        height: outerSize.h,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: ClipOval(
          child: Image.asset(
            imagePath,
            width: innerSize.w,
            height: innerSize.h,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stack) => Container(
              width: innerSize.w,
              height: innerSize.h,
              color: bgColor,
            ),
          ),
        ),
      ),
    );
  }
}
