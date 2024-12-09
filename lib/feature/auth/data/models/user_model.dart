import 'package:hyper_market/feature/auth/domain/entities/user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserModel extends UserEntity {
  const UserModel({
    required String id,
    String? email,
    String? name,
    String? photoUrl,
    String? phoneNumber,
    required AuthProviderType provider,
  }) : super(
          id: id,
          email: email,
          name: name,
          photoUrl: photoUrl,
          phoneNumber: phoneNumber,
          provider: provider,
        );

  factory UserModel.fromSupabaseUser(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      name: user.userMetadata?['name'],
      photoUrl: user.userMetadata?['photoUrl'],
      phoneNumber: user.phone,
      provider: _getProviderFromString(user.appMetadata['provider'] as String? ?? 'email'),
    );
  }

  static AuthProviderType _getProviderFromString(String provider) {
    switch (provider.toLowerCase()) {
      case 'google':
        return AuthProviderType.google;
      case 'facebook':
        return AuthProviderType.facebook;
      default:
        return AuthProviderType.email;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'phoneNumber': phoneNumber,
      'provider': provider.toString(),
    };
  }
}
