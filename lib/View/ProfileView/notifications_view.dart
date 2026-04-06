import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slim30/Riverpod/Models/app_models.dart';
import 'package:slim30/Riverpod/Providers/backend_providers.dart';
import 'package:slim30/l10n/generated/app_localizations.dart';

class NotificationsView extends ConsumerStatefulWidget {
  const NotificationsView({super.key});

  @override
  ConsumerState<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends ConsumerState<NotificationsView> {
  static const _iconBase = 'assets/images/icons/notification_icon';

  Set<int> _removedIds = <int>{};
  bool _clearedAll = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final notifications = ref.watch(notificationsProvider).valueOrNull ??
        const <NotificationModel>[];
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final yesterdayStart = todayStart.subtract(const Duration(days: 1));

    String formatTime(DateTime date) {
      final h = date.hour.toString().padLeft(2, '0');
      final m = date.minute.toString().padLeft(2, '0');
      return '$h:$m';
    }

    final mapped = notifications
        .where((item) => !_removedIds.contains(item.id))
        .map(
          (item) => _NotificationItem(
            id: item.id,
            iconPath: '$_iconBase/iconsax-sms-tracking.svg',
            title: item.title,
            subtitle: item.body,
            time: formatTime(item.createdAt),
            createdAt: item.createdAt,
          ),
        )
        .toList(growable: false);

    final todayItems = _clearedAll
        ? const <_NotificationItem>[]
        : mapped
              .where((item) => item.createdAt.isAfter(todayStart))
              .toList(growable: false);

    final yesterdayItems = _clearedAll
        ? const <_NotificationItem>[]
        : mapped
              .where(
                (item) =>
                    item.createdAt.isAfter(yesterdayStart) &&
                    item.createdAt.isBefore(todayStart),
              )
              .toList(growable: false);

    final hasNotifications = todayItems.isNotEmpty || yesterdayItems.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: 390.w,
          child: SafeArea(
            bottom: false,
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 40.h, 24.w, 34.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Header(title: l10n.notificationsTitle),
                      SizedBox(height: 20.h),
                      Align(
                        alignment: Alignment.centerRight,
                        child: _ClearAllButton(
                          label: l10n.notificationsClearAll,
                          enabled: hasNotifications,
                          onTap: () async {
                            if (!hasNotifications) {
                              return;
                            }
                            await markAllNotificationsRead(ref);
                            setState(() => _clearedAll = true);
                            ScaffoldMessenger.of(context)
                              ..clearSnackBars()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text(
                                    l10n.notificationsClearedMessage,
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                          },
                        ),
                      ),
                      SizedBox(height: 18.h),
                      Expanded(
                        child: ListView(
                          children: [
                            _SectionTitle(text: l10n.notificationsToday),
                            SizedBox(height: 14.h),
                            _NotificationList(
                              items: todayItems,
                              onDelete: (id) async {
                                await markNotificationRead(ref, id);
                                setState(() => _removedIds = {..._removedIds, id});
                              },
                            ),
                            SizedBox(height: 28.h),
                            _SectionTitle(text: l10n.notificationsYesterday),
                            SizedBox(height: 14.h),
                            _NotificationList(
                              items: yesterdayItems,
                              onDelete: (id) async {
                                await markNotificationRead(ref, id);
                                setState(() => _removedIds = {..._removedIds, id});
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 8.h,
                  child: Center(
                    child: Container(
                      width: 144.w,
                      height: 5.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D0D0D),
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Semantics(
          label: l10n.questionBack,
          button: true,
          child: InkWell(
            onTap: () => Navigator.of(context).pop(),
            borderRadius: BorderRadius.circular(14.r),
            child: Container(
              width: 28.w,
              height: 28.w,
              decoration: BoxDecoration(
                color: const Color(0xFFEEEEEE),
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
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: GoogleFonts.leagueSpartan(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              height: 1,
              letterSpacing: -0.2,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(
          width: 28.w,
          height: 28.w,
          child: Center(
            child: Icon(
              Icons.more_vert_rounded,
              size: 22.w,
              color: const Color(0xFF66F393),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.leagueSpartan(
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
        height: 1,
        letterSpacing: -0.2,
        color: Colors.black,
      ),
    );
  }
}

class _NotificationList extends StatelessWidget {
  const _NotificationList({required this.items, required this.onDelete});

  final List<_NotificationItem> items;
  final ValueChanged<int> onDelete;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        for (int i = 0; i < items.length; i++) ...[
          Slidable(
            key: ValueKey<int>(items[i].id),
            endActionPane: ActionPane(
              motion: const DrawerMotion(),
              extentRatio: 0.13,
              children: [
                CustomSlidableAction(
                  onPressed: (_) => onDelete(items[i].id),
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.zero,
                  child: SizedBox(
                    width: 28.w,
                    height: 28.w,
                    child: SvgPicture.asset(
                      'assets/images/icons/notification_icon/iconsax-trash-square.svg',
                      width: 28.w,
                      height: 28.w,
                    ),
                  ),
                ),
              ],
            ),
            child: _NotificationRow(item: items[i]),
          ),
          if (i != items.length - 1)
            Container(
              margin: EdgeInsets.only(top: 15.h, bottom: 15.h),
              height: 1,
              color: const Color(0xFFEFEFEF),
            ),
        ],
      ],
    );
  }
}

class _NotificationRow extends StatelessWidget {
  const _NotificationRow({required this.item});

  final _NotificationItem item;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28.w,
                height: 28.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  item.iconPath,
                  width: 20.w,
                  height: 20.w,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: GoogleFonts.leagueSpartan(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        height: 1,
                        letterSpacing: -0.15,
                        color: const Color(0xFF0D0D0D),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      item.subtitle,
                      style: GoogleFonts.leagueSpartan(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.08,
                        letterSpacing: -0.13,
                        color: const Color(0xFF757575),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 10.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              item.time,
              style: GoogleFonts.leagueSpartan(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                height: 1,
                letterSpacing: -0.13,
                color: const Color(0xFF4E4949),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ClearAllButton extends StatelessWidget {
  const _ClearAllButton({
    required this.label,
    required this.onTap,
    required this.enabled,
  });

  final String label;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(6.r),
      child: Container(
        width: 71.w,
        height: 24.h,
        decoration: BoxDecoration(
          color: const Color(0xFFF7092C),
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: const Color(0xFFF7092C)),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: GoogleFonts.leagueSpartan(
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
            height: 1.8,
            letterSpacing: -0.11,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _NotificationItem {
  const _NotificationItem({
    required this.id,
    required this.iconPath,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.createdAt,
  });

  final int id;
  final String iconPath;
  final String title;
  final String subtitle;
  final String time;
  final DateTime createdAt;
}
