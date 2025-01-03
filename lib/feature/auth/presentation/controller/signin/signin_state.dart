part of 'signin_cubit.dart';

abstract class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object?> get props => [];
}

class SignInInitialState extends SignInState {
  const SignInInitialState();
}

class SignInLoadingState extends SignInState {}

class SignInSuccessState extends SignInState {
  final UserEntity user;

  const SignInSuccessState(this.user);

  @override
  List<Object?> get props => [user];
}

class SignInErrorState extends SignInState {
  final String message;

  const SignInErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class SignOutErrorState extends SignInState {
  final String message;

  const SignOutErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthSignedOutState extends SignInState {}
