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
