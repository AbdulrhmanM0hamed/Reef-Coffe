import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/auth/presentation/controller/reset_password/reset_password_state.dart';
import 'package:hyper_market/feature/auth/presentation/view/new_password_view.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:hyper_market/core/utils/common/elvated_button.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/feature/auth/presentation/controller/reset_password/reset_password_cubit.dart';

class VerificationCodeViewBody extends StatelessWidget {
  final String email;
  const VerificationCodeViewBody({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final TextEditingController codeController = TextEditingController();

    return BlocListener<ResetPasswordCubit, ResetPasswordState>(
      listener: (context, state) {
        if (state is CodeVerified) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacementNamed(
            context,
            NewPasswordView.routeName,
            arguments: email,
          );
        } else if (state is ResetPasswordError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'أدخل كود التحقق',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'تم إرسال كود التحقق إلى $email',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: PinCodeTextField(
                  appContext: context,
                  length: 6,
                  controller: codeController,
                  animationType: AnimationType.fade,
                  mainAxisAlignment: MainAxisAlignment.start,
                  onCompleted: (code) {
                    context.read<ResetPasswordCubit>().verifyCode(code);
                  },
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(8),
                    fieldHeight: 50,
                    fieldWidth: 45,
                    fieldOuterPadding: const EdgeInsets.symmetric(horizontal: 7),
                    activeFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                    selectedFillColor: Colors.white,
                    activeColor: TColors.primary,
                    inactiveColor: Colors.grey,
                    selectedColor: TColors.primary,
                  ),
                  cursorColor: TColors.primary,
                  animationDuration: const Duration(milliseconds: 250),
                  enableActiveFill: true,
                  keyboardType: TextInputType.number,
                  boxShadows: const [
                    BoxShadow(
                      offset: Offset(0, 1),
                      color: Colors.black12,
                      blurRadius: 10,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            CustomElevatedButton(
              buttonText: 'تحقق',
              onPressed: () {
                if (codeController.text.length == 6) {
                  context
                      .read<ResetPasswordCubit>()
                      .verifyCode(codeController.text);
                }
              },
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                context.read<ResetPasswordCubit>().sendResetCode(email);
              },
              child: Text(
                'إعادة إرسال الكود',
                style: getBoldStyle(
                    fontFamily: FontConstant.cairo, fontSize: FontSize.size16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
