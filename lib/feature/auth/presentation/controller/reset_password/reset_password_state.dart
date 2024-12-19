


import 'package:equatable/equatable.dart';

class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordLoading extends ResetPasswordState {}

// حالة إرسال كود التحقق بنجاح
class ResetCodeSent extends ResetPasswordState {
  final String message;
  const ResetCodeSent(this.message);

  @override
  List<Object?> get props => [message];
}

// حالة التحقق من الكود بنجاح
class CodeVerified extends ResetPasswordState {
  final String message;
  const CodeVerified(this.message);

  @override
  List<Object?> get props => [message];
}

// حالة تحديث كلمة المرور بنجاح
class PasswordResetSuccess extends ResetPasswordState {
  final String message;
  const PasswordResetSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

// حالة حدوث خطأ
class ResetPasswordError extends ResetPasswordState {
  final String message;
  const ResetPasswordError(this.message);

  @override
  List<Object?> get props => [message];
}

abstract class ResetPasswordState extends Equatable {
  const ResetPasswordState();

  @override
  List<Object?> get props => [];
}