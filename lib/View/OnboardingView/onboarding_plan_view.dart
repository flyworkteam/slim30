import 'package:flutter/material.dart';
import 'package:slim30/Core/Routes/app_routes.dart';
import 'package:slim30/View/OnboardingView/widgets/onboarding_shell.dart';
import 'package:slim30/l10n/generated/app_localizations.dart';

class OnboardingPlanView extends StatelessWidget {
  const OnboardingPlanView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return OnboardingShell(
      imagePath: 'assets/images/SPLASH2.jpg',
      title: l10n.onboardingPage2Title,
      description: l10n.onboardingPage2Description,
      skipLabel: l10n.onboardingSkip,
      continueLabel: l10n.onboardingContinue,
      activeIndex: 1,
      onContinue: () {
        Navigator.pushNamed(context, AppRoutes.onboardingStart);
      },
      onSkip: () {
        Navigator.pushNamed(context, AppRoutes.login);
      },
    );
  }
}
