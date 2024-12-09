import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hyper_market/feature/auth/domain/entities/user_entity.dart';
import 'package:hyper_market/feature/auth/domain/repositories/auth_repository.dart';

part 'signup_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final AuthRepository authRepository;

  SignUpCubit({required this.authRepository}) : super(SignUpInitialState());

  Future<void> signUpWithEmail(
      String email, String password, String name) async {
    emit(SignUpLoadingState());

    final result = await authRepository.signUpWithEmail(
        email: email, password: password, name: name);

    result.fold(
      (failure) => emit(SignUpErrorState(failure.message)),
      (user) => emit(SignUpSuccessState(user)),
    );
  }
}
