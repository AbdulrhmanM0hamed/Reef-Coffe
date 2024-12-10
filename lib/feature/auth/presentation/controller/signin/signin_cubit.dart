import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hyper_market/feature/auth/domain/entities/user_entity.dart';
import 'package:hyper_market/feature/auth/domain/repositories/auth_repository.dart';

part 'signin_state.dart';

class SignInCubit extends Cubit<SignInState> {
  final AuthRepository authRepository;

  SignInCubit({required this.authRepository}) : super(SignInInitialState());

  Future<void> signInWithEmail(String email, String password) async {
    emit(SignInLoadingState());

    final result =
        await authRepository.signInWithEmail(email: email, password: password);

    result.fold(
      (failure) => emit(SignInErrorState(failure.message)),
      (user) => emit(SignInSuccessState(user)),
    );
  }

  Future<void> signInWithGoogle() async {
    emit(SignInLoadingState());

    final result = await authRepository.signInWithGoogle();

    result.fold(
      (failure) => emit(SignInErrorState(failure.message)),
      (user) => emit(SignInSuccessState(user)),
    );
  }

  Future<void> signInWithFacebook() async {
    emit(SignInLoadingState());

    final result = await authRepository.signInWithFacebook();

    result.fold(
      (failure) => emit(SignInErrorState(failure.message)),
      (user) => emit(SignInSuccessState(user)),
    );
  }

  Future<void> resetPassword(String email) async {
    emit(SignInLoadingState());

    final result = await authRepository.resetPassword(email);

    result.fold(
      (failure) => emit(SignInErrorState(failure.message)),
      (_) => emit(const SignInInitialState()),
    );
  }
}
