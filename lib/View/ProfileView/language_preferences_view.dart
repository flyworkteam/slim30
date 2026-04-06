import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slim30/Riverpod/Providers/all_providers.dart';
import 'package:slim30/Riverpod/Providers/backend_providers.dart';
import 'package:slim30/l10n/generated/app_localizations.dart';

class LanguagePreferencesView extends ConsumerStatefulWidget {
  const LanguagePreferencesView({super.key});

  @override
  ConsumerState<LanguagePreferencesView> createState() =>
      _LanguagePreferencesViewState();
}

class _LanguagePreferencesViewState
    extends ConsumerState<LanguagePreferencesView> {
  late String _selectedLanguageCode;

  static const List<_LanguageOption> _languages = [
    _LanguageOption(code: 'en', flag: '🇺🇸', label: 'English'),
    _LanguageOption(code: 'tr', flag: '🇹🇷', label: 'Turkce'),
    _LanguageOption(code: 'es', flag: '🇪🇸', label: 'Espanol'),
    _LanguageOption(code: 'pt', flag: '🇵🇹', label: 'Portugues'),
    _LanguageOption(code: 'fr', flag: '🇫🇷', label: 'Francais'),
    _LanguageOption(code: 'it', flag: '🇮🇹', label: 'Italiano'),
    _LanguageOption(code: 'de', flag: '🇩🇪', label: 'Deutsch'),
    _LanguageOption(code: 'ru', flag: '🇷🇺', label: 'Russkiy'),
    _LanguageOption(code: 'ja', flag: '🇯🇵', label: 'Nihongo'),
    _LanguageOption(code: 'ko', flag: '🇰🇷', label: 'Hangugeo'),
    _LanguageOption(code: 'hi', flag: '🇮🇳', label: 'Hindi'),
    _LanguageOption(code: 'zh', flag: '🇨🇳', label: 'Zhongwen'),
  ];

  @override
  void initState() {
    super.initState();
    _selectedLanguageCode = ref.read(localeProvider).languageCode;
  }

  Future<void> _saveLanguage() async {
    await ref.read(localeProvider.notifier).setLocale(_selectedLanguageCode);
    await updateProfile(ref, {'language': _selectedLanguageCode});
    if (!mounted) return;
    Navigator.of(context).pop();
  }

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
                  padding: EdgeInsets.fromLTRB(24.w, 34.h, 24.w, 34.h),
                  child: Column(
                    children: [
                      _Header(title: l10n.profileLanguagePreferences),
                      SizedBox(height: 40.h),
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.separated(
                                itemCount: _languages.length,
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: 10.h),
                                itemBuilder: (context, index) {
                                  final item = _languages[index];
                                  final selected =
                                      item.code == _selectedLanguageCode;
                                  return _LanguageRow(
                                    item: item,
                                    selected: selected,
                                    onTap: () {
                                      setState(() {
                                        _selectedLanguageCode = item.code;
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 24.h),
                            _SaveButton(onTap: _saveLanguage),
                            SizedBox(height: 16.h),
                          ],
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

class _LanguageRow extends StatelessWidget {
  const _LanguageRow({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _LanguageOption item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        width: 342.w,
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: BoxDecoration(
          color: const Color(0xFFFEFEFE),
          borderRadius: BorderRadius.circular(10.r),
          border: Border(
            bottom: BorderSide(
              color: selected
                  ? const Color(0xFF32EA6E)
                  : const Color(0xFFDDDDDD),
            ),
          ),
        ),
        child: Row(
          children: [
            Text(
              item.flag,
              style: GoogleFonts.leagueSpartan(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              item.label,
              style: GoogleFonts.leagueSpartan(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                height: 1.5,
                letterSpacing: -0.15,
                color: Colors.black,
              ),
            ),
            const Spacer(),
            if (selected)
              Icon(
                Icons.check_rounded,
                size: 18.w,
                color: const Color(0xFF32EA6E),
              ),
          ],
        ),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        width: 342.w,
        height: 44.h,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFF62DCF4), Color(0xFF64E6C4), Color(0xFF66F393)],
            stops: [0.0, 0.5843, 1.0],
          ),
          borderRadius: BorderRadius.circular(10.r),
        ),
        alignment: Alignment.center,
        child: Text(
          l10n.languagePreferencesSaveButton,
          style: GoogleFonts.leagueSpartan(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            height: 1,
            letterSpacing: -0.17,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class _LanguageOption {
  const _LanguageOption({
    required this.code,
    required this.flag,
    required this.label,
  });

  final String code;
  final String flag;
  final String label;
}
