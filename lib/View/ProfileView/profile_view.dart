import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slim30/Core/Routes/app_routes.dart';
import 'package:slim30/Riverpod/Models/app_models.dart';
import 'package:slim30/Riverpod/Providers/backend_providers.dart';
import 'package:slim30/l10n/generated/app_localizations.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  static const _profileIconBase = 'assets/images/icons/profilePage';
  static const _homeIconBase = 'assets/images/icons/homePage';

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  bool _notificationsEnabled = true;
  bool _healthEnabled = true;
  bool _settingsHydrated = false;

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider).valueOrNull;
    final summary = ref.watch(progressOverviewProvider);
    final premium = ref.watch(premiumStatusProvider).valueOrNull;
    final settings = ref.watch(notificationSettingsProvider).valueOrNull;

    if (!_settingsHydrated && settings != null) {
      _settingsHydrated = true;
      _notificationsEnabled = settings.dailyReminderEnabled;
      _healthEnabled = settings.progressSummaryEnabled;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: 390.w,
          child: Stack(
            children: [
              Positioned.fill(
                child: SafeArea(
                  bottom: false,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 90.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _TopHeader(),
                        SizedBox(height: 33.h),
                        Center(
                          child: _ProfileIdentity(name: profile?.name ?? 'User'),
                        ),
                        SizedBox(height: 30.h),
                        _StatsStrip(
                          totalDays: summary?.totalDays ?? 30,
                          completedDays: summary?.completedDays ?? 0,
                          completionRate: summary?.completionRate ?? 0,
                        ),
                        SizedBox(height: 30.h),
                        _SettingsSection(
                          notificationsEnabled: _notificationsEnabled,
                          isPremium: premium?.isPremium == true,
                          onNotificationsChanged: (value) async {
                            setState(() => _notificationsEnabled = value);
                            final source = settings ?? NotificationSettingsModel.defaults();
                            await updateNotificationSettings(
                              ref,
                              source.copyWith(dailyReminderEnabled: value),
                            );
                          },
                        ),
                        SizedBox(height: 30.h),
                        _SupportSection(
                          healthEnabled: _healthEnabled,
                          onHealthChanged: (value) async {
                            setState(() => _healthEnabled = value);
                            final source = settings ?? NotificationSettingsModel.defaults();
                            await updateNotificationSettings(
                              ref,
                              source.copyWith(progressSummaryEnabled: value),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _BottomBar(iconBase: ProfileView._homeIconBase),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopHeader extends StatelessWidget {
  const _TopHeader();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Semantics(
          label: l10n.questionBack,
          button: true,
          child: InkWell(
            onTap: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            },
            borderRadius: BorderRadius.circular(14.r),
            child: Container(
              width: 28.w,
              height: 28.w,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(14.r),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 14.w,
                color: Colors.black,
              ),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              l10n.profileTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: GoogleFonts.leagueSpartan(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                height: 1,
                color: Colors.black,
              ),
            ),
          ),
        ),
        SizedBox(width: 28.w),
      ],
    );
  }
}

class _ProfileIdentity extends StatelessWidget {
  const _ProfileIdentity({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 72.w,
          child: Column(
            children: [
              SizedBox(
                width: 70.w,
                height: 82.h,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(35.r),
                        child: Image.asset(
                          'assets/images/f62810c637b67734e57a8bfb4985baec89b2e79e.jpg',
                          width: 70.w,
                          height: 70.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 23.w,
                      top: 58.h,
                      child: Container(
                        width: 24.w,
                        height: 24.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F1F1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.edit,
                          size: 14.w,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                name,
                style: GoogleFonts.leagueSpartan(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  height: 1,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatsStrip extends StatelessWidget {
  const _StatsStrip({
    required this.totalDays,
    required this.completedDays,
    required this.completionRate,
  });

  final int totalDays;
  final int completedDays;
  final double completionRate;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _StatItem(
          iconData: Iconsax.clock,
          value: '$totalDays',
          label: l10n.profileDoneTimeLabel,
        ),
        SizedBox(width: 40.w),
        _StatItem(
          iconData: Iconsax.activity,
          value: '$completedDays',
          label: l10n.profileCompletedActivityLabel,
        ),
        SizedBox(width: 40.w),
        _StatItem(
          iconData: Iconsax.flash_1,
          value: '${completionRate.round()}%',
          label: l10n.profileStreaksLabel,
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.iconData,
    required this.value,
    required this.label,
  });

  final IconData iconData;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 52.w, maxWidth: 92.w),
      child: Column(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: const Color(0xFFF5FEFF),
              borderRadius: BorderRadius.circular(22.r),
            ),
            alignment: Alignment.center,
            child: Icon(iconData, size: 16.w, color: Colors.black),
          ),
          SizedBox(height: 6.h),
          Text(
            value,
            style: GoogleFonts.leagueSpartan(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              height: 1,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.leagueSpartan(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              height: 1,
              color: const Color(0xFF5C5C5C),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.notificationsEnabled,
    required this.onNotificationsChanged,
    required this.isPremium,
  });

  final bool notificationsEnabled;
  final ValueChanged<bool> onNotificationsChanged;
  final bool isPremium;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.profileAccountSettings,
          style: GoogleFonts.leagueSpartan(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            height: 1.5,
            letterSpacing: -0.22,
          ),
        ),
        SizedBox(height: 10.h),
        _SectionCard(
          children: [
            _SettingRow(
              iconPath: '${ProfileView._profileIconBase}/iconsax-user.svg',
              title: l10n.profileEditProfile,
              trailing: _Chevron(),
              onTap: () =>
                  Navigator.of(context).pushNamed(AppRoutes.editProfile),
            ),
            _SettingRow(
              iconPath:
                  '${ProfileView._profileIconBase}/iconsax-notification-bing.svg',
              title: l10n.profileNotifications,
              trailing: _SwitchPill(
                enabled: notificationsEnabled,
                onChanged: onNotificationsChanged,
              ),
              onTap: () => onNotificationsChanged(!notificationsEnabled),
            ),
            _SettingRow(
              iconPath: '${ProfileView._profileIconBase}/iconsax-crown-1.svg',
              title: isPremium ? '${l10n.profilePremium} (ON)' : l10n.profilePremium,
              trailing: _Chevron(),
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}

class _SupportSection extends StatelessWidget {
  const _SupportSection({
    required this.healthEnabled,
    required this.onHealthChanged,
  });

  final bool healthEnabled;
  final ValueChanged<bool> onHealthChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.profileSupportOther,
          style: GoogleFonts.leagueSpartan(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            height: 1.5,
            letterSpacing: -0.22,
          ),
        ),
        SizedBox(height: 10.h),
        _SectionCard(
          children: [
            _SettingRow(
              iconPath: '${ProfileView._profileIconBase}/iconsax-health.svg',
              title: l10n.profileConnectHealth,
              trailing: _SwitchPill(
                enabled: healthEnabled,
                onChanged: onHealthChanged,
              ),
              onTap: () => onHealthChanged(!healthEnabled),
            ),
            _SettingRow(
              iconPath: '${ProfileView._profileIconBase}/iconsax-translate.svg',
              title: l10n.profileLanguagePreferences,
              trailing: _Chevron(),
              onTap: () => Navigator.of(
                context,
              ).pushNamed(AppRoutes.languagePreferences),
            ),
            _SettingRow(
              iconPath:
                  '${ProfileView._profileIconBase}/iconsax-message-question.svg',
              title: l10n.profileFaq,
              trailing: _Chevron(),
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.faq),
            ),
            // _SettingRow(
            //   iconPath:
            //       '${ProfileView._profileIconBase}/iconsax-like-dislike.svg',
            //   title: l10n.profileRateUs,
            //   trailing: _Chevron(),
            //   onTap: () {},
            // ),
            _SettingRow(
              iconPath:
                  '${ProfileView._profileIconBase}/iconsax-export-arrow-02.svg',
              title: l10n.profileShareApp,
              trailing: _Chevron(),
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.shareApp),
            ),
            _SettingRow(
              iconPath: '${ProfileView._profileIconBase}/iconsax-logout-01.svg',
              title: l10n.profileLogout,
              titleColor: Color(0xFFE61317),
              iconBackground: Color(0xFFF7092C),
              iconColor: Colors.white,
              trailing: SizedBox.shrink(),
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 342.w,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFF3F3F3)),
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.25),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(children: _withDividers(children)),
    );
  }

  List<Widget> _withDividers(List<Widget> rows) {
    final output = <Widget>[];
    for (var i = 0; i < rows.length; i++) {
      output.add(rows[i]);
      if (i != rows.length - 1) {
        output.add(Container(height: 1, color: const Color(0xFFE2E2E2)));
      }
    }
    return output;
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.iconPath,
    required this.title,
    required this.trailing,
    this.onTap,
    this.iconBackground = const Color(0xFFF5F5F5),
    this.iconColor,
    this.titleColor = Colors.black,
  });

  final String iconPath;
  final String title;
  final Widget trailing;
  final VoidCallback? onTap;
  final Color iconBackground;
  final Color? iconColor;
  final Color titleColor;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 60.h,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Row(
              children: [
                Container(
                  width: 28.w,
                  height: 28.w,
                  decoration: BoxDecoration(
                    color: iconBackground,
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    iconPath,
                    width: 20.w,
                    height: 20.w,
                    colorFilter: iconColor != null
                        ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
                        : null,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.leagueSpartan(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                      letterSpacing: -0.15,
                      color: titleColor,
                    ),
                  ),
                ),
                trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Chevron extends StatelessWidget {
  const _Chevron();

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.chevron_right_rounded,
      color: const Color.fromRGBO(119, 119, 119, 0.7),
      size: 24.w,
    );
  }
}

class _SwitchPill extends StatelessWidget {
  const _SwitchPill({required this.enabled, required this.onChanged});

  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 37.w,
      child: Transform.scale(
        scale: 0.72,
        child: Switch(
          value: enabled,
          onChanged: onChanged,
          activeTrackColor: const Color(0xFF64E6C4),
          inactiveTrackColor: const Color(0xFFD5D5D5),
          activeThumbColor: Colors.white,
          inactiveThumbColor: Colors.white,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.iconBase});

  final String iconBase;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: 390.w,
      height: 68.h,
      decoration: BoxDecoration(
        color: const Color(0xFFFDFDFD),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.r),
          topRight: Radius.circular(10.r),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.08),
            blurRadius: 1,
            offset: Offset(0, -0.6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _BottomItem(
            iconPath: '$iconBase/iconsax-home-2.svg',
            label: l10n.homeTabHome,
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(AppRoutes.home),
          ),
          SizedBox(width: 4.w),
          _BottomItem(
            iconPath: '$iconBase/iconsax-health.svg',
            label: l10n.homeTabWorkout,
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(AppRoutes.workout),
          ),
          SizedBox(width: 4.w),
          _BottomItem(
            iconPath: '$iconBase/iconsax-chart-square.svg',
            label: l10n.homeTabProgress,
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(AppRoutes.progress),
          ),
          SizedBox(width: 4.w),
          _BottomItem(
            iconPath: '$iconBase/iconsax-user.svg',
            label: l10n.homeTabProfile,
            active: true,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _BottomItem extends StatelessWidget {
  const _BottomItem({
    required this.iconPath,
    required this.label,
    this.active = false,
    this.onTap,
  });

  final String iconPath;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 94.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 28.w,
              height: 28.w,
              colorFilter: active
                  ? const ColorFilter.mode(Color(0xFF01A2F1), BlendMode.srcIn)
                  : null,
            ),
            SizedBox(height: 7.h),
            Text(
              label,
              style: GoogleFonts.leagueSpartan(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: active ? const Color(0xFF01A2F1) : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
