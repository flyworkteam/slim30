import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:slim30/Core/Auth/auth_service.dart';
import 'package:slim30/Core/Routes/app_routes.dart';
import 'package:slim30/Riverpod/Models/app_models.dart';
import 'package:slim30/Riverpod/Providers/backend_providers.dart';
import 'package:slim30/Riverpod/Providers/workout/workout_program_provider.dart';
import 'package:slim30/l10n/generated/app_localizations.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  static const _profileIconBase = 'assets/images/icons/profilePage';
  static const _homeIconBase = 'assets/images/icons/homePage';

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  bool _dailyNotificationsEnabled = true;
  bool _workoutRemindersEnabled = true;
  bool _progressSummariesEnabled = true;
  int _reminderHour = 9;
  bool _isSavingSettings = false;
  Future<void> _settingsUpdateQueue = Future<void>.value();
  NotificationSettingsModel? _confirmedSettings;
  NotificationSettingsModel? _settingsDraft;

  Future<void> _persistSettings(NotificationSettingsModel nextSettings) async {
    _isSavingSettings = true;
    final previousSettings =
        _confirmedSettings ?? NotificationSettingsModel.defaults();

    try {
      await updateNotificationSettings(ref, nextSettings);
      _confirmedSettings = nextSettings;
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _settingsDraft = previousSettings;
        _dailyNotificationsEnabled = previousSettings.dailyReminderEnabled;
        _workoutRemindersEnabled = previousSettings.workoutReminderEnabled;
        _progressSummariesEnabled = previousSettings.progressSummaryEnabled;
        _reminderHour = previousSettings.reminderHour;
      });
      ref.invalidate(notificationSettingsProvider);
      return;
    } finally {
      _isSavingSettings = false;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _settingsDraft = nextSettings;
      _dailyNotificationsEnabled = nextSettings.dailyReminderEnabled;
      _workoutRemindersEnabled = nextSettings.workoutReminderEnabled;
      _progressSummariesEnabled = nextSettings.progressSummaryEnabled;
      _reminderHour = nextSettings.reminderHour;
    });
  }

  Future<void> _enqueueSettingsPersist(NotificationSettingsModel nextSettings) {
    _settingsUpdateQueue = _settingsUpdateQueue.then(
      (_) => _persistSettings(nextSettings),
    );
    return _settingsUpdateQueue;
  }

  Future<void> _pickReminderHour(
    NotificationSettingsModel currentSettings,
  ) async {
    final selected = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (sheetContext) {
        final l10n = AppLocalizations.of(sheetContext)!;
        return SafeArea(
          top: false,
          child: SizedBox(
            height: 420.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 12.h),
                  child: Text(
                    l10n.profileNotificationReminderHour,
                    style: GoogleFonts.leagueSpartan(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: 24,
                    separatorBuilder: (_, _) =>
                        Divider(height: 1, color: const Color(0xFFECECEC)),
                    itemBuilder: (itemContext, index) {
                      final isSelected = index == _reminderHour;
                      final label = '${index.toString().padLeft(2, '0')}:00';
                      return ListTile(
                        title: Text(
                          label,
                          style: GoogleFonts.leagueSpartan(
                            fontSize: 18.sp,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        trailing: isSelected
                            ? Icon(
                                Icons.check_rounded,
                                color: const Color(0xFF32EA6E),
                              )
                            : null,
                        onTap: () => Navigator.of(itemContext).pop(index),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted || selected == null || selected == _reminderHour) {
      return;
    }

    final nextSettings = currentSettings.copyWith(reminderHour: selected);
    setState(() {
      _settingsDraft = nextSettings;
      _reminderHour = selected;
    });
    await _enqueueSettingsPersist(nextSettings);
  }

  Future<void> _logout() async {
    try {
      try {
        await Purchases.logOut();
      } catch (error) {
        if (error is PlatformException && error.code == '22') {
          // Expected when RevenueCat user is anonymous; safe to ignore.
        } else {
          debugPrint('RevenueCat logout failed: $error');
        }
      }
      await AuthService.signOut();
      if (!mounted) {
        return;
      }

      ref.invalidate(userProfileProvider);
      ref.invalidate(notificationSettingsProvider);
      ref.invalidate(notificationsProvider);
      ref.invalidate(progressSummaryProvider);
      ref.invalidate(workoutProgramProvider);
      ref.invalidate(completedProgressDaysProvider);

      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRoutes.login, (_) => false);
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(content: Text('Logout failed. Please try again.')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider).valueOrNull;
    final summary = ref.watch(progressOverviewProvider);
    final premium = ref.watch(premiumStatusProvider).valueOrNull;
    final settings = ref.watch(notificationSettingsProvider).valueOrNull;

    if (settings != null && !_isSavingSettings) {
      _confirmedSettings = settings;
      _settingsDraft = settings;
      _dailyNotificationsEnabled = settings.dailyReminderEnabled;
      _workoutRemindersEnabled = settings.workoutReminderEnabled;
      _progressSummariesEnabled = settings.progressSummaryEnabled;
      _reminderHour = settings.reminderHour;
    }

    final effectiveSettings =
        _settingsDraft ?? settings ?? NotificationSettingsModel.defaults();

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
                          child: _ProfileIdentity(
                            name: profile?.name ?? 'User',
                            email: profile?.email,
                            avatarUrl: profile?.avatarUrl,
                          ),
                        ),
                        SizedBox(height: 30.h),
                        _StatsStrip(
                          totalDays: summary?.totalDays ?? 30,
                          completedDays: summary?.completedDays ?? 0,
                          completionRate: summary?.completionRate ?? 0,
                        ),
                        SizedBox(height: 30.h),
                        _SettingsSection(
                          dailyNotificationsEnabled: _dailyNotificationsEnabled,
                          workoutRemindersEnabled: _workoutRemindersEnabled,
                          progressSummariesEnabled: _progressSummariesEnabled,
                          reminderHour: _reminderHour,
                          isPremium: premium?.isPremium == true,
                          onDailyNotificationsChanged: (value) async {
                            final nextSettings = effectiveSettings.copyWith(
                              dailyReminderEnabled: value,
                            );
                            setState(() {
                              _settingsDraft = nextSettings;
                              _dailyNotificationsEnabled = value;
                            });
                            await _enqueueSettingsPersist(nextSettings);
                          },
                          onWorkoutRemindersChanged: (value) async {
                            final nextSettings = effectiveSettings.copyWith(
                              workoutReminderEnabled: value,
                            );
                            setState(() {
                              _settingsDraft = nextSettings;
                              _workoutRemindersEnabled = value;
                            });
                            await _enqueueSettingsPersist(nextSettings);
                          },
                          onProgressSummariesChanged: (value) async {
                            final nextSettings = effectiveSettings.copyWith(
                              progressSummaryEnabled: value,
                            );
                            setState(() {
                              _settingsDraft = nextSettings;
                              _progressSummariesEnabled = value;
                            });
                            await _enqueueSettingsPersist(nextSettings);
                          },
                          onReminderHourTap: () =>
                              _pickReminderHour(effectiveSettings),
                        ),
                        SizedBox(height: 30.h),
                        _SupportSection(onLogout: _logout),
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
  const _ProfileIdentity({
    required this.name,
    required this.email,
    required this.avatarUrl,
  });

  final String name;
  final String? email;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 220.w,
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
                      child: _ProfileAvatar(name: name, avatarUrl: avatarUrl),
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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: GoogleFonts.leagueSpartan(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  height: 1,
                  color: Colors.black,
                ),
              ),
              if (email != null && email!.trim().isNotEmpty) ...[
                SizedBox(height: 4.h),
                Text(
                  email!.trim(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.leagueSpartan(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    height: 1,
                    color: const Color(0xFF5C5C5C),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.name, required this.avatarUrl});

  final String name;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final normalizedUrl = avatarUrl?.trim();
    final initials = _initials(name);

    return Container(
      width: 70.w,
      height: 70.w,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(35.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: normalizedUrl != null && normalizedUrl.isNotEmpty
          ? Image.network(
              normalizedUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _ProfileAvatarInitials(initials: initials);
              },
            )
          : _ProfileAvatarInitials(initials: initials),
    );
  }

  String _initials(String raw) {
    final parts = raw
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList(growable: false);

    if (parts.isEmpty) {
      return 'U';
    }

    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }
}

class _ProfileAvatarInitials extends StatelessWidget {
  const _ProfileAvatarInitials({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF62DCF4), Color(0xFF66F393)],
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: GoogleFonts.leagueSpartan(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            height: 1,
            color: Colors.white,
          ),
        ),
      ),
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
    final estimatedMinutes = completedDays * 10;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _StatItem(
          iconData: Iconsax.clock,
          value: '${estimatedMinutes}m',
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
    required this.dailyNotificationsEnabled,
    required this.workoutRemindersEnabled,
    required this.progressSummariesEnabled,
    required this.reminderHour,
    required this.onDailyNotificationsChanged,
    required this.onWorkoutRemindersChanged,
    required this.onProgressSummariesChanged,
    required this.onReminderHourTap,
    required this.isPremium,
  });

  final bool dailyNotificationsEnabled;
  final bool workoutRemindersEnabled;
  final bool progressSummariesEnabled;
  final int reminderHour;
  final ValueChanged<bool> onDailyNotificationsChanged;
  final ValueChanged<bool> onWorkoutRemindersChanged;
  final ValueChanged<bool> onProgressSummariesChanged;
  final VoidCallback onReminderHourTap;
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
                enabled: dailyNotificationsEnabled,
                onChanged: onDailyNotificationsChanged,
              ),
              onTap: () =>
                  onDailyNotificationsChanged(!dailyNotificationsEnabled),
            ),
            _SettingRow(
              iconPath:
                  '${ProfileView._profileIconBase}/iconsax-notification-bing.svg',
              title: l10n.profileWorkoutReminders,
              trailing: _SwitchPill(
                enabled: workoutRemindersEnabled,
                onChanged: onWorkoutRemindersChanged,
              ),
              onTap: () => onWorkoutRemindersChanged(!workoutRemindersEnabled),
            ),
            _SettingRow(
              iconPath:
                  '${ProfileView._profileIconBase}/iconsax-notification-bing.svg',
              title: l10n.profileProgressSummaries,
              trailing: _SwitchPill(
                enabled: progressSummariesEnabled,
                onChanged: onProgressSummariesChanged,
              ),
              onTap: () =>
                  onProgressSummariesChanged(!progressSummariesEnabled),
            ),
            _SettingRow(
              iconPath: '${ProfileView._profileIconBase}/icon-time.svg',
              title: l10n.profileNotificationReminderHour,
              subtitle:
                  '${reminderHour.toString().padLeft(2, '0')}:00 • ${l10n.notificationsEverySixHours}',
              trailing: _Chevron(),
              onTap: onReminderHourTap,
            ),
            _SettingRow(
              iconPath: '${ProfileView._profileIconBase}/iconsax-crown-1.svg',
              title: isPremium
                  ? '${l10n.profilePremium} (ON)'
                  : l10n.profilePremium,
              trailing: _Chevron(),
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.premium),
            ),
          ],
        ),
      ],
    );
  }
}

class _SupportSection extends StatelessWidget {
  const _SupportSection({required this.onLogout});

  final Future<void> Function() onLogout;

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
              onTap: () async {
                await onLogout();
              },
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
    this.subtitle,
    this.iconBackground = const Color(0xFFF5F5F5),
    this.iconColor,
    this.titleColor = Colors.black,
  });

  final String iconPath;
  final String title;
  final Widget trailing;
  final VoidCallback? onTap;
  final String? subtitle;
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
          height: subtitle == null ? 60.h : 72.h,
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                          letterSpacing: -0.15,
                          color: titleColor,
                        ),
                      ),
                      if (subtitle != null) ...[
                        SizedBox(height: 2.h),
                        Text(
                          subtitle!,
                          style: GoogleFonts.leagueSpartan(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                            letterSpacing: -0.12,
                            color: const Color(0xFF6F6F6F),
                          ),
                        ),
                      ],
                    ],
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
