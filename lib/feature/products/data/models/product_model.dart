import 'package:hyper_market/feature/products/domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    super.imageUrl,
    required super.categoryId,
    required super.hasDiscount,
    super.discountPercentage,
    super.discountPrice,
    super.soldCount,
    required super.isAvailable,
    required super.stock,
    super.isOrganic,
    super.rating,
    super.ratingCount,
    super.caloriesPer100g,
    super.expiryName,
    super.weight,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString(),
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['image_url']?.toString(),
      categoryId: json['category_id']?.toString() ?? '',
      hasDiscount: json['has_discount'] as bool? ?? false,
      discountPercentage: json['discount_percentage'] as int?,
      discountPrice: (json['discount_price'] as num?)?.toDouble(),
      soldCount: json['sold_count'] as int? ?? 0,
      isAvailable: json['is_available'] as bool? ?? false,
      stock: json['stock'] as int? ?? 0,
      isOrganic: json['is_organic'] as bool? ?? false,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      ratingCount: json['rating_count'] as int? ?? 0,
      caloriesPer100g: (json['calories_per_100g'] as num?)?.toDouble() ?? 0.0,
      expiryName: json['expiry_name']?.toString() ?? '',
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
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
      'expiry_number': weight,
    };
  }
}
