
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hyper_market/core/services/service_locator.dart';
import 'package:hyper_market/core/services/supabase/supabase_initialize.dart';
import 'package:hyper_market/feature/notifications/data/models/notification_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  static const String _notificationsKey = 'notifications';
  static const String _lastStatusKey = 'last_status';
  
  static RealtimeChannel? _orderChannel;

  static Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) async {
        if (details.payload != null) {
          // يمكنك التنقل إلى صفحة تفاصيل الطلب هنا
        }
      },
      onDidReceiveBackgroundNotificationResponse: _backgroundNotificationHandler,
    );
  }

  @pragma('vm:entry-point')
  static void _backgroundNotificationHandler(NotificationResponse details) async {
    // حفظ الإشعار في SharedPreferences حتى عندما يكون التطبيق مغلق
    if (details.payload != null) {
      try {
        final Map<String, dynamic> payload = jsonDecode(details.payload!);
        final notification = NotificationModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: payload['title'],
          body: payload['body'],
          timestamp: DateTime.now().toIso8601String(),
          isRead: false,
        );
        await saveNotification(notification);
      } catch (e) {
        print('Error in background handler: $e');
      }
    }
  }

  static Future<void> dispose() async {
    await _orderChannel?.unsubscribe();
  }

  static Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      final notification = NotificationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        body: body,
        timestamp: DateTime.now().toIso8601String(),
        isRead: false,
      );

      // حفظ الإشعار في SharedPreferences
      await saveNotification(notification);

      // عرض الإشعار فقط
      await _notifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'orders_channel',
            'Orders',
            channelDescription: 'Notifications for order status updates',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        payload: payload,
      );
    } catch (e) {
      print('Error showing notification: $e');
    }
  }

  static Future<void> saveNotification(NotificationModel notification) async {
    try {
      // إضافة الإشعار إلى Supabase فقط
      final currentUserId = getIt<SupabaseService>().client.auth.currentUser?.id;
      if (currentUserId != null) {
        await getIt<SupabaseService>().client.from('notifications').insert({
          'id': notification.id,
          'title': notification.title,
          'body': notification.body,
          'created_at': DateTime.now().toIso8601String(),
          'is_read': false,
          'user_id': currentUserId,
        });
      }
    } catch (e) {
      print('Error saving notification: $e');
    }
  }

  static Future<List<NotificationModel>> getNotifications() async {
    try {
      final currentUserId = getIt<SupabaseService>().client.auth.currentUser?.id;
      if (currentUserId == null) {
        return [];
      }

      final response = await getIt<SupabaseService>().client
          .from('notifications')
          .select()
          .eq('user_id', currentUserId)
          .order('created_at', ascending: false);

      if (response == null) {
        return [];
      }

      return (response as List)
          .map((notification) => NotificationModel.fromJson(notification))
          .toList();
    } catch (e) {
      print('Error getting notifications: $e');
      return [];
    }
  }

  static Future<void> markAsRead(String notificationId) async {
    try {
      final currentUserId = getIt<SupabaseService>().client.auth.currentUser?.id;
      if (currentUserId == null) {
        return;
      }

      await getIt<SupabaseService>().client
          .from('notifications')
          .update({'is_read': true})
          .eq('id', notificationId)
          .eq('user_id', currentUserId);
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  static Future<void> markAllAsRead() async {
    try {
      final currentUserId = getIt<SupabaseService>().client.auth.currentUser?.id;
      if (currentUserId == null) {
        return;
      }

      await getIt<SupabaseService>().client
          .from('notifications')
          .update({'is_read': true})
          .eq('user_id', currentUserId)
          .eq('is_read', false);
    } catch (e) {
      print('Error marking all notifications as read: $e');
    }
  }

  static Future<void> clearAllNotifications() async {
    try {
      final currentUserId = getIt<SupabaseService>().client.auth.currentUser?.id;
      if (currentUserId == null) {
        return;
      }

      await getIt<SupabaseService>().client
          .from('notifications')
          .delete()
          .eq('user_id', currentUserId);
    } catch (e) {
      print('Error clearing notifications: $e');
    }
  }

  static Future<void> checkNewNotifications() async {
    try {
      final currentUserId = getIt<SupabaseService>().client.auth.currentUser?.id;
      if (currentUserId == null) {
        return;
      }

      // جلب آخر وقت تم فيه فتح التطبيق
      final prefs = await SharedPreferences.getInstance();
      final lastOpenTime = prefs.getString('last_open_time') ?? DateTime.now().subtract(const Duration(days: 1)).toIso8601String();

      // جلب الإشعارات الجديدة
      final response = await getIt<SupabaseService>().client
          .from('notifications')
          .select()
          .eq('user_id', currentUserId)
          .eq('is_read', false)
          .gte('created_at', lastOpenTime)
          .order('created_at', ascending: false);

      if (response != null && (response as List).isNotEmpty) {
        // إذا كان هناك إشعارات جديدة، نعرض إشعار محلي
        await showNotification(
          title: 'لديك إشعارات جديدة',
          body: 'لديك ${response.length} إشعار${response.length > 1 ? 'ات' : ''} ${response.length > 1 ? 'جديدة' : 'جديد'}',
          payload: jsonEncode({'type': 'new_notifications'}),
        );
      }

      // تحديث وقت آخر فتح للتطبيق
      await prefs.setString('last_open_time', DateTime.now().toIso8601String());
    } catch (e) {
      print('Error checking new notifications: $e');
    }
  }
}