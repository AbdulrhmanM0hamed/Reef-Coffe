import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/utils/common/cusom_progress_hud.dart';
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
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final fieldWidth = screenWidth * 0.11; // حجم ثابت نسبي لكل حقل
    final spacing = screenWidth * 0.01; // المسافة بين الحقول

    return BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
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
      builder: (context, state) {
        return CustomProgressHud(
          inLoading: state is ResetPasswordLoading,
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
                SizedBox(height: size.height * 0.03),
                Text(
                  'تم إرسال كود التحقق إلى $email',
                  textAlign: TextAlign.center,
                  style: getSemiBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: screenWidth * 0.035,
                      color: TColors.darkGrey),
                ),
                SizedBox(height: size.height * 0.04),
                Container(
                  width: screenWidth,
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: PinCodeTextField(
                      appContext: context,
                      length: 6,
                      controller: codeController,
                      animationType: AnimationType.fade,
                      mainAxisAlignment: MainAxisAlignment.center,
                      onCompleted: (code) {
                        context.read<ResetPasswordCubit>().verifyCode(code);
                      },
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(8),
                        fieldHeight: fieldWidth,
                        fieldWidth: fieldWidth,
                        fieldOuterPadding:
                            EdgeInsets.symmetric(horizontal: spacing),
                        inactiveFillColor: Colors.white,
                        selectedFillColor: Colors.white,
                        activeColor: TColors.primary,
                        inactiveColor: Colors.grey,
                        selectedColor: TColors.secondary,
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
                SizedBox(height: size.height * 0.02),
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
                SizedBox(height: size.height * 0.02),
                TextButton(
                  onPressed: () {
                    context.read<ResetPasswordCubit>().sendResetCode(email);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تم إرسال كود التحقق'),
                        backgroundColor: TColors.primary,
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  child: Text(
                    'إعادة إرسال الكود',
                    style: getBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: screenWidth * 0.045,
                        color: TColors.secondary),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
