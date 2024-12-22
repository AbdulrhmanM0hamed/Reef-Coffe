import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/feature/auth/domain/repositories/auth_repository.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final AuthRepository authRepository;

  UserCubit({required this.authRepository}) : super(UserInitialState());

  Future<void> getCurrentUserData() async {
    emit(UserLoadingState());

    final nameResult = await authRepository.getCurrentUserName();
    final emailResult = await authRepository.getCurrentUserEmail();

    String name = 'زائر';
    String email = 'زائر';

    nameResult.fold(
      (failure) => emit(UserErrorState(failure.message)),
      (userName) {
        if (userName != null) name = userName;
      },
    );

    emailResult.fold(
      (failure) => emit(UserErrorState(failure.message)),
      (userEmail) {
        if (userEmail != null) email = userEmail;
      },
    );

    emit(UserLoadedState(name: name, email: email));
  }
}
