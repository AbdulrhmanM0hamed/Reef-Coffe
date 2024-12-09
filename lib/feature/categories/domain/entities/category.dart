import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String? id;
  final String name;
  final String description;
  final String imageUrl;
  final bool isActive;

  const Category({
    this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [id, name, description, imageUrl, isActive];
}
