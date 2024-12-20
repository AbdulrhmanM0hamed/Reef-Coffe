import 'package:hyper_market/feature/home/domain/entities/special_offer.dart';

class SpecialOfferModel extends SpecialOffer {
  const SpecialOfferModel({
    required super.id,
    required super.title,
    required super.subtitle,
    required super.image1,
    super.image2,
    required super.isActive,
    required super.createdAt,
    required super.updatedAt,
    required super.description,
    required super.offerPrice,
    required super.includedItems,
    required super.validUntil,
    required super.terms,
   // super.customizations,
    super.totalOrders,
    super.viewsCount,
    super.priority,
  });

  factory SpecialOfferModel.fromJson(Map<String, dynamic> json) {
    return SpecialOfferModel(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      description: json['description'] ?? '',
      image1: json['image1'],
      image2: json['image2'],
      offerPrice: (json['offer_price'] ?? 0).toDouble(),
      includedItems: List<String>.from(json['included_items'] ?? []),
      validUntil: DateTime.parse(json['valid_until'] ?? DateTime.now().toIso8601String()),
      terms: List<String>.from(json['terms'] ?? []),
 //     customizations: json['customizations'],
      totalOrders: json['total_orders'] ?? 0,
      viewsCount: json['views_count'] ?? 0,
      priority: json['priority'] ?? 0,
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'image1': image1,
      'image2': image2,
      'offer_price': offerPrice,
      'included_items': includedItems,
      'valid_until': validUntil.toIso8601String(),
      'terms': terms,
   //   'customizations': customizations,
      'total_orders': totalOrders,
      'views_count': viewsCount,
      'priority': priority,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
