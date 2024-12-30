import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hyper_market/core/error/sevcice_failure.dart';
import 'package:hyper_market/feature/profile/domain/repositories/profile_repository.dart';

class UpdatePasswordUseCase {
  final ProfileRepository repository;

  UpdatePasswordUseCase(this.repository);

  Future<Either<Failure, void>> call(PasswordParams params) async {
    return await repository.updatePassword(
      params.currentPassword,
      params.newPassword,
    );
  }
}

class PasswordParams extends Equatable {
  final String currentPassword;
  final String newPassword;

  const PasswordParams({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword];
}