import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slim30/Core/Theme/my_colors.dart';
import 'package:slim30/l10n/generated/app_localizations.dart';

class QuestionBottomActions extends StatelessWidget {
  const QuestionBottomActions({
    required this.onBack,
    required this.onNext,
    super.key,
  });

  final VoidCallback onBack;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        _QuestionNavButton(
          label: l10n.questionBack,
          isPrimary: false,
          iconForward: false,
          onPressed: onBack,
        ),
        SizedBox(width: 12.w),
        _QuestionNavButton(
          label: l10n.questionNext,
          isPrimary: true,
          iconForward: true,
          onPressed: onNext,
        ),
      ],
    );
  }
}

class _QuestionNavButton extends StatelessWidget {
  const _QuestionNavButton({
    required this.label,
    required this.isPrimary,
    required this.iconForward,
    required this.onPressed,
  });

  final String label;
  final bool isPrimary;
  final bool iconForward;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final arrow = Icon(
      iconForward ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
      size: 14.sp,
      color: Colors.black,
    );

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: iconForward
          ? [Text(label, style: _labelStyle()), SizedBox(width: 5.w), arrow]
          : [arrow, SizedBox(width: 5.w), Text(label, style: _labelStyle())],
    );

    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
        child: Opacity(
          opacity: onPressed == null ? 0.55 : 1,
          child: Container(
            height: 44.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.r),
              gradient: isPrimary ? MyColors.onboardingButtonGradient : null,
              color: isPrimary ? null : const Color(0xFFEFEFEF),
            ),
            child: Center(child: content),
          ),
        ),
      ),
    );
  }

  TextStyle _labelStyle() => GoogleFonts.leagueSpartan(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    height: 15 / 16,
    letterSpacing: -0.176,
    color: Colors.black,
  );
}
