import 'package:dartz/dartz.dart';
import 'package:hyper_market/core/error/sevcice_failure.dart';

import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signInWithEmail({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
  });

  Future<Either<Failure, bool>> isEmailRegistered(String email);

  Future<Either<Failure, UserEntity>> signInWithGoogle();

  Future<Either<Failure, UserEntity>> signInWithFacebook();

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, UserEntity?>> getCurrentUser();

  Future<Either<Failure, void>> resetPassword(String email);
  
  Future<Either<Failure, String?>> getCurrentUserName();
  Future<Either<Failure, String?>> getUserPhoneNumber(String email);
  Future<Either<Failure, void>> verifyPhoneNumber(String phoneNumber);
  Future<bool> verifyOTP(String phoneNumber, String otp);
Future<void> sendOTP(String phoneNumber);
}
