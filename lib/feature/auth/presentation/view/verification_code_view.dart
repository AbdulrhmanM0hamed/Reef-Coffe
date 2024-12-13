import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/services/service_locator.dart';
import 'package:hyper_market/core/utils/common/custom_app_bar.dart';
import 'package:hyper_market/core/utils/common/elvated_button.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/core/utils/constants/values_manger.dart';
import 'package:hyper_market/core/utils/helper/error_message_helper.dart';
import 'package:hyper_market/feature/auth/presentation/controller/reset_password/reset_password_cubit.dart';

class VerificationCodeView extends StatefulWidget {
  const VerificationCodeView({super.key, required this.phoneNumber});
  static const String routeName = "verificationCode";
  final String phoneNumber;

  @override
  State<VerificationCodeView> createState() => _VerificationCodeViewState();
}

class _VerificationCodeViewState extends State<VerificationCodeView> {
  final List<TextEditingController> controllers =
      List.generate(6, (index) => TextEditingController());

  String get otp => controllers.map((c) => c.text).join();

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetPasswordCubit(authRepository: getIt()),
      child: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, state) {
          if (state is ResetPasswordSuccessState) {
            showSuccessSnackBar(
              context,
              'تم التحقق من الرمز بنجاح',
            );
            // Navigate to set new password screen
            // TODO: Add navigation to new password screen
          }
          if (state is ResetPasswordErrorState) {
            showErrorSnackBar(context, state.message);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: customAppBar(context, "التحقق من الرمز"),
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: Column(
                children: [
                  Text.rich(
                    TextSpan(
                      text: "أدخل الرمز الذي أرسلناه إلى رقم الهاتف التالي ",
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size16,
                        color: Colors.grey,
                      ),
                      children: [
                        TextSpan(
                          text: widget.phoneNumber,
                          style: getSemiBoldStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size18,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSize.s20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: 45,
                        child: TextField(
                          controller: controllers[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          onChanged: (value) {
                            if (value.isNotEmpty && index < 5) {
                              FocusScope.of(context).nextFocus();
                            }
                            if (value.isEmpty && index > 0) {
                              FocusScope.of(context).previousFocus();
                            }
                            if (index == 5 && value.isNotEmpty) {
                              // Verify OTP when all digits are entered
                              context
                                  .read<ResetPasswordCubit>()
                                  .verifyOTP(widget.phoneNumber, otp);
                            }
                          },
                          decoration: InputDecoration(
                            counterText: "",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          style: getBoldStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size24,
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: AppSize.s24),
                  CustomElevatedButton(
                    onPressed: () {
                      if (otp.length == 6) {
                        context
                            .read<ResetPasswordCubit>()
                            .verifyOTP(widget.phoneNumber, otp);
                      } else {
                        showErrorSnackBar(
                          context,
                          'يرجى إدخال الرمز المكون من 6 أرقام',
                        );
                      }
                    },
                    buttonText: "تحقق من الرمز",
                  ),
                  const SizedBox(height: AppSize.s24),
                  TextButton(
                    onPressed: () {
                      context
                          .read<ResetPasswordCubit>()
                          .sendOTP(widget.phoneNumber);
                    },
                    child: Text(
                      "إعادة إرسال الرمز",
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.cairo,
                        color: Theme.of(context).primaryColor,
                        fontSize: FontSize.size18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
