import 'package:dartz/dartz.dart';
import 'package:hyper_market/core/error/sevcice_failure.dart';
import 'package:hyper_market/feature/profile/domain/repositories/profile_repository.dart';

class UpdateNameUseCase {
  final ProfileRepository repository;

  UpdateNameUseCase(this.repository);

  Future<Either<Failure, void>> call(String params) async {
    return await repository.updateName(params);
  }
}