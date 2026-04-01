import 'package:flutter/material.dart';
import 'package:slim30/Core/Routes/app_routes.dart';
import 'package:slim30/View/OnboardingView/widgets/onboarding_shell.dart';
import 'package:slim30/l10n/generated/app_localizations.dart';

class OnboardingStartView extends StatelessWidget {
  const OnboardingStartView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return OnboardingShell(
      imagePath: 'assets/images/SPLASH3.jpg',
      title: l10n.onboardingPage3Title,
      description: l10n.onboardingPage3Description,
      skipLabel: l10n.onboardingSkip,
      continueLabel: l10n.onboardingStart,
      activeIndex: 2,
      showImageFade: true,
      onContinue: () {
        Navigator.pushNamed(context, AppRoutes.login);
      },
      onSkip: () {
        Navigator.pushNamed(context, AppRoutes.login);
      },
    );
  }
}
