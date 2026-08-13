import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../provider/notification_provider.dart';
import '../widgets/notification_item.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    // Refresh the list whenever the screen opens so the badge stays in sync.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<NotificationProvider>().fetchNotifications();
    });
  }

  String _timeAgo(DateTime d) {
    Duration diff = DateTime.now().difference(d);
    if (diff.inDays > 365)
      return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago";
    if (diff.inDays > 30)
      return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";
    if (diff.inDays > 7)
      return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
    if (diff.inDays > 0)
      return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago";
    if (diff.inHours > 0)
      return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
    if (diff.inMinutes > 0)
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
    return "Just now";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Consumer<NotificationProvider>(
              builder: (context, provider, _) {
                final hasUnread = provider.unreadCount > 0;
                return CustomAppBar(
                  title: 'Notifications',
                  actions: hasUnread
                      ? [
                          GestureDetector(
                            onTap: () => provider.markAllAsRead(),
                            child: Text(
                              'Mark all read',
                              style: AppTextStyle.text14Medium.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ]
                      : null,
                );
              },
            ),
            Expanded(
              child: Consumer<NotificationProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading && provider.notifications.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (provider.hasError && provider.notifications.isEmpty) {
                    return const Center(child: Text('Notification not found'));
                  }
                  if (provider.notifications.isEmpty) {
                    return const Center(child: Text('No notifications'));
                  }

                  final notifications = provider.notifications;
                  return RefreshIndicator(
                    onRefresh: () => provider.fetchNotifications(),
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: notifications.length,
                      separatorBuilder: (context, index) =>
                          Container(height: 1.h, color: AppColors.grey200),
                      itemBuilder: (context, index) {
                        final notification = notifications[index];
                        final isRead = provider.isRead(notification);
                        return NotificationItem(
                          message: notification.body,
                          timestamp: _timeAgo(notification.createdAt),
                          isRead: isRead,
                          onTap: () => provider.markAsRead(notification.id),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
