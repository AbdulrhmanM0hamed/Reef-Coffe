import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/notifications/data/models/notification_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationList extends StatelessWidget {
  final List<NotificationModel> notifications;

  const NotificationList({
    super.key,
    required this.notifications,
  });

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.notifications_none,
              size: 64,
              color: TColors.darkGrey,
            ),
            const SizedBox(height: 16),
            Text(
              'لا توجد إشعارات',
              style: getMediumStyle(
                fontFamily: FontConstant.cairo,
                color: TColors.darkGrey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return NotificationTile(notification: notification);
      },
    );
  }
}

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;

  const NotificationTile({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: notification.isRead
            ? Theme.of(context).cardColor
            : TColors.primary.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              "assets/images/profile_image.png",
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
        ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.cairo,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? TColors.white
                        : TColors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notification.body,
                  style: getRegularStyle(
                    fontFamily: FontConstant.cairo,
                    color: TColors.darkGrey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  timeago.format(DateTime.parse(notification.timestamp),
                      locale: 'ar'),
                  style: getRegularStyle(
                    fontFamily: FontConstant.cairo,
                    color: TColors.darkGrey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
