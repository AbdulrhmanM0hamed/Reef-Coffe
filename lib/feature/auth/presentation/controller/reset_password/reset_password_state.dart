part of 'reset_password_cubit.dart';

abstract class ResetPasswordState extends Equatable {
  const ResetPasswordState();

  @override
  List<Object> get props => [];
}

class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordLoadingState extends ResetPasswordState {}

class ResetPasswordPhoneRequiredState extends ResetPasswordState {}

class ResetPasswordSuccessState extends ResetPasswordState {}

class ResetPasswordErrorState extends ResetPasswordState {
  final String message;

  const ResetPasswordErrorState(this.message);

  @override
  List<Object> get props => [message];
}
class ResetPasswordPhoneVerifiedState extends ResetPasswordState {}

class ResetPasswordOTPSentState extends ResetPasswordState {}
