import 'package:dartz/dartz.dart';
import 'package:hyper_market/core/error/sevcice_failure.dart';

abstract class ProfileRepository {
  Future<Either<Failure, void>> updateName(String newName);
  Future<Either<Failure, void>> updatePassword(String currentPassword, String newPassword);
}