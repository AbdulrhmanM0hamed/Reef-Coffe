import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hyper_market/core/services/notification_service.dart';
import 'package:hyper_market/feature/notifications/data/models/notification_model.dart';

// States
abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object> get props => [];
}

class NotificationsInitial extends NotificationsState {
  const NotificationsInitial();
}

class NotificationsLoading extends NotificationsState {
  const NotificationsLoading();
}

class NotificationsLoaded extends NotificationsState {
  final List<NotificationModel> notifications;

  const NotificationsLoaded(this.notifications);

  @override
  List<Object> get props => [notifications];
}

class NotificationsError extends NotificationsState {
  final String message;

  const NotificationsError(this.message);

  @override
  List<Object> get props => [message];
}

// Cubit
class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(const NotificationsInitial()) {
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    try {
      emit(const NotificationsLoading());
      final notifications = await NotificationService.getNotifications();
      emit(NotificationsLoaded(notifications));
    } catch (e) {
      emit(const NotificationsError('حدث خطأ أثناء تحميل الإشعارات'));
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      final currentState = state;
      if (currentState is NotificationsLoaded) {
        // تحديث الإشعار في SharedPreferences
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
        
        // تحديث الحالة
        emit(NotificationsLoaded(updatedNotifications));
      }
    } catch (e) {
      emit(const NotificationsError('حدث خطأ أثناء تحديث الإشعار'));
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final currentState = state;
      if (currentState is NotificationsLoaded) {
        // تحديث جميع الإشعارات في SharedPreferences
        for (var notification in currentState.notifications) {
          if (!notification.isRead) {
            await NotificationService.markAsRead(notification.id);
          }
        }
        
        // تحديث جميع الإشعارات في الذاكرة
        final updatedNotifications = currentState.notifications.map((notification) {
          return NotificationModel(
            id: notification.id,
            title: notification.title,
            body: notification.body,
            timestamp: notification.timestamp,
            isRead: true,
          );
        }).toList();
        
        // تحديث الحالة
        emit(NotificationsLoaded(updatedNotifications));
      }
    } catch (e) {
      emit(const NotificationsError('حدث خطأ أثناء تحديث الإشعارات'));
    }
  }

  Future<void> clearAllNotifications() async {
    try {
      await NotificationService.clearAllNotifications();
      emit(const NotificationsLoaded([]));
    } catch (e) {
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
      emit(const NotificationsError('حدث خطأ أثناء حذف الإشعار'));
    }
  }
}
