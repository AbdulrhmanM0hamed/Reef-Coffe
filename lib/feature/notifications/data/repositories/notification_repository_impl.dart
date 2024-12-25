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
    if (currentUserId == null) {
      print('No user logged in');
      return;
    }

    _unsubscribe();
    await _loadLastStatuses();
    

    _channel = _supabase
        .channel('order_updates')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'orders',
          callback: (payload) async {
            print('Received order change payload: ${payload.toString()}');
            
            if (payload.newRecord != null) {
              // استخدام newRow بدلاً من newRecord
              final newRow = payload.newRecord!;
              final orderId = newRow['id'] as String;
              final newStatus = newRow['status'] as String;
              final orderUserId = newRow['user_id'] as String;

       

              final updateKey = _generateUpdateKey(orderId, newStatus);
              
              if (updateKey == _lastUpdateKey) {
                print('Ignoring duplicate update: $updateKey');
                return;
              }

              if (currentUserId == orderUserId) {
                print('Creating notification for order status change');
                _lastUpdateKey = updateKey;
                _lastOrderStatuses[orderId] = newStatus;
                await _saveLastStatuses();

                try {
                  // إنشاء إشعار في Supabase
                  final String title = 'تحديث حالة الطلب';
                  final String body = 'تم تحديث حالة طلبك رقم #${_formatOrderId(orderId)} إلى: ${_getArabicStatus(newStatus)}';
                  
                  final notificationData = {
                    'id': DateTime.now().millisecondsSinceEpoch.toString(),
                    'user_id': currentUserId,
                    'title': title,
                    'body': body,
                    'created_at': DateTime.now().toIso8601String(),
                    'is_read': false,
                    'order_id': orderId,
                  };
                  
                  // التحقق من عدم وجود إشعار مكرر
                  final existingNotifications = await _supabase
                      .from('notifications')
                      .select()
                      .eq('user_id', currentUserId)
                      .eq('order_id', orderId)
                      .eq('body', body);

                  if ((existingNotifications as List).isEmpty) {
                    final response = await _supabase
                        .from('notifications')
                        .insert(notificationData)
                        .select()
                        .single();
                    

                    // عرض الإشعار
                    await NotificationService.showNotification(
                      title: title,
                      body: body,
                      payload: jsonEncode({'notification_id': notificationData['id']}),
                    );
                  } else {
                    print('Duplicate notification found, skipping creation');
                  }
                } catch (e, stackTrace) {
                  print('Error creating notification: $e');
                  print('Stack trace: $stackTrace');
                }
              } else {
                print('Order update is not for current user. Current: $currentUserId, Order: $orderUserId');
              }
            } else {
              print('New record is null in payload: $payload');
            }
          },
        )
        .subscribe();
    
  }

  @override
  Future<Either<Failure, List<NotificationModel>>> getNotifications() async {
    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        return Left(ServerFailure(message: 'لم يتم تسجيل الدخول'));
      }

      // جلب الإشعارات من Supabase
      final response = await _supabase
          .from('notifications')
          .select()
          .eq('user_id', currentUserId)
          .order('created_at', ascending: false);

      if (response == null) {
        return const Right([]);
      }

      final List<NotificationModel> notifications = (response as List)
          .map((notification) => NotificationModel.fromJson(notification))
          .toList();

      // حفظ الإشعارات في التخزين المحلي
      final prefs = await SharedPreferences.getInstance();
      final notificationsJson = jsonEncode(response);
      await prefs.setString(_notificationsKey, notificationsJson);

      return Right(notifications);
    } catch (e) {
      print('Error getting notifications: $e');
      return Left(ServerFailure(message: 'حدث خطأ أثناء تحميل الإشعارات'));
    }
  }

  @override
  Future<Either<Failure, Unit>> markAsRead(String notificationId) async {
    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        return Left(ServerFailure(message: 'لم يتم تسجيل الدخول'));
      }

      await _supabase
          .from('notifications')
          .update({'is_read': true})
          .eq('id', notificationId)
          .eq('user_id', currentUserId);

      return const Right(unit);
    } catch (e) {
      print('Error marking notification as read: $e');
      return Left(ServerFailure(message: 'حدث خطأ أثناء تحديث حالة الإشعار'));
    }
  }

  @override
  Future<Either<Failure, Unit>> markAllAsRead() async {
    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        return Left(ServerFailure(message: 'لم يتم تسجيل الدخول'));
      }

      await _supabase
          .from('notifications')
          .update({'is_read': true})
          .eq('user_id', currentUserId)
          .eq('is_read', false);

      return const Right(unit);
    } catch (e) {
      print('Error marking all notifications as read: $e');
      return Left(ServerFailure(message: 'حدث خطأ أثناء تحديث حالة الإشعارات'));
    }
  }

  @override
  Future<void> clearAllNotifications() async {
    try {
      await _supabase
          .from('notifications')
          .delete();
    } catch (e) {
      print('Error clearing notifications: $e');
    }
  }
}
