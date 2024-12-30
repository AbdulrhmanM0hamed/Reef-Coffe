import 'package:equatable/equatable.dart';

class ProfileUpdate extends Equatable {
  final String? name;
  final String? currentPassword;
  final String? newPassword;

  const ProfileUpdate({
    this.name,
    this.currentPassword,
    this.newPassword,
  });

  @override
  List<Object?> get props => [name, currentPassword, newPassword];
}
