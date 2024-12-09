import 'package:equatable/equatable.dart';

class SpecialOffer extends Equatable {
  final String? id;
  final String title;
  final String subtitle;
  final String? image1;
  final String? image2;
  final String? image3;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SpecialOffer({
    this.id,
    required this.title,
    required this.subtitle,
    this.image1,
    this.image2,
    this.image3,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory SpecialOffer.fromJson(Map<String, dynamic> json) {
    return SpecialOffer(
      id: json['id']?.toString(),
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      image1: json['image1']?.toString(),
      image2: json['image2']?.toString(),
      image3: json['image3']?.toString(),
      isActive: json['isActive'] == true,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'].toString())
          : null,
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
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        subtitle,
        image1,
        image2,
        image3,
        isActive,
        createdAt,
        updatedAt,
      ];
}
