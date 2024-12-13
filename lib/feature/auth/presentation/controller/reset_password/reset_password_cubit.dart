import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hyper_market/feature/auth/domain/repositories/auth_repository.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final AuthRepository authRepository;

  ResetPasswordCubit({required this.authRepository})
      : super(ResetPasswordInitial());

  Future<void> checkEmailAndGetPhone(String email) async {
    emit(ResetPasswordLoadingState());

    try {
      // First check if email exists
      final emailExistsResult = await authRepository.isEmailRegistered(email);
      
      final bool exists = await emailExistsResult.fold(
        (failure) => throw failure,
        (exists) => exists,
      );

      if (!exists) {
        emit(const ResetPasswordErrorState('هذا البريد الإلكتروني غير مسجل'));
        return;
      }

      // Get user's phone number
      final phoneResult = await authRepository.getUserPhoneNumber(email);
      
      final String? phone = await phoneResult.fold(
        (failure) => throw failure,
        (phone) => phone,
      );

      if (phone == null) {
        emit(const ResetPasswordErrorState('لم يتم العثور على رقم هاتف مسجل'));
        return;
      }

      emit(ResetPasswordPhoneRequiredState());
    } catch (e) {
      emit(ResetPasswordErrorState(e.toString()));
    }
  }

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    emit(ResetPasswordLoadingState());
    try {
      await authRepository.verifyPhoneNumber(phoneNumber);
      emit(ResetPasswordPhoneVerifiedState());
    } catch (e) {
      emit(ResetPasswordErrorState(e.toString()));
    }
  }

  Future<void> verifyOTP(String phoneNumber, String otp) async {
    emit(ResetPasswordLoadingState());
    try {
      final result = await authRepository.verifyOTP(phoneNumber, otp);
      if (result) {
        emit(ResetPasswordSuccessState());
      } else {
        emit(ResetPasswordErrorState('رمز التحقق غير صحيح'));
      }
    } catch (e) {
      emit(ResetPasswordErrorState(e.toString()));
    }
  }

  Future<void> sendOTP(String phoneNumber) async {
    emit(ResetPasswordLoadingState());
    try {
      await authRepository.sendOTP(phoneNumber);
      emit(ResetPasswordOTPSentState());
    } catch (e) {
      emit(ResetPasswordErrorState(e.toString()));
    }
  }
}
