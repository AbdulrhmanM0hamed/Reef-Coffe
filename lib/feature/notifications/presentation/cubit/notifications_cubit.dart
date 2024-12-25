import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hyper_market/core/services/notification_service.dart';
import 'package:hyper_market/feature/notifications/data/models/notification_model.dart';

part 'notifications_state.dart';

// Cubit
class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(NotificationsInitial());

  Future<void> loadNotifications() async {
    try {
      emit(NotificationsLoading());
      final notifications = await NotificationService.getNotifications();
      emit(NotificationsLoaded(notifications));
    } catch (e) {
      print('Error loading notifications: $e');
      emit(const NotificationsError('حدث خطأ أثناء تحميل الإشعارات'));
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      final currentState = state;
      if (currentState is NotificationsLoaded) {
        await NotificationService.markAsRead(id);
        
        // تحديث حالة الإشعار في الذاكرة
        final updatedNotifications = currentState.notifications.map((notification) {
          if (notification.id == id) {
            return NotificationModel(
              id: notification.id,
              title: notification.title,
              body: notification.body,
              timestamp: notification.timestamp,
              isRead: true,
            );
          }
          return notification;
        }).toList();
        
        emit(NotificationsLoaded(updatedNotifications));
      }
    } catch (e) {
      print('Error marking notification as read: $e');
      emit(const NotificationsError('حدث خطأ أثناء تحديث الإشعار'));
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await NotificationService.markAllAsRead();
      // إعادة تحميل الإشعارات بعد تحديث حالتها
      await loadNotifications();
    } catch (e) {
      print('Error marking all notifications as read: $e');
      emit(const NotificationsError('حدث خطأ أثناء تحديث الإشعارات'));
    }
  }

  Future<void> clearAllNotifications() async {
    try {
      await NotificationService.clearAllNotifications();
      emit(const NotificationsLoaded([]));
    } catch (e) {
      print('Error clearing notifications: $e');
      emit(const NotificationsError('حدث خطأ أثناء حذف الإشعارات'));
    }
  }

  Future<void> deleteNotification(String id) async {
    try {
      final currentState = state;
      if (currentState is NotificationsLoaded) {
        final updatedNotifications = currentState.notifications
            .where((notification) => notification.id != id)
            .toList();
        emit(NotificationsLoaded(updatedNotifications));
      }
    } catch (e) {
      print('Error deleting notification: $e');
      emit(const NotificationsError('حدث خطأ أثناء حذف الإشعار'));
    }
  }
}
