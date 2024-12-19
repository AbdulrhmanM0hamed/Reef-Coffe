import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:convert';
import 'package:hyper_market/core/services/shared_preferences.dart';
import 'package:hyper_market/core/utils/constants/constants.dart';
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
      (user) {
        // Save user data
        final userJson = jsonEncode(user.toJson());
        Prefs.setString(KUserData, userJson);
        Prefs.setBool(KUserLogout, false);
        emit(SignInSuccessState(user));
      },
    );
  }

  Future<void> signInWithGoogle() async {
    emit(SignInLoadingState());

    final result = await authRepository.signInWithGoogle();

    result.fold(
      (failure) => emit(SignInErrorState(failure.message)),
      (user) {
        // Save user data
        final userJson = jsonEncode(user.toJson());
        Prefs.setString(KUserData, userJson);
        Prefs.setBool(KUserLogout, false);
        emit(SignInSuccessState(user));
      },
    );
  }

  // Future<void> signInWithFacebook() async {
  //   emit(SignInLoadingState());

  //   final result = await authRepository.signInWithFacebook();

  //   result.fold(
  //     (failure) => emit(SignInErrorState(failure.message)),
  //     (user) => emit(SignInSuccessState(user)),
  //   );
  // }

  Future<void> resetPassword(String email) async {
    emit(SignInLoadingState());

    final result = await authRepository.resetPassword(email);

    result.fold(
      (failure) => emit(SignInErrorState(failure.message)),
      (_) => emit(const SignInInitialState()),
    );
  }

  Future<void> signOut() async {
    if (isClosed) return; // Prevent emitting states if closed

    final result = await authRepository.signOut();

    if (isClosed) return; // Check again before emitting

    result.fold(
      (failure) => emit(SignOutErrorState(failure.message)),
      (_) => emit(AuthSignedOutState()),
    );
  }
}
