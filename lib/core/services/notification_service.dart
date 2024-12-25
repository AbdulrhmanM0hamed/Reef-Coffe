import 'dart:ui';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hyper_market/feature/notifications/data/models/notification_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  static const String _notificationsKey = 'notifications';
  
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
    );
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
      // إعدادات الإشعار للأندرويد
      final androidDetails = AndroidNotificationDetails(
        'order_updates_channel',
        'تحديثات الطلبات',
        channelDescription: 'إشعارات خاصة بتحديثات حالة الطلبات',
        importance: Importance.max,
        priority: Priority.high,
        enableVibration: true,
        enableLights: true,
        color: const Color.fromARGB(255, 76, 175, 80),
        ledColor: const Color.fromARGB(255, 76, 175, 80),
        ledOnMs: 1000,
        ledOffMs: 500,
        icon: '@mipmap/ic_launcher',
        largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        styleInformation: const MediaStyleInformation(
          htmlFormatContent: true,
          htmlFormatTitle: true,
        ),
      );

      // إعدادات الإشعار للـ iOS
      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        badgeNumber: 1,
        interruptionLevel: InterruptionLevel.active,
        categoryIdentifier: 'order_updates',
      );

      final notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // إنشاء معرف فريد للإشعار
      final id = DateTime.now().millisecondsSinceEpoch % 100000;

      // عرض الإشعار
      await _notifications.show(
        id,
        '<b>$title</b>',  // تنسيق العنوان بخط عريض
        '<span style="color: #666666">$body</span>',  // تنسيق النص بلون رمادي
        notificationDetails,
        payload: payload,
      );
    } catch (e) {
      print('Error showing notification: $e');
    }
  }

  static Future<void> _saveNotification(NotificationModel notification) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notifications = await getNotifications();
      notifications.insert(0, notification);

      // تحويل القائمة إلى JSON string
      final String jsonString = jsonEncode(
        notifications.map((n) => n.toJson()).toList(),
      );
      
      await prefs.setString(_notificationsKey, jsonString);
    } catch (e) {
      print('Error saving notification: $e');
    }
  }

  static Future<List<NotificationModel>> getNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? notificationsJson = prefs.getString(_notificationsKey);

      if (notificationsJson == null || notificationsJson.isEmpty) {
        return [];
      }

      final List<dynamic> decoded = jsonDecode(notificationsJson);
      return decoded
          .map((item) => NotificationModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting notifications: $e');
      return [];
    }
  }

  static Future<void> markAsRead(String notificationId) async {
    final prefs = await SharedPreferences.getInstance();
    final notifications = await getNotifications();

    final index = notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      notifications[index] = NotificationModel(
        id: notifications[index].id,
        title: notifications[index].title,
        body: notifications[index].body,
        timestamp: notifications[index].timestamp,
        isRead: true,
      );

      await prefs.setString(
        _notificationsKey,
        jsonEncode(notifications.map((n) => n.toJson()).toList()),
      );
    }
  }

  static Future<void> clearAllNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_notificationsKey);
      
      // حذف جميع الإشعارات المعروضة
      await _notifications.cancelAll();
    } catch (e) {
      print('Error clearing notifications: $e');
    }
  }
}
