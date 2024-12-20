import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  final String id;
  final String productId;
  final String userId;
  final String userName;
  final String comment;
  final DateTime createdAt;

  const Comment({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    required this.comment,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, productId, userId, userName, comment, createdAt];
}
