import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String? id;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;
  final String categoryId;
  final bool hasDiscount;
  final int? discountPercentage;
  final double? discountPrice;
  final int soldCount;
  final bool isAvailable;
  final int stock;
  final bool isOrganic;
  final double rating;
  final int ratingCount;
  final double caloriesPer100g;
  final String expiryName;
  final double expiryNumber;

  const Product({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
    required this.categoryId,
    required this.hasDiscount,
    this.discountPercentage,
    this.discountPrice,
    this.soldCount = 0,
    required this.isAvailable,
    required this.stock,
    this.isOrganic = false,
    this.rating = 0.0,
    this.ratingCount = 0,
    this.caloriesPer100g = 0.0,
    this.expiryName = '',
    this.expiryNumber = 0.0,
  });
  

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        imageUrl,
        categoryId,
        hasDiscount,
        discountPercentage,
        discountPrice,
        soldCount,
        isAvailable,
        stock,
        isOrganic,
        rating,
        ratingCount,
        caloriesPer100g,
        expiryName,
        expiryNumber,
      ];
}
