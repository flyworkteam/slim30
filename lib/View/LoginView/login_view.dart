import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slim30/Core/Auth/auth_service.dart';
import 'package:slim30/Core/Routes/app_routes.dart';
import 'package:slim30/Core/Theme/my_colors.dart';
import 'package:slim30/Riverpod/Providers/backend_providers.dart';
import 'package:slim30/Riverpod/Providers/workout/workout_program_provider.dart';
import 'package:slim30/l10n/generated/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  bool _isLoading = false;

  void _invalidateSessionBoundProviders() {
    ref.invalidate(userProfileProvider);
    ref.invalidate(premiumStatusProvider);
    ref.invalidate(notificationSettingsProvider);
    ref.invalidate(notificationsProvider);
    ref.invalidate(progressSummaryProvider);
    ref.invalidate(homeDashboardProvider);
    ref.invalidate(workoutProgramProvider);
    ref.invalidate(workoutProgramUiProvider);
    ref.invalidate(completedProgressDaysProvider);
    ref.invalidate(onboardingAnswersProvider);
  }

  Future<void> _handleGoogleLogin() async {
    if (_isLoading) {
      return;
    }

    setState(() => _isLoading = true);
    try {
      await AuthService.signInWithGoogleAndExchange();
      final onboardingStatus = await AuthService.getOnboardingStatus();
      _invalidateSessionBoundProviders();
      if (!mounted) {
        return;
      }
      Navigator.of(context).pushNamedAndRemoveUntil(
        onboardingStatus == OnboardingStatus.completed
            ? AppRoutes.home
            : AppRoutes.questionGender,
        (_) => false,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text(mapAuthError(error))));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleAppleLogin() async {
    if (_isLoading) {
      return;
    }

    setState(() => _isLoading = true);
    try {
      await AuthService.signInWithAppleAndExchange();
      final onboardingStatus = await AuthService.getOnboardingStatus();
      _invalidateSessionBoundProviders();
      if (!mounted) {
        return;
      }
      Navigator.of(context).pushNamedAndRemoveUntil(
        onboardingStatus == OnboardingStatus.completed
            ? AppRoutes.home
            : AppRoutes.questionGender,
        (_) => false,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text(mapAuthError(error))));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleGuestLogin() async {
    if (_isLoading) {
      return;
    }

    setState(() => _isLoading = true);
    try {
      await AuthService.signInAsGuest();
      _invalidateSessionBoundProviders();
      if (!mounted) {
        return;
      }
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRoutes.questionGender, (_) => false);
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text(mapAuthError(error))));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
              // ── Photo grid ──────────────────────────────────────
              // top_left:  left:5,   top:0
              _GridPhoto(path: 'assets/images/top_left.jpg', left: 5.w, top: 0),
              // top_right: left:259, top:0
              _GridPhoto(
                path: 'assets/images/top_right.jpg',
                left: 259.w,
                top: 0,
              ),
              // top_center (middle column, slightly lower): left:132, top:16
              _GridPhoto(
                path: 'assets/images/top_center.jpg',
                left: 132.w,
                top: 16.h,
              ),
              // bottom_left:   left:5,   top:181
              _GridPhoto(
                path: 'assets/images/bottom_left.jpg',
                left: 5.w,
                top: 181.h,
              ),
              // bottom_center: left:132, top:197
              _GridPhoto(
                path: 'assets/images/bottom_center.jpg',
                left: 132.w,
                top: 197.h,
              ),
              // bottom_right:  left:264, top:181
              _GridPhoto(
                path: 'assets/images/bottom_right.jpg',
                left: 264.w,
                top: 181.h,
              ),

              // ── Blue-white overlay on photos (opacity 0.38) ─────
              Positioned(
                left: -8.w,
                top: -2,
                width: 398.w,
                height: 398.h,
                child: Opacity(
                  opacity: 0.38,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      gradient: MyColors.loginPhotoOverlay,
                    ),
                  ),
                ),
              ),

              // ── White blur fade at bottom of photo area ──────────
              Positioned(
                left: -8.w,
                top: 321.h,
                width: 398.w,
                height: 75.h,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.87),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.87),
                        blurRadius: 6.3,
                        spreadRadius: 6,
                      ),
                    ],
                  ),
                ),
              ),

              // ── Content block (top:435) ──────────────────────────
              Positioned(
                left: 0,
                right: 0,
                top: 435.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Title
                    SizedBox(
                      width: 305.w,
                      child: Text(
                        l10n.loginTitle,
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700,
                          height: 22 / 24,
                          letterSpacing: 0.24,
                          color: MyColors.loginText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    // Subtitle
                    SizedBox(
                      width: 305.w,
                      child: Text(
                        l10n.loginSubtitle,
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          height: 14 / 12,
                          color: MyColors.loginSubtext,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 15.h),
                    // Buttons: iOS → Apple first; Android → Google first
                    ...() {
                      final isAndroid =
                          Theme.of(context).platform == TargetPlatform.android;
                      final apple = _SocialButton(
                        iconPath: 'assets/images/icons/icon_apple.svg',
                        label: l10n.loginApple,
                        isLoading: _isLoading,
                        onPressed: _handleAppleLogin,
                      );
                      final google = _SocialButton(
                        iconPath: 'assets/images/icons/icon_google.svg',
                        label: l10n.loginGoogle,
                        isLoading: _isLoading,
                        onPressed: _handleGoogleLogin,
                      );
                      if (isAndroid) {
                        return [google];
                      }

                      return [apple, SizedBox(height: 12.h), google];
                    }(),
                    SizedBox(height: 15.h),
                    // Guest row
                    GestureDetector(
                      onTap: _isLoading ? null : _handleGuestLogin,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/images/icons/icon_guest.svg',
                            width: 16.w,
                            height: 16.h,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            l10n.loginGuest,
                            style: GoogleFonts.leagueSpartan(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              height: 13 / 14,
                              color: MyColors.loginSubtext,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15.h),
                    // Legal text + links
                    _LegalSection(),
                  ],
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
                        color: MyColors.loginText,
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

// ── Legal section ─────────────────────────────────────────────────────────────

class _LegalSection extends StatelessWidget {
  static const _termsUrl = 'https://fly-work.com/slim30/terms/';
  static const _privacyUrl = 'https://fly-work.com/slim30/privacy-policy/';
  static const _cookiesUrl = 'https://fly-work.com/slim30/cookies/';
  static const _termsToken = '__TERMS__';
  static const _privacyToken = '__PRIVACY__';
  static const _cookiesToken = '__COOKIES__';

  static Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  static List<InlineSpan> _buildInlineSpans({
    required String template,
    required TextStyle baseStyle,
    required TextStyle linkStyle,
    required Map<String, ({String label, String url})> links,
  }) {
    final spans = <InlineSpan>[];
    var cursor = 0;

    while (cursor < template.length) {
      String? nearestToken;
      var nearestIndex = -1;

      for (final token in links.keys) {
        final index = template.indexOf(token, cursor);
        if (index == -1) {
          continue;
        }
        if (nearestIndex == -1 || index < nearestIndex) {
          nearestIndex = index;
          nearestToken = token;
        }
      }

      if (nearestToken == null || nearestIndex == -1) {
        spans.add(TextSpan(text: template.substring(cursor), style: baseStyle));
        break;
      }

      if (nearestIndex > cursor) {
        spans.add(
          TextSpan(
            text: template.substring(cursor, nearestIndex),
            style: baseStyle,
          ),
        );
      }

      final link = links[nearestToken]!;
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.baseline,
          baseline: TextBaseline.alphabetic,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _open(link.url),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 2.h),
              child: Text(link.label, style: linkStyle),
            ),
          ),
        ),
      );

      cursor = nearestIndex + nearestToken.length;
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final baseStyle = GoogleFonts.leagueSpartan(
      fontSize: 10.sp,
      fontWeight: FontWeight.w500,
      height: 11 / 10,
      color: MyColors.loginSubtext,
    );
    final linkStyle = baseStyle.copyWith(
      decoration: TextDecoration.underline,
      color: MyColors.loginText,
    );

    final template = l10n.loginLegal
        .replaceFirst(l10n.loginLegalTermsLabel, _termsToken)
        .replaceFirst(l10n.loginLegalPrivacyLabel, _privacyToken)
        .replaceFirst(l10n.loginLegalCookiesLabel, _cookiesToken);

    final links = <String, ({String label, String url})>{
      _termsToken: (label: l10n.loginLegalTermsLabel, url: _termsUrl),
      _privacyToken: (label: l10n.loginLegalPrivacyLabel, url: _privacyUrl),
      _cookiesToken: (label: l10n.loginLegalCookiesLabel, url: _cookiesUrl),
    };

    return SizedBox(
      width: 298.w,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: baseStyle,
          children: _buildInlineSpans(
            template: template,
            baseStyle: baseStyle,
            linkStyle: linkStyle,
            links: links,
          ),
        ),
      ),
    );
  }
}

// ── Photo tile ────────────────────────────────────────────────────────────────

class _GridPhoto extends StatelessWidget {
  const _GridPhoto({required this.path, required this.left, required this.top});

  final String path;
  final double left;
  final double top;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      width: 121.w,
      height: 163.h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: Image.asset(path, fit: BoxFit.cover),
      ),
    );
  }
}

// ── Social button ─────────────────────────────────────────────────────────────

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.iconPath,
    required this.label,
    required this.isLoading,
    required this.onPressed,
  });

  final String iconPath;
  final String label;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 298.w,
      height: 44.h,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: MyColors.loginBorder, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          backgroundColor: Colors.white,
          padding: EdgeInsets.zero,
        ),
        child: isLoading
            ? SizedBox(
                width: 18.w,
                height: 18.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: MyColors.loginText,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(iconPath, width: 28.w, height: 28.h),
                  SizedBox(width: 5.w),
                  Text(
                    label,
                    style: GoogleFonts.leagueSpartan(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      height: 13 / 14,
                      color: MyColors.loginText,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
