import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/widgets.dart';
import 'package:hyper_market/core/services/service_locator.dart';
import 'package:hyper_market/core/services/supabase/supabase_initialize.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  late final SupabaseClient _client;
  static const String _channelKey = 'hyper_market_channel';
  static const String KUserData = 'user_data';
  
  Future<void> initialize() async {
    _client = getIt<SupabaseService>().client;
    
    // Initialize local notifications
    await AwesomeNotifications().initialize(
      null, // no icon for now
      [
        NotificationChannel(
          channelKey: _channelKey,
          channelName: 'هايبر ماركت',
          channelDescription: 'إشعارات تطبيق هايبر ماركت',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: const Color(0xFF9D50DD),
          importance: NotificationImportance.High,
          playSound: true,
          enableVibration: true,
          enableLights: true,
        ),
      ],
    );

    // Request notification permissions
    await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    // Listen to order status changes
    _client
      .channel('public:orders')
      .onPostgresChanges(
        event: PostgresChangeEvent.update,
        schema: 'public',
        table: 'orders',
        callback: (payload) async {
          debugPrint('🔔 Order status changed: ${payload.newRecord}');
          final orderId = payload.newRecord['id'] as String;
          final status = payload.newRecord['status'] as String;
          final userId = payload.newRecord['user_id'] as String;
          
          // Get current user ID
          final prefs = await SharedPreferences.getInstance();
          final userDataJson = prefs.getString(KUserData);
          String? currentUserId;
          if (userDataJson != null && userDataJson.isNotEmpty) {
            try {
              final userData = json.decode(userDataJson);
              currentUserId = userData['id'];
            } catch (e) {
              debugPrint('Error parsing user data: $e');
            }
          }

          debugPrint('🔔 Current user ID: $currentUserId, Order user ID: $userId');

          // Only show notification if this order belongs to current user
          if (currentUserId != null && userId == currentUserId) {
            _showOrderStatusNotification(orderId, status);
          }
        },
      )
      .subscribe();

    // Listen to special offers
    _client
      .channel('public:special_offers')
      .onPostgresChanges(
        event: PostgresChangeEvent.insert,
        schema: 'public',
        table: 'special_offers',
        callback: (payload) {
          debugPrint('🔔 New special offer: ${payload.newRecord}');
          final title = payload.newRecord['title'] as String;
          final subtitle = payload.newRecord['subtitle'] as String;
          _showSpecialOfferNotification(title, subtitle);
        },
      )
      .subscribe();

    debugPrint('🔔 NotificationService initialized successfully');
  }

  Future<void> _showOrderStatusNotification(String orderId, String status) async {
    String message = _getStatusMessage(status);
    // Get last 8 characters from order ID
    String shortOrderId = orderId.length > 8 ? orderId.substring(orderId.length - 8) : orderId;
    
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: _channelKey,
        title: 'تحديث حالة الطلب #$shortOrderId',
        body: message,
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }

  String _getStatusMessage(String status) {
    switch (status.toLowerCase()) {
      case 'processing':
        return 'جاري معالجة طلبك';
      case 'accepted':
        return 'تم الموافقة على طلبك';
      case 'completed':
        return 'تم اكتمال طلبك وجاري التوصيل';
      case 'delivered':
        return 'تم تسليم طلبك وتشرفنا في التعامل معك';
      case 'canceled':
        return 'تم إلغاء طلبك';
      default:
        return 'تم تحديث حالة طلبك إلى: $status';
    }
  }

  Future<void> _showSpecialOfferNotification(String title, String subtitle) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: _channelKey,
        title: 'عرض خاص جديد! 🎉',
        body: '$title\n$subtitle',
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }
}
