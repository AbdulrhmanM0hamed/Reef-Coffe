import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hyper_market/core/error/sevcice_failure.dart';
import 'package:hyper_market/feature/details/domain/repositories/rating_repository.dart';

class GetProductRatingUseCase {
  final RatingRepository repository;

  GetProductRatingUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call(GetProductRatingParams params) async {
    return await repository.getProductRating(params.productId);
  }
}

class GetProductRatingParams extends Equatable {
  final String productId;

  const GetProductRatingParams({required this.productId});

  @override
  List<Object?> get props => [productId];
}
