import 'package:equatable/equatable.dart';

class SpecialOffer extends Equatable {

  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String image1;
  final String? image2;
  final double offerPrice;
  final List<String> includedItems;
  final DateTime validUntil;
  final List<String> terms;
 // final Map<String, dynamic>? customizations;
  final int totalOrders;
  final int viewsCount;
  final int priority;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SpecialOffer({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.image1,
    this.image2,
    required this.offerPrice,
    required this.includedItems,
    required this.validUntil,
    required this.terms,
  //  this.customizations,
    this.totalOrders = 0,
    this.viewsCount = 0,
    this.priority = 0,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  // حساب نسبة الخصم
 
  // التحقق من صلاحية العرض
  bool get isValid => validUntil.isAfter(DateTime.now()) && isActive;

  factory SpecialOffer.fromJson(Map<String, dynamic> json) {
    return SpecialOffer(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      description: json['description'] ?? '',
      image1: json['image1'] ?? '',
      image2: json['image2']?.toString(),
      offerPrice: json['offerPrice'] ?? 0.0,
      includedItems: json['includedItems']?.cast<String>() ?? [],
      validUntil: json['validUntil'] != null
          ? DateTime.parse(json['validUntil'].toString())
          : DateTime.now(),
      terms: json['terms']?.cast<String>() ?? [],
  //    customizations: json['customizations'],
      totalOrders: json['totalOrders'] ?? 0,
      viewsCount: json['viewsCount'] ?? 0,
      priority: json['priority'] ?? 0,
      isActive: json['isActive'] == true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'].toString())
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'].toString())
          : DateTime.now(),
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
      'offerPrice': offerPrice,
      'includedItems': includedItems,
      'validUntil': validUntil.toIso8601String(),
      'terms': terms,
  //    'customizations': customizations,
      'totalOrders': totalOrders,
      'viewsCount': viewsCount,
      'priority': priority,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        subtitle,
        description,
        image1,
        image2,
        offerPrice,
        includedItems,
        validUntil,
        terms,
   //     customizations,
        totalOrders,
        viewsCount,
        priority,
        isActive,
        createdAt,
        updatedAt,
      ];
}
