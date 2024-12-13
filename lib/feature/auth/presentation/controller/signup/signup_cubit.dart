import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hyper_market/feature/auth/domain/entities/user_entity.dart';
import 'package:hyper_market/feature/auth/domain/repositories/auth_repository.dart';

part 'signup_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final AuthRepository authRepository;

  SignUpCubit({required this.authRepository}) : super(SignUpInitialState());

  Future<void> signUpWithEmail(
    String email,
    String password,
    String name,
    String phoneNumber,
  ) async {
    emit(SignUpLoadingState());

    try {
      // Check if email exists
      final emailExistsResult = await authRepository.isEmailRegistered(email);

      final bool exists = await emailExistsResult.fold(
        (failure) => throw failure,
        (exists) => exists,
      );

      if (exists) {
        emit(SignUpErrorState('هذا البريد الإلكتروني مسجل بالفعل'));
        return;
      }

      final result = await authRepository.signUpWithEmail(
        email: email,
        password: password,
        name: name,
        phoneNumber: phoneNumber,
      );

      result.fold(
        (failure) => emit(SignUpErrorState(failure.message)),
        (user) => emit(SignUpSuccessState(user)),
      );
    } catch (e) {
      emit(SignUpErrorState(e.toString()));
    }
  }
}
