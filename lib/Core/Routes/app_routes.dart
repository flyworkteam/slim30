import 'package:flutter/material.dart';
import 'package:slim30/View/LoginView/login_view.dart';
import 'package:slim30/View/OnboardingView/onboarding_intro_view.dart';
import 'package:slim30/View/OnboardingView/onboarding_plan_view.dart';
import 'package:slim30/View/OnboardingView/onboarding_start_view.dart';
import 'package:slim30/View/QuestionView/question_age_view.dart';
import 'package:slim30/View/QuestionView/question_gender_view.dart';
import 'package:slim30/View/QuestionView/question_height_view.dart';
import 'package:slim30/View/QuestionView/question_motivation_view.dart';
import 'package:slim30/View/QuestionView/question_activity_view.dart';
import 'package:slim30/View/QuestionView/question_body_shape_view.dart';
import 'package:slim30/View/LoadingView/loading_view.dart';
import 'package:slim30/View/OnboardingView/onboarding_ready_view.dart';
import 'package:slim30/View/QuestionView/question_desired_body_shape_view.dart';
import 'package:slim30/View/QuestionView/question_goal_speed_view.dart';
import 'package:slim30/View/QuestionView/question_workout_days_view.dart';
import 'package:slim30/View/QuestionView/question_workout_duration_view.dart';
import 'package:slim30/View/QuestionView/question_workout_view.dart';
import 'package:slim30/View/QuestionView/question_target_weight_view.dart';
import 'package:slim30/View/QuestionView/question_weight_view.dart';
import 'package:slim30/View/SplashView/splash_view.dart';
import 'package:slim30/View/HomeView/home_view.dart';
import 'package:slim30/View/ProfileView/profile_view.dart';
import 'package:slim30/View/ProfileView/edit_profile_view.dart';
import 'package:slim30/View/ProfileView/language_preferences_view.dart';
import 'package:slim30/View/ProfileView/faq_view.dart';
import 'package:slim30/View/ProfileView/share_app_view.dart';
import 'package:slim30/View/ProfileView/notifications_view.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String onboardingIntro = '/onboarding-intro';
  static const String onboardingPlan = '/onboarding-plan';
  static const String onboardingStart = '/onboarding-start';
  static const String login = '/login';
  static const String questionGender = '/question-gender';
  static const String questionAge = '/question-age';
  static const String questionHeight = '/question-height';
  static const String questionWeight = '/question-weight';
  static const String questionTargetWeight = '/question-target-weight';
  static const String questionMotivation = '/question-motivation';
  static const String questionWorkout = '/question-workout';
  static const String questionActivity = '/question-activity';
  static const String questionBodyShape = '/question-body-shape';
  static const String questionDesiredBodyShape = '/question-desired-body-shape';
  static const String questionWorkoutDays = '/question-workout-days';
  static const String questionWorkoutDuration = '/question-workout-duration';
  static const String questionGoalSpeed = '/question-goal-speed';
  static const String onboardingReady = '/onboarding-ready';
  static const String loading = '/loading';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String languagePreferences = '/language-preferences';
  static const String faq = '/faq';
  static const String shareApp = '/share-app';
  static const String notifications = '/notifications';

  static final Map<String, Widget Function(BuildContext)> routes = {
    splash: (_) => const SplashView(),
    onboardingIntro: (_) => const OnboardingIntroView(),
    onboardingPlan: (_) => const OnboardingPlanView(),
    onboardingStart: (_) => const OnboardingStartView(),
    login: (_) => const LoginView(),
    questionGender: (_) => const QuestionGenderView(),
    questionAge: (_) => const QuestionAgeView(),
    questionHeight: (_) => const QuestionHeightView(),
    questionWeight: (_) => const QuestionWeightView(),
    questionTargetWeight: (_) => const QuestionTargetWeightView(),
    questionMotivation: (_) => const QuestionMotivationView(),
    questionWorkout: (_) => const QuestionWorkoutView(),
    questionActivity: (_) => const QuestionActivityView(),
    questionBodyShape: (_) => const QuestionBodyShapeView(),
    questionDesiredBodyShape: (_) => const QuestionDesiredBodyShapeView(),
    questionWorkoutDays: (_) => const QuestionWorkoutDaysView(),
    questionWorkoutDuration: (_) => const QuestionWorkoutDurationView(),
    questionGoalSpeed: (_) => const QuestionGoalSpeedView(),
    onboardingReady: (_) => const OnboardingReadyView(),
    loading: (_) => const LoadingView(),
    home: (_) => const HomeView(),
    profile: (_) => const ProfileView(),
    editProfile: (_) => const EditProfileView(),
    languagePreferences: (_) => const LanguagePreferencesView(),
    faq: (_) => const FaqView(),
    shareApp: (_) => const ShareAppView(),
    notifications: (_) => const NotificationsView(),
  };
}
