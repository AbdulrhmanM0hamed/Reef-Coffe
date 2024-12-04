import 'package:dartz/dartz.dart';
import 'package:hyper_market/core/error/sevcice_failure.dart';
import 'package:hyper_market/feature/notifications/data/models/notification_model.dart';
import 'package:hyper_market/feature/notifications/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {

  @override
  Future<Either<Failure, List<NotificationModel>>> getNotifications() async {
    try {
      final notifications = [
        NotificationModel(
          id: '1',
          title: 'عرض خاص',
          body: 'خصم 20% على جميع المنتجات',
          timestamp: DateTime.now()
              .subtract(const Duration(hours: 2))
              .toIso8601String(),
          isRead: false,
          imageUrl: 'assets/images/profile_image.png',
        ),
        NotificationModel(
          id: '2',
          title: 'تم توصيل طلبك',
          body: 'تم توصيل طلبك رقم #123456 بنجاح',
          timestamp: DateTime.now()
              .subtract(const Duration(days: 1))
              .toIso8601String(),
          isRead: true,
          imageUrl: 'assets/images/profile_image.png',

        ),
      ];
      return Right(notifications);
    } catch (e) {
      return Left(ServerFailure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String notificationId) async {
    try {
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearAll() async {
    try {
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(errMessage: e.toString()));
    }
  }
}
