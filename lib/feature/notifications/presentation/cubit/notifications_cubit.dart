import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hyper_market/feature/notifications/data/models/notification_model.dart';
import 'package:hyper_market/feature/notifications/domain/repositories/notification_repository.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationRepository _notificationRepository;

  NotificationsCubit(this._notificationRepository)
      : super(NotificationsInitial());

  Future<void> loadNotifications() async {
    emit(NotificationsLoading());
    final result = await _notificationRepository.getNotifications();
    result.fold(
      (failure) => emit(NotificationsError(failure.toString())),
      (notifications) => emit(NotificationsLoaded(notifications)),
    );
  }

  Future<void> markAsRead(String notificationId) async {
    final result = await _notificationRepository.markAsRead(notificationId);
    result.fold(
      (failure) => emit(NotificationsError(failure.toString())),
      (_) => loadNotifications(),
    );
  }

  Future<void> clearAllNotifications() async {
    final result = await _notificationRepository.clearAll();
    result.fold(
      (failure) => emit(NotificationsError(failure.toString())),
      (_) => loadNotifications(),
    );
  }
}
