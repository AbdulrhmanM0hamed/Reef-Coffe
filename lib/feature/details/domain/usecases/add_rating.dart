import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hyper_market/core/error/sevcice_failure.dart';
import 'package:hyper_market/feature/details/domain/entities/rating.dart';
import 'package:hyper_market/feature/details/domain/repositories/rating_repository.dart';

class AddRatingUseCase {
  final RatingRepository repository;

  AddRatingUseCase(this.repository);

  @override
  Future<Either<Failure, Rating>> call(AddRatingParams params) async {
    return await repository.addRating(params.productId, params.rating);
  }
}

class AddRatingParams extends Equatable {
  final String productId;
  final int rating;

  const AddRatingParams({
    required this.productId,
    required this.rating,
  });

  @override
  List<Object?> get props => [productId, rating];
}
