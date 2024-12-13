import 'package:dartz/dartz.dart';
import 'package:hyper_market/core/error/excptions.dart';
import 'package:hyper_market/core/error/sevcice_failure.dart';
import 'package:hyper_market/feature/auth/data/datasources/auth_remote_data_source.dart';
import 'package:hyper_market/feature/auth/data/models/user_model.dart';
import 'package:hyper_market/feature/auth/domain/entities/user_entity.dart';
import 'package:hyper_market/feature/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserEntity>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.signInWithEmail(email, password);
      return Right(UserModel.fromSupabaseUser(user));
    } on CustomException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
  }) async {
    try {
      final user = await remoteDataSource.signUpWithEmail(
        email,
        password,
        name,
        phoneNumber,
      );
      return Right(UserModel.fromSupabaseUser(user));
    } on CustomException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    try {
      final user = await remoteDataSource.signInWithGoogle();
      return Right(UserModel.fromSupabaseUser(user));
    } on CustomException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithFacebook() async {
    try {
      final user = await remoteDataSource.signInWithFacebook();
      return Right(UserModel.fromSupabaseUser(user));
    } on CustomException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(null);
    } on CustomException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      return Right(
        user != null ? UserModel.fromSupabaseUser(user) : null,
      );
    } on CustomException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, String?>> getCurrentUserName() async {
    try {
      final name = await remoteDataSource.getCurrentUserName();
      return Right(name);
    } on CustomException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, String?>> getUserPhoneNumber(String email) async {
    try {
      final phoneNumber = await remoteDataSource.getUserPhoneNumber(email);
      return Right(phoneNumber);
    } on CustomException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> verifyPhoneNumber(String phoneNumber) async {
    try {
      await remoteDataSource.verifyPhoneNumber(phoneNumber);
      return const Right(null);
    } on CustomException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> isEmailRegistered(String email) async {
    try {
      final exists = await remoteDataSource.isEmailRegistered(email);
      return Right(exists);
    } on CustomException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    try {
      await remoteDataSource.resetPassword(email);
      return const Right(null);
    } on CustomException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<void> sendOTP(String phoneNumber) async {
    try {
      await remoteDataSource.sendOTP(phoneNumber);
    } on CustomException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<bool> verifyOTP(String phoneNumber, String otp) async {
    try {
      return await remoteDataSource.verifyOTP(phoneNumber, otp);
    } on CustomException catch (e) {
      throw CustomException(message: e.message);
    }
  }
}
