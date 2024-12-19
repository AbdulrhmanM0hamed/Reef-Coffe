import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/feature/auth/domain/repositories/auth_repository.dart';
import 'package:hyper_market/feature/auth/presentation/controller/reset_password/reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final AuthRepository _authRepository;
  String? _email;  
  
  ResetPasswordCubit({
    required AuthRepository authRepository,
    String? email,
  }) : 
    _authRepository = authRepository,
    _email = email,
    super( ResetPasswordInitial());

  Future<void> sendResetCode(String email) async {
    emit(ResetPasswordLoading());
    try {
      // التحقق من وجود البريد
      final emailExistsResult = await _authRepository.isEmailRegistered(email);
      final exists = emailExistsResult.fold(
        (failure) => false,
        (exists) => exists,
      );
      if (!exists) {
        emit(const ResetPasswordError('البريد الإلكتروني غير مسجل'));
        return;
      }

      _email = email;
      final result = await _authRepository.sendResetCode(email);
      result.fold(
        (failure) => emit(ResetPasswordError(failure.message)),
        (_) => emit(const ResetCodeSent('تم إرسال كود التحقق بنجاح')),
      );
    } catch (e) {
      emit(ResetPasswordError(e.toString()));
    }
  }

  Future<void> verifyCode(String code) async {
    if (_email == null) {
      emit(const ResetPasswordError('حدث خطأ، يرجى المحاولة مرة أخرى'));
      return;
    }

    emit(ResetPasswordLoading());
    try {
      final result = await _authRepository.verifyResetCode(_email!, code);
      result.fold(
        (failure) => emit(ResetPasswordError(failure.message)),
        (_) => emit(const CodeVerified('تم التحقق من الكود بنجاح')),
      );
    } catch (e) {
      emit(ResetPasswordError(e.toString()));
    }
  }

  Future<void> resetPassword(String newPassword) async {
    if (_email == null) {
      emit(const ResetPasswordError('حدث خطأ، يرجى المحاولة مرة أخرى'));
      return;
    }

    emit(ResetPasswordLoading());
    try {
      final result = await _authRepository.resetPasswordWithCode(_email!, newPassword);
      result.fold(
        (failure) => emit(ResetPasswordError(failure.message)),
        (_) => emit(const PasswordResetSuccess('تم تغيير كلمة المرور بنجاح')),
      );
    } catch (e) {
      emit(ResetPasswordError(e.toString()));
    }
  }
}