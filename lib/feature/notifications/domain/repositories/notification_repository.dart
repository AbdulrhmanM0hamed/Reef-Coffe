import 'package:dartz/dartz.dart';
import 'package:hyper_market/core/error/sevcice_failure.dart';
import 'package:hyper_market/feature/notifications/data/models/notification_model.dart';

abstract class NotificationRepository {
  void listenToOrderChanges();
  Future<void> clearAllNotifications();
  Future<Either<Failure, List<NotificationModel>>> getNotifications();
  Future<Either<Failure, Unit>> markAsRead(String notificationId);
}
