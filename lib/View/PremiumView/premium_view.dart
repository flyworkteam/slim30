import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:slim30/Core/Config/app_config.dart';
import 'package:slim30/Core/Routes/app_routes.dart';
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

    try {
      final firebaseUid = FirebaseAuth.instance.currentUser?.uid;
      if (firebaseUid != null && firebaseUid.isNotEmpty) {
        await Purchases.logIn(firebaseUid);
      }

      final customerInfo = await Purchases.getCustomerInfo();
      final configuredEntitlement =
          customerInfo.entitlements.active[AppConfig
              .revenueCatPremiumEntitlementId] ??
          customerInfo.entitlements.all[AppConfig.revenueCatPremiumEntitlementId];
      final hasPremiumEntitlement = configuredEntitlement?.isActive ?? false;

      if (hasPremiumEntitlement) {
        ref.invalidate(premiumStatusProvider);
        ref.invalidate(homeDashboardProvider);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Your premium subscription is active.')),
          );
        }
      } else {
        final offerings = await Purchases.getOfferings();
        if (offerings.current == null) {
          debugPrint(
            'RevenueCat configuration error: no current offering for entitlement "${AppConfig.revenueCatPremiumEntitlementId}".',
          );
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Premium products are not configured yet. Please try again shortly.',
              ),
            ),
          );
        } else {
          final result = await RevenueCatUI.presentPaywall(
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
                const SnackBar(content: Text('Could not load premium offers.')),
              );
              break;
            case PaywallResult.cancelled:
            case PaywallResult.notPresented:
              break;
          }
        }
      }
    } on PlatformException catch (error) {
      if (kDebugMode) {
        debugPrint(
          'Paywall error (code: ${error.code}, message: ${error.message}, details: ${error.details})',
        );
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Premium could not be loaded right now. Please try again.',
            ),
          ),
        );
      }
    } catch (error) {
      debugPrint('Paywall error: $error');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong. Please try again.'),
          ),
        );
      }
    }

    if (mounted) {
      final nav = Navigator.of(context);
      if (nav.canPop()) {
        nav.pop();
      } else {
        nav.pushReplacementNamed(AppRoutes.home);
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
