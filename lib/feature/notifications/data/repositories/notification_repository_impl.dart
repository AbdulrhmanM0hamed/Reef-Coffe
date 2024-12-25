import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:hyper_market/core/error/sevcice_failure.dart';
import 'package:hyper_market/core/services/service_locator.dart';
import 'package:hyper_market/feature/notifications/data/models/notification_model.dart';
import 'package:hyper_market/feature/notifications/domain/repositories/notification_repository.dart';
import 'package:hyper_market/core/services/notification_service.dart';
import 'package:hyper_market/core/services/supabase/supabase_initialize.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final _supabase = getIt<SupabaseService>().client;
  static const String _notificationsKey = 'notifications';
  static const String _lastStatusKey = 'last_status';
  final Map<String, String> _lastOrderStatuses = {};
  RealtimeChannel? _channel;
  String? _lastUpdateKey;

  String _getArabicStatus(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return 'مقبول ✅';
      case 'processing':
        return 'قيد المراجعة 🔄';
      case 'delivered':
        return 'تم التوصيل وتشرفنا بالتعامل معك 🤝';
      case 'completed':
        return 'الطلب جاهز وجاري التوصيل 🚚';
      case 'cancelled':
        return 'ملغي ❌';
        case 'pending':
        return 'قيد الانتظار ⏳ ';
      default:
        return status;
    }
  }

  String _formatOrderId(String orderId) {
    return orderId.substring(0, orderId.length < 8 ? orderId.length : 8);
  }

  Future<void> _loadLastStatuses() async {
    final prefs = await SharedPreferences.getInstance();
    final String? lastStatusJson = prefs.getString(_lastStatusKey);
    if (lastStatusJson != null) {
      final Map<String, dynamic> decoded = jsonDecode(lastStatusJson);
      _lastOrderStatuses.clear();
      decoded.forEach((key, value) {
        _lastOrderStatuses[key] = value.toString();
      });
    }
  }

  Future<void> _saveLastStatuses() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastStatusKey, jsonEncode(_lastOrderStatuses));
  }

  void _unsubscribe() {
    _channel?.unsubscribe();
    _channel = null;
  }

  String _generateUpdateKey(String orderId, String status) {
    return '$orderId:$status';
  }

  @override
  void listenToOrderChanges() async {
    final currentUserId = _supabase.auth.currentUser?.id;
    if (currentUserId == null) return;

    // إلغاء الاشتراك السابق إن وجد
    _unsubscribe();

    await _loadLastStatuses();
    print('Starting to listen for order changes for user: $currentUserId');

    _channel = _supabase
        .channel('order_updates')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'orders',
          callback: (payload) async {
            print('Received order change: $payload');
            
            if (payload.newRecord != null) {
              final orderId = payload.newRecord!['id'] as String;
              final newStatus = payload.newRecord!['status'] as String;
              final orderUserId = payload.newRecord!['user_id'] as String?;

              final updateKey = _generateUpdateKey(orderId, newStatus);
              
              // تجاهل التحديث إذا كان نفس التحديث السابق
              if (updateKey == _lastUpdateKey) {
                print('Ignoring duplicate update: $updateKey');
                return;
              }

   

              if (currentUserId == orderUserId) {
                
                // تحديث مفتاح آخر تحديث
                _lastUpdateKey = updateKey;
                
                // حفظ الحالة الجديدة
                _lastOrderStatuses[orderId] = newStatus;
                await _saveLastStatuses();
                
                final notification = NotificationModel(
                  id: DateTime.now().toString(),
                  title: 'تحديث حالة الطلب',
                  body: 'تم تحديث حالة طلبك رقم #${_formatOrderId(orderId)} إلى: ${_getArabicStatus(newStatus)}',
                  timestamp: DateTime.now().toIso8601String(),
                  isRead: false,
                );

                // حفظ الإشعار في SharedPreferences
                final prefs = await SharedPreferences.getInstance();
                final String? notificationsJson = prefs.getString(_notificationsKey);
                
                List<NotificationModel> notifications = [];
                if (notificationsJson != null && notificationsJson.isNotEmpty) {
                  final List<dynamic> decoded = jsonDecode(notificationsJson);
                  notifications = decoded
                      .map((item) => NotificationModel.fromJson(item as Map<String, dynamic>))
                      .toList();
                }
                
                // التحقق من عدم وجود نفس الإشعار في آخر 5 ثواني
                final now = DateTime.now();
                final recentNotifications = notifications.where((n) {
                  final notificationTime = DateTime.parse(n.timestamp);
                  final difference = now.difference(notificationTime);
                  return difference.inSeconds <= 5 && 
                         n.body.contains(orderId) && 
                         n.body.contains(_getArabicStatus(newStatus));
                });
                
                if (recentNotifications.isNotEmpty) {
                  return;
                }
                
                notifications.insert(0, notification);
                
                final String jsonString = jsonEncode(
                  notifications.map((n) => n.toJson()).toList(),
                );
                
                await prefs.setString(_notificationsKey, jsonString);

                // إظهار الإشعار
                await NotificationService.showNotification(
                  title: notification.title,
                  body: notification.body,
                );
              }
            }
          },
        )
        .subscribe();
    
  }

  @override
  Future<void> clearAllNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_notificationsKey);
    } catch (e) {
      print('Error clearing notifications: $e');
    }
  }

  @override
  Future<Either<Failure, List<NotificationModel>>> getNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? notificationsJson = prefs.getString(_notificationsKey);

      if (notificationsJson == null || notificationsJson.isEmpty) {
        return Right([]);
      }

      final List<dynamic> decoded = jsonDecode(notificationsJson);
      final List<NotificationModel> notifications = decoded
          .map((item) => NotificationModel.fromJson(item as Map<String, dynamic>))
          .toList();

      return Right(notifications);
    } catch (e) {
      return Left(ServerFailure(message: 'فشل في استرجاع الإشعارات: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> markAsRead(String notificationId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? notificationsJson = prefs.getString(_notificationsKey);

      if (notificationsJson == null || notificationsJson.isEmpty) {
        return const Right(unit);
      }

      final List<dynamic> decoded = jsonDecode(notificationsJson);
      final List<NotificationModel> notifications = decoded
          .map((item) => NotificationModel.fromJson(item as Map<String, dynamic>))
          .toList();

      final index = notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        notifications[index] = NotificationModel(
          id: notifications[index].id,
          title: notifications[index].title,
          body: notifications[index].body,
          timestamp: notifications[index].timestamp,
          isRead: true,
        );

        final String jsonString = jsonEncode(
          notifications.map((n) => n.toJson()).toList(),
        );
        await prefs.setString(_notificationsKey, jsonString);
      }

      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(message: 'فشل في تحديث حالة الإشعار: $e'));
    }
  }
}
