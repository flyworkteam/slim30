import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slim30/Core/Config/app_config.dart';
import 'package:slim30/Core/Routes/app_routes.dart';
import 'package:slim30/Core/Theme/my_colors.dart';
import 'package:slim30/Riverpod/Providers/all_providers.dart';
import 'package:slim30/l10n/generated/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: Slim30App()));
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
