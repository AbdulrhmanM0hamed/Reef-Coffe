import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/feature/profile/domain/usecases/update_name_usecase.dart';
import 'package:hyper_market/feature/profile/domain/usecases/update_password_usecase.dart';
import 'package:hyper_market/feature/profile/presentation/cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final UpdateNameUseCase updateNameUseCase;
  final UpdatePasswordUseCase updatePasswordUseCase;

  ProfileCubit({
    required this.updateNameUseCase,
    required this.updatePasswordUseCase,
  }) : super(ProfileInitial());

  Future<void> updateName(String newName) async {
    if (!isClosed) emit(ProfileLoading());
    final result = await updateNameUseCase(newName);
    result.fold(
      (failure) {
        if (!isClosed) emit(ProfileUpdateError(failure.message));
      },
      (_) {
        if (!isClosed) emit(const ProfileUpdateSuccess('تم تحديث الاسم بنجاح'));
      },
    );
  }

  Future<void> updatePassword(String currentPassword, String newPassword) async {
    if (!isClosed) emit(ProfileLoading());
    final result = await updatePasswordUseCase(
      PasswordParams(
        currentPassword: currentPassword,
        newPassword: newPassword,
      ),
    );
    result.fold(
      (failure) {
        if (!isClosed) emit(ProfileUpdateError(failure.message));
      },
      (_) {
        if (!isClosed) emit(const ProfileUpdateSuccess('تم تحديث كلمة السر بنجاح'));
      },
    );
  }
}
