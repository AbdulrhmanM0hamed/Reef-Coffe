import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hyper_market/core/error/sevcice_failure.dart';
import 'package:hyper_market/feature/details/domain/entities/rating.dart';
import 'package:hyper_market/feature/details/domain/repositories/rating_repository.dart';

class UpdateRatingUseCase {
  final RatingRepository repository;

  UpdateRatingUseCase(this.repository);

  Future<Either<Failure, Rating>> call(UpdateRatingParams params) async {
    return await repository.updateRating(params.productId, params.rating);
  }
}

class UpdateRatingParams extends Equatable {
  final String productId;
  final int rating;

  const UpdateRatingParams({
    required this.productId,
    required this.rating,
  });

  @override
  List<Object?> get props => [productId, rating];
}
