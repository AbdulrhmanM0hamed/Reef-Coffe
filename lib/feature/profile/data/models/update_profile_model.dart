import 'package:hyper_market/feature/profile/domain/entities/profile_update.dart';

class UpdateProfileModel extends ProfileUpdate {
  const UpdateProfileModel({
    String? name,
    String? currentPassword,
    String? newPassword,
  }) : super(
          name: name,
          currentPassword: currentPassword,
          newPassword: newPassword,
        );

  factory UpdateProfileModel.fromJson(Map<String, dynamic> json) {
    return UpdateProfileModel(
      name: json['name'],
      currentPassword: json['current_password'],
      newPassword: json['new_password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'current_password': currentPassword,
      'new_password': newPassword,
    };
  }
}
