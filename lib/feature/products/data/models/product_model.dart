import 'package:hyper_market/feature/products/domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required String? id,
    required String name,
    required String description,
    required double price,
    String? imageUrl,
    required String categoryId,
    required bool hasDiscount,
    int? discountPercentage,
    double? discountPrice,
    int soldCount = 0,
    required bool isAvailable,
    required int stock,
    bool isOrganic = false,
    double rating = 0.0,
    int ratingCount = 0,
    double caloriesPer100g = 0.0,
    String expiryName = '',
    double expiryNumber = 0.0,
  }) : super(
          id: id,
          name: name,
          description: description,
          price: price,
          imageUrl: imageUrl,
          categoryId: categoryId,
          hasDiscount: hasDiscount,
          discountPercentage: discountPercentage,
          discountPrice: discountPrice,
          soldCount: soldCount,
          isAvailable: isAvailable,
          stock: stock,
          isOrganic: isOrganic,
          rating: rating,
          ratingCount: ratingCount,
          caloriesPer100g: caloriesPer100g,
          expiryName: expiryName,
          expiryNumber: expiryNumber,
        );

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String?,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image_url'] as String?,
      categoryId: json['category_id'] as String,
      hasDiscount: json['has_discount'] as bool,
      discountPercentage: json['discount_percentage'] as int?,
      discountPrice: json['discount_price'] == null ? null : (json['discount_price'] as num).toDouble(),
      soldCount: json['sold_count'] as int? ?? 0,
      isAvailable: json['is_available'] as bool,
      stock: json['stock'] as int,
      isOrganic: json['is_organic'] as bool? ?? false,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      ratingCount: json['rating_count'] as int? ?? 0,
      caloriesPer100g: (json['calories_per_100g'] as num?)?.toDouble() ?? 0.0,
      expiryName: json['expiry_name'] as String? ?? '',
      expiryNumber: (json['expiry_number'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image_url': imageUrl,
      'category_id': categoryId,
      'has_discount': hasDiscount,
      'discount_percentage': discountPercentage,
      'discount_price': discountPrice,
      'sold_count': soldCount,
      'is_available': isAvailable,
      'stock': stock,
      'is_organic': isOrganic,
      'rating': rating,
      'rating_count': ratingCount,
      'calories_per_100g': caloriesPer100g,
      'expiry_name': expiryName,
      'expiry_number': expiryNumber,
    };
  }
}
