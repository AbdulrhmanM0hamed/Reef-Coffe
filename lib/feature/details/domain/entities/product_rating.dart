class ProductRating {
  final String id;
  final String productId;
  final String userId;
  final int rating;
  final DateTime createdAt;

  ProductRating({
    required this.id,
    required this.productId,
    required this.userId,
    required this.rating,
    required this.createdAt,
  });

  factory ProductRating.fromJson(Map<String, dynamic> json) {
    return ProductRating(
      id: json['id'],
      productId: json['product_id'],
      userId: json['user_id'],
      rating: json['rating'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'user_id': userId,
      'rating': rating,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
