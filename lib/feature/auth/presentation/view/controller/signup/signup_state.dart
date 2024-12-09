part of 'signup_cubit.dart';

sealed class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object> get props => [];
}

class SignUpInitialState extends SignUpState {
  const SignUpInitialState();
}

class SignUpLoadingState extends SignUpState {}

class SignUpSuccessState extends SignUpState {
  final UserEntity user;

  const SignUpSuccessState(this.user);

  @override
  List<Object> get props => [user];
}

class SignUpErrorState extends SignUpState {
  final String message;
  
  const SignUpErrorState(this.message);

  @override
  List<Object> get props => [message];
}
