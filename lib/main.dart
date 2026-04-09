import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:slim30/Core/Config/app_config.dart';
import 'package:slim30/Core/Config/firebase_options.dart';
import 'package:slim30/Core/Routes/app_routes.dart';
import 'package:slim30/Core/Storage/auth_token_store.dart';
import 'package:slim30/Core/Theme/my_colors.dart';
import 'package:slim30/Riverpod/Providers/all_providers.dart';
import 'package:slim30/l10n/generated/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await _initRevenueCat();
  _initOneSignal();
  await AuthTokenStore.init();
  runApp(const ProviderScope(child: Slim30App()));
}

Future<void> _initRevenueCat() async {
  try {
    await Purchases.setLogLevel(kDebugMode ? LogLevel.debug : LogLevel.warn);
    final config = PurchasesConfiguration(
      defaultTargetPlatform == TargetPlatform.iOS
          ? AppConfig.revenueCatIosApiKey
          : AppConfig.revenueCatAndroidApiKey,
    );
    await Purchases.configure(config);
  } catch (error) {
    debugPrint('RevenueCat initialization failed: $error');
  }
}

void _initOneSignal() {
  OneSignal.initialize(AppConfig.oneSignalAppId);
}

class Slim30App extends ConsumerWidget {
  const Slim30App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);

    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppConfig.appName,
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes,
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        theme: ThemeData(
          scaffoldBackgroundColor: MyColors.scaffoldBackground,
          colorScheme: ColorScheme.fromSeed(seedColor: MyColors.primary),
          textTheme: GoogleFonts.leagueSpartanTextTheme(),
        ),
      ),
    );
  }
}
