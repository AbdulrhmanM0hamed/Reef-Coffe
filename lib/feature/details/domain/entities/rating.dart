import 'package:equatable/equatable.dart';

class Rating extends Equatable {
  final String id;
  final String productId;
  final String userId;
  final int rating;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Rating({
    required this.id,
    required this.productId,
    required this.userId,
    required this.rating,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, productId, userId, rating, createdAt, updatedAt];
}
