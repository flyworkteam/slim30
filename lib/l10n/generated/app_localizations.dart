import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
    Locale('ru'),
    Locale('tr'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Slim30'**
  String get appTitle;

  /// No description provided for @splashBrand.
  ///
  /// In en, this message translates to:
  /// **'Slim30'**
  String get splashBrand;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get onboardingContinue;

  /// No description provided for @onboardingPage1Title.
  ///
  /// In en, this message translates to:
  /// **'A Lighter You in 30 Days'**
  String get onboardingPage1Title;

  /// No description provided for @onboardingPage1Description.
  ///
  /// In en, this message translates to:
  /// **'Losing weight does not have to be complicated. Take a big step toward change with daily mini tasks and just a little time.'**
  String get onboardingPage1Description;

  /// No description provided for @onboardingPage2Title.
  ///
  /// In en, this message translates to:
  /// **'A Smart Plan Just for You'**
  String get onboardingPage2Title;

  /// No description provided for @onboardingPage2Description.
  ///
  /// In en, this message translates to:
  /// **'AI analyzes your goals, age, and level, then creates a personal exercise and lifestyle plan for your needs. You do not need to think about what to do, just follow it.'**
  String get onboardingPage2Description;

  /// No description provided for @onboardingStart.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingStart;

  /// No description provided for @onboardingPage3Title.
  ///
  /// In en, this message translates to:
  /// **'One Step Closer Every Day'**
  String get onboardingPage3Title;

  /// No description provided for @onboardingPage3Description.
  ///
  /// In en, this message translates to:
  /// **'Burn fat, boost your metabolism, and stay motivated with short, effective workouts. In 30 days, you will see the difference in the mirror.'**
  String get onboardingPage3Description;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Slim30'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Good to see you. Sign in to pick up right where you left off.'**
  String get loginSubtitle;

  /// No description provided for @loginApple.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Apple'**
  String get loginApple;

  /// No description provided for @loginGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get loginGoogle;

  /// No description provided for @loginGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get loginGuest;

  /// No description provided for @loginLegal.
  ///
  /// In en, this message translates to:
  /// **'By signing up for Slim30 you agree to our Terms of Service. To learn more about how we handle your data, please review our Privacy Policy and Cookie Policy.'**
  String get loginLegal;

  /// No description provided for @questionSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get questionSkip;

  /// No description provided for @questionBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get questionBack;

  /// No description provided for @questionNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get questionNext;

  /// No description provided for @questionGenderTitle.
  ///
  /// In en, this message translates to:
  /// **'What Is Your Gender?'**
  String get questionGenderTitle;

  /// No description provided for @questionAgeTitle.
  ///
  /// In en, this message translates to:
  /// **'What Is Your Age?'**
  String get questionAgeTitle;

  /// No description provided for @questionGenderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get questionGenderFemale;

  /// No description provided for @questionGenderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get questionGenderMale;

  /// No description provided for @questionGenderUnspecified.
  ///
  /// In en, this message translates to:
  /// **'Prefer Not to Say'**
  String get questionGenderUnspecified;

  /// No description provided for @questionHeightTitle.
  ///
  /// In en, this message translates to:
  /// **'What Is Your Height?'**
  String get questionHeightTitle;

  /// No description provided for @questionWeightTitle.
  ///
  /// In en, this message translates to:
  /// **'What Is Your Current Weight?'**
  String get questionWeightTitle;

  /// No description provided for @questionTargetWeightTitle.
  ///
  /// In en, this message translates to:
  /// **'What Is Your Target Weight?'**
  String get questionTargetWeightTitle;

  /// No description provided for @motivationTitle.
  ///
  /// In en, this message translates to:
  /// **'This Is Not Just Weight. It\'s a Decision.'**
  String get motivationTitle;

  /// No description provided for @motivationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The decision you make today will be reflected in tomorrow\'s mirror.'**
  String get motivationSubtitle;

  /// No description provided for @motivationCaption.
  ///
  /// In en, this message translates to:
  /// **'Stay disciplined, trust the process. 🤗'**
  String get motivationCaption;

  /// No description provided for @questionWorkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Preferred Workout Type'**
  String get questionWorkoutTitle;

  /// No description provided for @questionWorkoutCardio.
  ///
  /// In en, this message translates to:
  /// **'Cardio'**
  String get questionWorkoutCardio;

  /// No description provided for @questionWorkoutPilates.
  ///
  /// In en, this message translates to:
  /// **'Pilates'**
  String get questionWorkoutPilates;

  /// No description provided for @questionWorkoutRunning.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get questionWorkoutRunning;

  /// No description provided for @questionWorkoutStretching.
  ///
  /// In en, this message translates to:
  /// **'Stretching & Mobility'**
  String get questionWorkoutStretching;

  /// No description provided for @questionWorkoutHiit.
  ///
  /// In en, this message translates to:
  /// **'HIIT'**
  String get questionWorkoutHiit;

  /// No description provided for @questionWorkoutWeight.
  ///
  /// In en, this message translates to:
  /// **'Weights'**
  String get questionWorkoutWeight;

  /// No description provided for @questionActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'What Is Your Activity Level?'**
  String get questionActivityTitle;

  /// No description provided for @questionActivitySedentary.
  ///
  /// In en, this message translates to:
  /// **'Sedentary'**
  String get questionActivitySedentary;

  /// No description provided for @questionActivityLight.
  ///
  /// In en, this message translates to:
  /// **'Lightly Active'**
  String get questionActivityLight;

  /// No description provided for @questionActivityModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get questionActivityModerate;

  /// No description provided for @questionActivityIntense.
  ///
  /// In en, this message translates to:
  /// **'Intense'**
  String get questionActivityIntense;

  /// No description provided for @questionBodyShapeTitle.
  ///
  /// In en, this message translates to:
  /// **'What Is Your Current Body Shape?'**
  String get questionBodyShapeTitle;

  /// No description provided for @questionBodyShapeSlim.
  ///
  /// In en, this message translates to:
  /// **'Slim / Fit'**
  String get questionBodyShapeSlim;

  /// No description provided for @questionBodyShapeOverweight.
  ///
  /// In en, this message translates to:
  /// **'Slightly Overweight'**
  String get questionBodyShapeOverweight;

  /// No description provided for @questionBodyShapeCurvy.
  ///
  /// In en, this message translates to:
  /// **'Curvy / Toned'**
  String get questionBodyShapeCurvy;

  /// No description provided for @questionBodyShapeMuscular.
  ///
  /// In en, this message translates to:
  /// **'Muscular / Strong'**
  String get questionBodyShapeMuscular;

  /// No description provided for @questionDesiredBodyShapeTitle.
  ///
  /// In en, this message translates to:
  /// **'What Is Your Desired Body Shape?'**
  String get questionDesiredBodyShapeTitle;

  /// No description provided for @questionWorkoutDaysTitle.
  ///
  /// In en, this message translates to:
  /// **'Which Days Do You Work Out?'**
  String get questionWorkoutDaysTitle;

  /// No description provided for @questionDayMon.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get questionDayMon;

  /// No description provided for @questionDayTue.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get questionDayTue;

  /// No description provided for @questionDayWed.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get questionDayWed;

  /// No description provided for @questionDayThu.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get questionDayThu;

  /// No description provided for @questionDayFri.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get questionDayFri;

  /// No description provided for @questionDaySat.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get questionDaySat;

  /// No description provided for @questionDaySun.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get questionDaySun;

  /// No description provided for @questionWorkoutDurationTitle.
  ///
  /// In en, this message translates to:
  /// **'How Long Is Your Workout?'**
  String get questionWorkoutDurationTitle;

  /// No description provided for @questionDuration1_2h.
  ///
  /// In en, this message translates to:
  /// **'1-2 hours'**
  String get questionDuration1_2h;

  /// No description provided for @questionDuration2_3h.
  ///
  /// In en, this message translates to:
  /// **'2-3 hours'**
  String get questionDuration2_3h;

  /// No description provided for @questionDuration3_4h.
  ///
  /// In en, this message translates to:
  /// **'3-4 hours'**
  String get questionDuration3_4h;

  /// No description provided for @questionDuration30m.
  ///
  /// In en, this message translates to:
  /// **'30 min'**
  String get questionDuration30m;

  /// No description provided for @questionDuration25m.
  ///
  /// In en, this message translates to:
  /// **'25 min'**
  String get questionDuration25m;

  /// No description provided for @questionDuration15m.
  ///
  /// In en, this message translates to:
  /// **'15 min'**
  String get questionDuration15m;

  /// No description provided for @questionDuration10m.
  ///
  /// In en, this message translates to:
  /// **'10 min'**
  String get questionDuration10m;

  /// No description provided for @questionGoalSpeedTitle.
  ///
  /// In en, this message translates to:
  /// **'How Fast Do You Want to Reach Your Goal?'**
  String get questionGoalSpeedTitle;

  /// No description provided for @questionGoalSpeedSlow.
  ///
  /// In en, this message translates to:
  /// **'Slow / Steady'**
  String get questionGoalSpeedSlow;

  /// No description provided for @questionGoalSpeedMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium Pace'**
  String get questionGoalSpeedMedium;

  /// No description provided for @questionGoalSpeedFast.
  ///
  /// In en, this message translates to:
  /// **'Fast'**
  String get questionGoalSpeedFast;

  /// No description provided for @questionGoalSpeedVeryFast.
  ///
  /// In en, this message translates to:
  /// **'Very Fast'**
  String get questionGoalSpeedVeryFast;

  /// No description provided for @readyTitle.
  ///
  /// In en, this message translates to:
  /// **'It\'s Almost Time to Move…'**
  String get readyTitle;

  /// No description provided for @readySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ready to break a sweat?'**
  String get readySubtitle;

  /// No description provided for @readyButton.
  ///
  /// In en, this message translates to:
  /// **'I\'m Ready'**
  String get readyButton;

  /// No description provided for @loadingTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Personal Workouts Are Being Prepared'**
  String get loadingTitle;

  /// No description provided for @loadingStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get loadingStart;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hi Evrim'**
  String get homeGreeting;

  /// No description provided for @homeWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Slim30'**
  String get homeWelcome;

  /// No description provided for @homePremium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get homePremium;

  /// No description provided for @homeDayMonShort.
  ///
  /// In en, this message translates to:
  /// **'M'**
  String get homeDayMonShort;

  /// No description provided for @homeDayTueShort.
  ///
  /// In en, this message translates to:
  /// **'T'**
  String get homeDayTueShort;

  /// No description provided for @homeDayWedShort.
  ///
  /// In en, this message translates to:
  /// **'W'**
  String get homeDayWedShort;

  /// No description provided for @homeDayThuShort.
  ///
  /// In en, this message translates to:
  /// **'T'**
  String get homeDayThuShort;

  /// No description provided for @homeDayFriShort.
  ///
  /// In en, this message translates to:
  /// **'F'**
  String get homeDayFriShort;

  /// No description provided for @homeDaySatShort.
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get homeDaySatShort;

  /// No description provided for @homeDaySunShort.
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get homeDaySunShort;

  /// No description provided for @homeTodayWorkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Workout of the Day: Fat Burn Activation'**
  String get homeTodayWorkoutTitle;

  /// No description provided for @homeWorkoutMoves.
  ///
  /// In en, this message translates to:
  /// **'8 Moves'**
  String get homeWorkoutMoves;

  /// No description provided for @homeWorkoutCalories.
  ///
  /// In en, this message translates to:
  /// **'100 Kcal'**
  String get homeWorkoutCalories;

  /// No description provided for @homeWorkoutDuration.
  ///
  /// In en, this message translates to:
  /// **'30 Min'**
  String get homeWorkoutDuration;

  /// No description provided for @homeStartNow.
  ///
  /// In en, this message translates to:
  /// **'Start Now'**
  String get homeStartNow;

  /// No description provided for @homeCompletedDaysTitle.
  ///
  /// In en, this message translates to:
  /// **'Completed Days'**
  String get homeCompletedDaysTitle;

  /// No description provided for @homeKeepGoing.
  ///
  /// In en, this message translates to:
  /// **'You\'re doing great, keep it up ✨'**
  String get homeKeepGoing;

  /// No description provided for @homeProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Progress'**
  String get homeProgressTitle;

  /// No description provided for @homeCaloriesBurned.
  ///
  /// In en, this message translates to:
  /// **'Calories Burned'**
  String get homeCaloriesBurned;

  /// No description provided for @homeHydrationRate.
  ///
  /// In en, this message translates to:
  /// **'Hydration Rate'**
  String get homeHydrationRate;

  /// No description provided for @homeWeightLost.
  ///
  /// In en, this message translates to:
  /// **'Weight Lost'**
  String get homeWeightLost;

  /// No description provided for @homeStreaks.
  ///
  /// In en, this message translates to:
  /// **'Streaks'**
  String get homeStreaks;

  /// No description provided for @homeTotalCompleted.
  ///
  /// In en, this message translates to:
  /// **'Total Completed'**
  String get homeTotalCompleted;

  /// No description provided for @homeSuccessRate.
  ///
  /// In en, this message translates to:
  /// **'Success Rate'**
  String get homeSuccessRate;

  /// No description provided for @homeAmazing.
  ///
  /// In en, this message translates to:
  /// **'Amazing 💪🏻'**
  String get homeAmazing;

  /// No description provided for @homeDontBreakChain.
  ///
  /// In en, this message translates to:
  /// **'Don\'t Break the Chain 💥'**
  String get homeDontBreakChain;

  /// No description provided for @homeContinueTitle.
  ///
  /// In en, this message translates to:
  /// **'Continue Where You Left Off'**
  String get homeContinueTitle;

  /// No description provided for @homeWorkoutTag.
  ///
  /// In en, this message translates to:
  /// **'Fat Burn Activation'**
  String get homeWorkoutTag;

  /// No description provided for @homeCurrentExercise.
  ///
  /// In en, this message translates to:
  /// **'Modified Push-Up'**
  String get homeCurrentExercise;

  /// No description provided for @homeSetsAndTime.
  ///
  /// In en, this message translates to:
  /// **'3 sets x 40 sec'**
  String get homeSetsAndTime;

  /// No description provided for @homeRestBetweenSets.
  ///
  /// In en, this message translates to:
  /// **'Rest: 30 sec'**
  String get homeRestBetweenSets;

  /// No description provided for @homeContinueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get homeContinueButton;

  /// No description provided for @homeMoodTitle.
  ///
  /// In en, this message translates to:
  /// **'Day 9: How Does Your Body Feel?'**
  String get homeMoodTitle;

  /// No description provided for @homeMoodTired.
  ///
  /// In en, this message translates to:
  /// **'Tired'**
  String get homeMoodTired;

  /// No description provided for @homeMoodEnergetic.
  ///
  /// In en, this message translates to:
  /// **'Energetic'**
  String get homeMoodEnergetic;

  /// No description provided for @homeMoodStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get homeMoodStrong;

  /// No description provided for @homeProgramName.
  ///
  /// In en, this message translates to:
  /// **'Full Body Metabolic'**
  String get homeProgramName;

  /// No description provided for @homeTransformationTitle.
  ///
  /// In en, this message translates to:
  /// **'Transformation Metrics'**
  String get homeTransformationTitle;

  /// No description provided for @homeMuscleGain.
  ///
  /// In en, this message translates to:
  /// **'Muscle Mass Gain'**
  String get homeMuscleGain;

  /// No description provided for @homeWaistChange.
  ///
  /// In en, this message translates to:
  /// **'Waist Change'**
  String get homeWaistChange;

  /// No description provided for @homeBodyFatChange.
  ///
  /// In en, this message translates to:
  /// **'Body Fat Change'**
  String get homeBodyFatChange;

  /// No description provided for @homeTabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTabHome;

  /// No description provided for @homeTabWorkout.
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get homeTabWorkout;

  /// No description provided for @homeTabProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get homeTabProgress;

  /// No description provided for @homeTabProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get homeTabProfile;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileDoneTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time spent'**
  String get profileDoneTimeLabel;

  /// No description provided for @profileCompletedActivityLabel.
  ///
  /// In en, this message translates to:
  /// **'Completed Activity'**
  String get profileCompletedActivityLabel;

  /// No description provided for @profileStreaksLabel.
  ///
  /// In en, this message translates to:
  /// **'My streaks'**
  String get profileStreaksLabel;

  /// No description provided for @profileAccountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get profileAccountSettings;

  /// No description provided for @profileEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profileEditProfile;

  /// No description provided for @profileNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get profileNotifications;

  /// No description provided for @profilePremium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get profilePremium;

  /// No description provided for @profileSupportOther.
  ///
  /// In en, this message translates to:
  /// **'Support & Other'**
  String get profileSupportOther;

  /// No description provided for @profileConnectHealth.
  ///
  /// In en, this message translates to:
  /// **'Connect with Health App'**
  String get profileConnectHealth;

  /// No description provided for @profileLanguagePreferences.
  ///
  /// In en, this message translates to:
  /// **'Language Preferences'**
  String get profileLanguagePreferences;

  /// No description provided for @profileFaq.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get profileFaq;

  /// No description provided for @profileRateUs.
  ///
  /// In en, this message translates to:
  /// **'Rate Us'**
  String get profileRateUs;

  /// No description provided for @profileShareApp.
  ///
  /// In en, this message translates to:
  /// **'Share the App'**
  String get profileShareApp;

  /// No description provided for @profileLogout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get profileLogout;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'it',
    'ja',
    'ko',
    'pt',
    'ru',
    'tr',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
