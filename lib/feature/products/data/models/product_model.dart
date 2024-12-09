import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    super.id,
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
    super.expiryNumber,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0,
      imageUrl: json['image_url'],
      categoryId: json['category_id'] ?? '',
      hasDiscount: json['has_discount'] ?? false,
      discountPercentage:
          int.tryParse(json['discount_percentage']?.toString() ?? '0'),
      discountPrice: double.tryParse(json['discount_price']?.toString() ?? '0'),
      soldCount: int.tryParse(json['sold_count']?.toString() ?? '0') ?? 0,
      isAvailable: json['is_available'] ?? true,
      stock: int.tryParse(json['stock']?.toString() ?? '0') ?? 0,
      isOrganic: json['is_organic'] ?? false,
      rating: double.tryParse(json['rating']?.toString() ?? '0') ?? 0.0,
      ratingCount: int.tryParse(json['rating_count']?.toString() ?? '0') ?? 0,
      caloriesPer100g:
          double.tryParse(json['calories_per_100g']?.toString() ?? '0') ?? 0.0,
      expiryName: json['expiry_name'] ?? '',
      expiryNumber: double.tryParse(json['expiry_number']?.toString() ?? '0') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson({bool forCreation = false}) {
    final Map<String, dynamic> data = {
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
      'expiry_number': expiryNumber
    };

    if (!forCreation && id != null) {
      data['id'] = id;
    }

    return data;
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? categoryId,
    bool? hasDiscount,
    int? discountPercentage,
    double? discountPrice,
    int? soldCount,
    bool? isAvailable,
    int? stock,
    bool? isOrganic,
    double? rating,
    int? ratingCount,
    double? caloriesPer100g,
    String? expiryName,
    double? expiryNumber,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      categoryId: categoryId ?? this.categoryId,
      hasDiscount: hasDiscount ?? this.hasDiscount,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      discountPrice: discountPrice ?? this.discountPrice,
      soldCount: soldCount ?? this.soldCount,
      isAvailable: isAvailable ?? this.isAvailable,
      stock: stock ?? this.stock,
      isOrganic: isOrganic ?? this.isOrganic,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      caloriesPer100g: caloriesPer100g ?? this.caloriesPer100g,
      expiryName: expiryName ?? this.expiryName,
      expiryNumber: expiryNumber ?? this.expiryNumber,
    );
  }
}
