import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hyper_market/feature/auth/domain/repositories/auth_repository.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final AuthRepository authRepository;

  UserCubit({required this.authRepository}) : super(UserInitialState());

  Future<void> getCurrentUserName() async {
    emit(UserLoadingState());

    final result = await authRepository.getCurrentUserName();

    result.fold(
      (failure) => emit(UserErrorState(failure.message)),
      (name) => emit(UserLoadedState(name ?? 'زائر')),
    );
  }
}
