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

  const ProductRatingLoaded({
    required this.rating,
    required this.count,
  });

  @override
  List<Object> get props => [rating, count];
}

class RatingAdded extends RatingState {}

class RatingUpdated extends RatingState {}

class RatingError extends RatingState {
  final String message;

  const RatingError(this.message);

  @override
  List<Object> get props => [message];
}
