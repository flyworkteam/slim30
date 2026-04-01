import 'package:flutter/material.dart';

class MyColors {
  static const Color primary = Color(0xFF20C729);
  static const Color scaffoldBackground = Color(0xFFFFFFFF);
  static const Color splashCardStart = Color(0xFF20C729);
  static const Color splashCardEnd = Color(0xFF063527);
  static const Color splashBorder = Color.fromRGBO(242, 242, 242, 0.43);
  static const Color splashText = Color(0xFF000000);

  static const Color onboardingHeadline = Color(0xFF0D0D0D);
  static const Color onboardingBody = Color.fromRGBO(0, 0, 0, 0.8);
  static const Color onboardingDot = Color(0xFFD9D9D9);
  static const Color onboardingIndicatorStart = Color(0xFF66F393);
  static const Color onboardingIndicatorMid = Color(0xFF88F3CF);
  static const Color onboardingIndicatorEnd = Color(0xFFA3F3FF);
  static const Color onboardingButtonStart = Color(0xFF62DCF4);
  static const Color onboardingButtonMid = Color(0xFF64E6C4);
  static const Color onboardingButtonEnd = Color(0xFF66F393);
  static const Color onboardingHomeIndicator = Color(0xFF0D0D0D);

  static const LinearGradient onboardingImageOverlay = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromRGBO(0, 0, 0, 0.2),
      Color.fromRGBO(255, 255, 255, 0.024),
    ],
  );

  static const LinearGradient onboardingImageFade = LinearGradient(
    begin: Alignment(-0.1, -1.0),
    end: Alignment(0.1, 1.0),
    colors: [
      Color.fromRGBO(106, 50, 53, 0),
      Color.fromRGBO(255, 222, 222, 0.49),
    ],
  );

  static const LinearGradient onboardingIndicatorGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      onboardingIndicatorStart,
      onboardingIndicatorMid,
      onboardingIndicatorEnd,
    ],
  );

  static const LinearGradient onboardingButtonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      onboardingButtonStart,
      onboardingButtonMid,
      onboardingButtonEnd,
    ],
    stops: [0.0, 0.5843, 1.0],
  );

  // Login
  static const Color loginText = Color(0xFF0D0D0D);
  static const Color loginSubtext = Color(0xFF4E4949);
  static const Color loginBorder = Color(0xFF000000);

  static const LinearGradient loginPhotoOverlay = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromRGBO(214, 248, 255, 0.74),
      Color(0xFFFFFFFF),
    ],
  );
}
