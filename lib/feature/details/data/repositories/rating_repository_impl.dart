import 'package:dartz/dartz.dart';
import 'package:hyper_market/core/error/sevcice_failure.dart';
import 'package:hyper_market/feature/details/data/models/rating_model.dart';
import 'package:hyper_market/feature/details/domain/entities/rating.dart';
import 'package:hyper_market/feature/details/domain/repositories/rating_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RatingRepositoryImpl implements RatingRepository {
  final SupabaseClient supabaseClient;

  RatingRepositoryImpl({required this.supabaseClient});

  @override
  Future<Either<Failure, Rating>> addRating(String productId, int rating) async {
    try {
      final userId = supabaseClient.auth.currentUser!.id;
      
      // Add the rating
      final response = await supabaseClient.from('product_ratings').insert({
        'product_id': productId,
        'user_id': userId,
        'rating': rating,
      }).select().single();

      return Right(RatingModel.fromJson(response));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getProductRating(String productId) async {
    try {
      // Get all ratings for this product
      final ratingsResponse = await supabaseClient
          .from('product_ratings')
          .select('rating')
          .eq('product_id', productId);

      double averageRating = 0;
      int totalCount = ratingsResponse.length;

      if (totalCount > 0) {
        final ratings = ratingsResponse.map((r) => r['rating'] as int).toList();
        averageRating = ratings.reduce((a, b) => a + b) / totalCount;
      }

      return Right({
        'rating': averageRating,
        'count': totalCount,
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> hasUserRatedProduct(String productId) async {
    try {
      final userId = supabaseClient.auth.currentUser!.id;
      final response = await supabaseClient
          .from('product_ratings')
          .select()
          .eq('product_id', productId)
          .eq('user_id', userId);

      return Right(response.isNotEmpty);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Rating>> updateRating(String productId, int rating) async {
    try {
      final userId = supabaseClient.auth.currentUser!.id;
      final response = await supabaseClient
          .from('product_ratings')
          .update({'rating': rating})
          .eq('product_id', productId)
          .eq('user_id', userId)
          .select()
          .single();

      return Right(RatingModel.fromJson(response));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getRatingCount(String productId) async {
    try {
      final response = await supabaseClient
          .from('product_ratings')
          .select()
          .eq('product_id', productId);
      
      return Right(response.length);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateRatingCount(String productId, bool increment) async {
    try {
      // This is now handled automatically by counting actual ratings
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
