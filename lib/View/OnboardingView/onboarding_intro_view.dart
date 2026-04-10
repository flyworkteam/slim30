import 'dart:async';

import 'package:flutter/material.dart';
import 'package:slim30/Core/Routes/app_routes.dart';
import 'package:slim30/View/OnboardingView/widgets/onboarding_shell.dart';
import 'package:slim30/l10n/generated/app_localizations.dart';

class OnboardingIntroView extends StatefulWidget {
  const OnboardingIntroView({super.key});

  @override
  State<OnboardingIntroView> createState() => _OnboardingIntroViewState();
}

class _OnboardingIntroViewState extends State<OnboardingIntroView> {
  static const _slideDuration = Duration(seconds: 3);

  late final PageController _pageController;
  Timer? _autoSlideTimer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = Timer.periodic(_slideDuration, (_) {
      if (!mounted || !_pageController.hasClients || _currentIndex >= 2) {
        return;
      }

      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    });
  }

  void _handleContinue() {
    if (_currentIndex == 2) {
      _goToLogin();
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goToLogin() {
    _autoSlideTimer?.cancel();
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pages = [
      (
        imagePath: 'assets/images/SPLASH1.jpg',
        title: l10n.onboardingPage1Title,
        description: l10n.onboardingPage1Description,
      ),
      (
        imagePath: 'assets/images/SPLASH2.jpg',
        title: l10n.onboardingPage2Title,
        description: l10n.onboardingPage2Description,
      ),
      (
        imagePath: 'assets/images/SPLASH3.jpg',
        title: l10n.onboardingPage3Title,
        description: l10n.onboardingPage3Description,
      ),
    ];

    return PageView.builder(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() => _currentIndex = index);
        if (index >= 2) {
          _autoSlideTimer?.cancel();
        } else {
          _startAutoSlide();
        }
      },
      itemCount: pages.length,
      itemBuilder: (context, index) {
        final page = pages[index];
        return OnboardingShell(
          imagePath: page.imagePath,
          title: page.title,
          description: page.description,
          skipLabel: l10n.onboardingSkip,
          continueLabel: index == 2
              ? l10n.onboardingStart
              : l10n.onboardingContinue,
          activeIndex: index,
          showImageFade: true,
          onContinue: _handleContinue,
          onSkip: _goToLogin,
        );
      },
    );
  }
}
