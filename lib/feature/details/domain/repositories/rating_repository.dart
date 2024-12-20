import 'package:dartz/dartz.dart';
import 'package:hyper_market/core/error/sevcice_failure.dart';
import 'package:hyper_market/feature/details/domain/entities/rating.dart';

abstract class RatingRepository {
  Future<Either<Failure, Rating>> addRating(String productId, int rating);
  Future<Either<Failure, bool>> hasUserRatedProduct(String productId);
  Future<Either<Failure, Rating>> updateRating(String productId, int rating);
  Future<Either<Failure, Map<String, dynamic>>> getProductRating(String productId);
  Future<Either<Failure, int>> getRatingCount(String productId);
  Future<Either<Failure, void>> updateRatingCount(String productId, bool increment);
}
