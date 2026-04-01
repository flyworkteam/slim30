import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slim30/l10n/generated/app_localizations.dart';

class FaqView extends StatefulWidget {
  const FaqView({super.key});

  @override
  State<FaqView> createState() => _FaqViewState();
}

class _FaqViewState extends State<FaqView> {
  int _openIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final faqs = <_FaqItem>[
      _FaqItem(question: l10n.faqQuestion1, answer: l10n.faqAnswer1),
      _FaqItem(question: l10n.faqQuestion2, answer: l10n.faqAnswer2),
      _FaqItem(question: l10n.faqQuestion3, answer: l10n.faqAnswer3),
      _FaqItem(question: l10n.faqQuestion4, answer: l10n.faqAnswer4),
      _FaqItem(question: l10n.faqQuestion5, answer: l10n.faqAnswer5),
      _FaqItem(question: l10n.faqQuestion6, answer: l10n.faqAnswer6),
      _FaqItem(question: l10n.faqQuestion7, answer: l10n.faqAnswer7),
      _FaqItem(question: l10n.faqQuestion8, answer: l10n.faqAnswer8),
      _FaqItem(question: l10n.faqQuestion9, answer: l10n.faqAnswer9),
    ];

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
                  padding: EdgeInsets.fromLTRB(18.w, 40.h, 18.w, 34.h),
                  child: Column(
                    children: [
                      _Header(title: l10n.profileFaq),
                      SizedBox(height: 37.h),
                      Expanded(
                        child: ListView.separated(
                          itemCount: faqs.length,
                          separatorBuilder: (_, __) => SizedBox(height: 15.h),
                          itemBuilder: (context, index) {
                            final isOpen = _openIndex == index;
                            final item = faqs[index];
                            return _FaqCard(
                              question: item.question,
                              answer: item.answer,
                              expanded: isOpen,
                              onTap: () {
                                setState(() {
                                  _openIndex = isOpen ? -1 : index;
                                });
                              },
                            );
                          },
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

class _FaqCard extends StatelessWidget {
  const _FaqCard({
    required this.question,
    required this.answer,
    required this.expanded,
    required this.onTap,
  });

  final String question;
  final String answer;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 348.w,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border(
            bottom: BorderSide(
              color: expanded
                  ? const Color(0xFF32EA6E)
                  : const Color(0xFFEFEFEF),
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    question,
                    style: GoogleFonts.leagueSpartan(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      height: 22 / 16,
                      letterSpacing: -0.17,
                      color: const Color.fromRGBO(0, 0, 0, 0.8),
                    ),
                  ),
                ),
                SizedBox(width: 14.w),
                Icon(
                  expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  size: 24.w,
                  color: Colors.black,
                ),
              ],
            ),
            if (expanded) ...[
              SizedBox(height: 10.h),
              Text(
                answer,
                style: GoogleFonts.leagueSpartan(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  height: 11 / 12,
                  letterSpacing: -0.13,
                  color: const Color.fromRGBO(31, 31, 31, 0.8),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FaqItem {
  const _FaqItem({required this.question, required this.answer});

  final String question;
  final String answer;
}
