import 'package:hyper_market/feature/details/domain/entities/comment.dart';

class CommentModel extends Comment {
  const CommentModel({
    required super.id,
    required super.productId,
    required super.userId,
    required super.userName,
    required super.comment,
    required super.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      productId: json['product_id'],
      userId: json['user_id'],
      userName: json['user_name'] ?? 'مستخدم',
      comment: json['comment'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'user_id': userId,
      'comment': comment,
    };
  }
}
