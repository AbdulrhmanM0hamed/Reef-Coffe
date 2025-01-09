part of 'rating_cubit.dart';

abstract class RatingState extends Equatable {
  const RatingState();

  @override
  List<Object> get props => [];
}

class RatingInitial extends RatingState {}

class RatingLoading extends RatingState {}

class ProductRatingLoaded extends RatingState {
  final double rating;
  final int count;
  final Map<String, dynamic> ratingCounts;

  const ProductRatingLoaded({
    required this.rating,
    required this.count,
    required this.ratingCounts,
  });

  @override
  List<Object> get props => [rating, count, ratingCounts];
}

class RatingAdded extends RatingState {}

class RatingUpdated extends RatingState {}

class RatingError extends RatingState {
  final String message;

  const RatingError(this.message);

  @override
  List<Object> get props => [message];
}
