import 'dart:convert';
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String? email;
  final String? name;
  final String? photoUrl;
  final String? phoneNumber;
  final AuthProviderType provider;

  const UserEntity({
    required this.id,
    this.email,
    this.name,
    this.photoUrl,
    this.phoneNumber,
    required this.provider,
  });

  factory UserEntity.fromJson(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return UserEntity(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      photoUrl: json['photoUrl'],
      phoneNumber: json['phoneNumber'],
      provider: AuthProviderType.values.firstWhere(
        (e) => e.toString() == 'AuthProviderType.${json['provider']}',
        orElse: () => AuthProviderType.email,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'phoneNumber': phoneNumber,
      'provider': provider.toString().split('.').last,
    };
  }

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        photoUrl,
        phoneNumber,
        provider,
      ];
}

enum AuthProviderType {
  email,
  google,
  facebook,
}
