import 'package:dartz/dartz.dart';
import 'package:hyper_market/core/error/excptions.dart';
import 'package:hyper_market/core/error/sevcice_failure.dart';
import 'package:hyper_market/feature/profile/data/datasources/profile_remote_datasource.dart';
import 'package:hyper_market/feature/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> updateName(String newName) async {
    try {
      await remoteDataSource.updateName(newName);
      return const Right(null);
    } on CustomException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updatePassword(
      String currentPassword, String newPassword) async {
    try {
      await remoteDataSource.updatePassword(currentPassword, newPassword);
      return const Right(null);
    } on CustomException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}