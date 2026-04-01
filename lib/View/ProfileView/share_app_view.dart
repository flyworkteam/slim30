import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:slim30/l10n/generated/app_localizations.dart';

class ShareAppView extends StatelessWidget {
  const ShareAppView({super.key});

  static const _shareLink = 'https://slim30.com';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: 390.w,
          child: SafeArea(
            bottom: false,
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 40.h, 24.w, 34.h),
                  child: Column(
                    children: [
                      _Header(title: l10n.shareAppTitle),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.only(top: 140.h),
                            child: Column(
                              children: [
                                const _SharePreviewPhotos(),
                                SizedBox(height: 14.h),
                                Text(
                                  l10n.shareAppHeroTitle,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.leagueSpartan(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                    height: 1,
                                    letterSpacing: -0.2,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 7.h),
                                Text(
                                  l10n.shareAppHeroSubtitle,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.leagueSpartan(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    height: 1,
                                    letterSpacing: -0.15,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 60.h),
                                _ShareLinkBlock(
                                  linkLabel: l10n.shareAppLinkLabel,
                                  link: _shareLink,
                                  copyButtonLabel: l10n.shareAppCopyButton,
                                  onCopy: () => _copyLink(context),
                                ),
                                SizedBox(height: 24.h),
                                _SocialShareBlock(
                                  instagramLabel: l10n.shareAppInstagram,
                                  linkedInLabel: l10n.shareAppLinkedIn,
                                  whatsAppLabel: l10n.shareAppWhatsApp,
                                  twitterLabel: l10n.shareAppTwitter,
                                  onTapInstagram: () => _shareApp(context),
                                  onTapLinkedIn: () => _shareApp(context),
                                  onTapWhatsApp: () => _shareApp(context),
                                  onTapTwitter: () => _shareApp(context),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 8.h,
                  child: Center(
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _copyLink(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    await Clipboard.setData(const ClipboardData(text: _shareLink));
    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(l10n.shareAppCopiedMessage),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  Future<void> _shareApp(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final shareText = '${l10n.shareAppShareMessage} $_shareLink';
    await Share.share(shareText);
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Semantics(
          label: l10n.questionBack,
          button: true,
          child: InkWell(
            onTap: () => Navigator.of(context).pop(),
            borderRadius: BorderRadius.circular(14.r),
            child: Container(
              width: 28.w,
              height: 28.w,
              decoration: BoxDecoration(
                color: const Color(0xFFEEEEEE),
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
        ),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: GoogleFonts.leagueSpartan(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              height: 1,
              letterSpacing: -0.2,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(width: 28.w),
      ],
    );
  }
}

class _SharePreviewPhotos extends StatelessWidget {
  const _SharePreviewPhotos();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 299.51.w,
      height: 111.52.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            top: 0.5.h,
            child: Transform.rotate(
              angle: -0.117,
              child: _PhotoCard(imagePath: 'assets/images/share_left.jpg'),
            ),
          ),
          Positioned(
            left: 99.5.w,
            top: 5.5.h,
            child: const _PhotoCard(
              imagePath: 'assets/images/share_center.jpg',
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Transform.rotate(
              angle: 0.117,
              child: _PhotoCard(imagePath: 'assets/images/share_right.jpg'),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoCard extends StatelessWidget {
  const _PhotoCard({required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 100.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.white),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(imagePath, fit: BoxFit.cover),
    );
  }
}

class _ShareLinkBlock extends StatelessWidget {
  const _ShareLinkBlock({
    required this.linkLabel,
    required this.link,
    required this.copyButtonLabel,
    required this.onCopy,
  });

  final String linkLabel;
  final String link;
  final String copyButtonLabel;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          linkLabel,
          style: GoogleFonts.leagueSpartan(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            height: 1,
            letterSpacing: -0.13,
            color: const Color(0xFF0D0D0D),
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: 342.w,
          height: 44.h,
          decoration: BoxDecoration(
            color: const Color(0xFFFEFEFE),
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(color: const Color(0xFFF3F3F3)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Text(
                    link,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.leagueSpartan(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      height: 1,
                      letterSpacing: -0.13,
                      color: const Color(0xFF4E4949),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 110.w,
                height: 44.h,
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFF62DCF4),
                        Color(0xFF64E6C4),
                        Color(0xFF66F393),
                      ],
                      stops: [0.0, 0.5843, 1.0],
                    ),
                  ),
                  child: TextButton(
                    onPressed: onCopy,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: Text(
                      copyButtonLabel,
                      style: GoogleFonts.leagueSpartan(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                        letterSpacing: -0.15,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SocialShareBlock extends StatelessWidget {
  const _SocialShareBlock({
    required this.instagramLabel,
    required this.linkedInLabel,
    required this.whatsAppLabel,
    required this.twitterLabel,
    required this.onTapInstagram,
    required this.onTapLinkedIn,
    required this.onTapWhatsApp,
    required this.onTapTwitter,
  });

  final String instagramLabel;
  final String linkedInLabel;
  final String whatsAppLabel;
  final String twitterLabel;
  final VoidCallback onTapInstagram;
  final VoidCallback onTapLinkedIn;
  final VoidCallback onTapWhatsApp;
  final VoidCallback onTapTwitter;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 342.w,
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFEFEFE),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: const Color(0xFFF3F3F3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _SocialButton(
            iconPath: 'assets/images/icons/share_icon/ri_whatsapp-fill.svg',
            label: instagramLabel,
            onTap: onTapInstagram,
          ),
          _SocialButton(
            iconPath: 'assets/images/icons/share_icon/mdi_linkedin.svg',
            label: linkedInLabel,
            onTap: onTapLinkedIn,
          ),
          _SocialButton(
            iconPath: 'assets/images/icons/share_icon/ri_whatsapp-fill (1).svg',
            label: whatsAppLabel,
            onTap: onTapWhatsApp,
          ),
          _SocialButton(
            iconPath: 'assets/images/icons/share_icon/prime_twitter.svg',
            label: twitterLabel,
            onTap: onTapTwitter,
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.iconPath,
    required this.label,
    required this.onTap,
  });

  final String iconPath;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: SizedBox(
        width: 72.w,
        child: Column(
          children: [
            Container(
              width: 40.43.w,
              height: 40.43.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.r),
                color: Colors.white,
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                iconPath,
                width: 28.64.w,
                height: 28.64.w,
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: GoogleFonts.leagueSpartan(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                height: 1,
                letterSpacing: -0.11,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
