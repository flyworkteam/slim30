import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:slim30/Core/Config/app_config.dart';
import 'package:slim30/Riverpod/Providers/backend_providers.dart';
import 'package:slim30/l10n/generated/app_localizations.dart';

class PremiumView extends ConsumerStatefulWidget {
  const PremiumView({super.key});

  @override
  ConsumerState<PremiumView> createState() => _PremiumViewState();
}

class _PremiumViewState extends ConsumerState<PremiumView> {
  bool _opened = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _presentPaywall());
  }

  Future<void> _presentPaywall() async {
    if (_opened) return;
    _opened = true;

    final l10n = AppLocalizations.of(context);

    try {
      final firebaseUid = FirebaseAuth.instance.currentUser?.uid;
      if (firebaseUid != null && firebaseUid.isNotEmpty) {
        await Purchases.logIn(firebaseUid);
      }

      final result = await RevenueCatUI.presentPaywallIfNeeded(
        AppConfig.revenueCatPremiumEntitlementId,
        displayCloseButton: true,
      );

      if (!mounted) return;

      switch (result) {
        case PaywallResult.purchased:
        case PaywallResult.restored:
          ref.invalidate(premiumStatusProvider);
          ref.invalidate(homeDashboardProvider);
          break;
        case PaywallResult.error:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n?.profilePremium ?? 'Premium')),
          );
          break;
        case PaywallResult.cancelled:
        case PaywallResult.notPresented:
          break;
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Paywall error: $error')));
      }
    }

    if (mounted) {
      final nav = Navigator.of(context);
      if (nav.canPop()) {
        nav.pop();
      } else {
        nav.pushReplacementNamed('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 36.w,
                height: 36.w,
                child: const CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(height: 16.h),
              Text(AppLocalizations.of(context)?.profilePremium ?? 'Premium'),
            ],
          ),
        ),
      ),
    );
  }
}
