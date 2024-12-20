import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/feature/details/domain/usecases/add_rating.dart';
import 'package:hyper_market/feature/details/domain/usecases/check_user_rating.dart';
import 'package:hyper_market/feature/details/domain/usecases/get_product_rating.dart';
import 'package:hyper_market/feature/details/domain/usecases/update_rating.dart';

part 'rating_state.dart';

class RatingCubit extends Cubit<RatingState> {
  final AddRatingUseCase addRating;
  final CheckUserRatingUseCase checkUserRating;
  final UpdateRatingUseCase updateRating;
  final GetProductRatingUseCase getProductRating;

  RatingCubit({
    required this.addRating,
    required this.checkUserRating,
    required this.updateRating,
    required this.getProductRating,
  }) : super(RatingInitial());

  Future<void> loadProductRating(String productId) async {
    if (isClosed) return;
    emit(RatingLoading());

    final result = await getProductRating(GetProductRatingParams(productId: productId));
    if (isClosed) return;

    result.fold(
      (failure) => emit(RatingError('حدث خطأ في تحميل التقييمات')),
      (ratingData) => emit(ProductRatingLoaded(
        rating: ratingData['rating'],
        count: ratingData['count'],
      )),
    );
  }

  Future<void> submitOrUpdateRating(String productId, int rating) async {
    if (isClosed) return;
    emit(RatingLoading());

    final hasRatedResult = await checkUserRating(CheckUserRatingParams(productId: productId));
    if (isClosed) return;

    late final Either result;
    bool isUpdate = false;

    await hasRatedResult.fold(
      (failure) async => result = Left(failure),
      (hasRated) async {
        isUpdate = hasRated;
        if (hasRated) {
          result = await updateRating(UpdateRatingParams(
            productId: productId,
            rating: rating,
          ));
        } else {
          result = await addRating(AddRatingParams(
            productId: productId,
            rating: rating,
          ));
        }
      },
    );

    if (isClosed) return;
    result.fold(
      (failure) => emit(RatingError('حدث خطأ في عملية التقييم')),
      (rating) {
        emit(isUpdate ? RatingUpdated() : RatingAdded());
        loadProductRating(productId);
      },
    );
  }
}
