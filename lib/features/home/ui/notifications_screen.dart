import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../widgets/notification_item.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(title: 'Notifications'),
           
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: _notifications.length,
                separatorBuilder: (context, index) => Container(
                  height: 1.h,
                  color: AppColors.grey200,
                ),
                itemBuilder: (context, index) {
                  final notification = _notifications[index];
                  return NotificationItem(
                    message: notification.message,
                    timestamp: notification.timestamp,
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

final List<_NotificationData> _notifications = [
  _NotificationData(
    message: "Hey it's time for you gym session with James",
    timestamp: "About 1 minutes ago",
  ),
  _NotificationData(
    message: "Don't forget to hydrate!",
    timestamp: "About 5 minutes ago",
  ),
  _NotificationData(
    message: "Time for a quick walk",
    timestamp: "About 45 minutes ago",
  ),
  _NotificationData(
    message: "Let's plan for a healthy dinner.",
    timestamp: "About 1 hour 25 minutes ago",
  ),
];

class _NotificationData {
  final String message;
  final String timestamp;

  _NotificationData({
    required this.message,
    required this.timestamp,
  });
}

