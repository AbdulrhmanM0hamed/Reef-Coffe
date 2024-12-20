import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hyper_market/core/error/sevcice_failure.dart';
import 'package:hyper_market/feature/details/domain/repositories/rating_repository.dart';

class CheckUserRatingUseCase {
  final RatingRepository repository;

  CheckUserRatingUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(CheckUserRatingParams params) async {
    return await repository.hasUserRatedProduct(params.productId);
  }
}

class CheckUserRatingParams extends Equatable {
  final String productId;

  const CheckUserRatingParams({required this.productId});

  @override
  List<Object?> get props => [productId];
}
