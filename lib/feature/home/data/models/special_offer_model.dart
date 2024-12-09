import '../../domain/entities/special_offer.dart';

class SpecialOfferModel extends SpecialOffer {
  const SpecialOfferModel({
    super.id,
    required super.title,
    required super.subtitle,
    super.image1,
    super.image2,
    super.image3,
    super.isActive,
    super.createdAt,
    super.updatedAt,
  });

  factory SpecialOfferModel.fromJson(Map<String, dynamic> json) {
    return SpecialOfferModel(
      id: json['id'],
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      image1: json['image1'],
      image2: json['image2'],
      image3: json['image3'],
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'image1': image1,
      'image2': image2,
      'image3': image3,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
