import 'package:flutter/material.dart';
import 'package:slim30/Core/Routes/app_routes.dart';
import 'package:slim30/View/OnboardingView/widgets/onboarding_shell.dart';
import 'package:slim30/l10n/generated/app_localizations.dart';

class OnboardingIntroView extends StatelessWidget {
  const OnboardingIntroView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return OnboardingShell(
      imagePath: 'assets/images/SPLASH1.jpg',
      title: l10n.onboardingPage1Title,
      description: l10n.onboardingPage1Description,
      skipLabel: l10n.onboardingSkip,
      continueLabel: l10n.onboardingContinue,
      activeIndex: 0,
      showImageFade: true,
      onContinue: () {
        Navigator.pushNamed(context, AppRoutes.onboardingPlan);
      },
      onSkip: () {
        Navigator.pushNamed(context, AppRoutes.login);
      },
    );
  }
}
