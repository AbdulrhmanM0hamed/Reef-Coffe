import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/services/service_locator.dart';
import 'package:hyper_market/core/utils/common/cusom_progress_hud.dart';
import 'package:hyper_market/core/utils/common/custom_text_form_field.dart';
import 'package:hyper_market/core/utils/common/elvated_button.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/core/utils/constants/values_manger.dart';
import 'package:hyper_market/core/utils/helper/error_message_helper.dart';
import 'package:hyper_market/feature/auth/presentation/controller/reset_password/reset_password_cubit.dart';
import 'package:hyper_market/feature/auth/presentation/controller/reset_password/reset_password_state.dart';
import 'package:hyper_market/feature/auth/presentation/view/verification_code_view.dart';

class ForgetPasswordViewBody extends StatefulWidget {
  const ForgetPasswordViewBody({super.key});

  @override
  State<ForgetPasswordViewBody> createState() => _ForgetPasswordViewBodyState();
}

class _ForgetPasswordViewBodyState extends State<ForgetPasswordViewBody> {
  final _formKey = GlobalKey<FormState>();
  late String email;
  late String phoneNumber;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  bool showPhoneField = false;

  bool _validateEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetPasswordCubit(authRepository: getIt()),
      child: BlocListener<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, state) {
          if (state is ResetCodeSent) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pushNamed(
              context,
              VerificationCodeView.routeName,
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
        child: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
          listener: (context, state) {
            if (state is PasswordResetSuccess) {
              showSuccessSnackBar(
                context,
                'تم إرسال رمز التحقق بنجاح. يرجى التحقق من بريدك الإلكتروني',
              );
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            return CustomProgressHud(
              inLoading: state is ResetPasswordLoading ? true : false,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                child: Form(
                  key: _formKey,
                  autovalidateMode: autovalidateMode,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'أدخل بريدك الإلكتروني المُسجل',
                        textAlign: TextAlign.center,
                        style: getBoldStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size16,
                        ),
                      ),
                      const SizedBox(height: AppSize.s20),
                      CustomTextFormField(
                        hintText: "البريد الإلكتروني",
                        suffixIcon: const Icon(Icons.email),
                        onSaved: (value) => email = value!,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال بريدك الإلكتروني';
                          }
                          if (!_validateEmail(value)) {
                            return 'البريد الإلكتروني غير صحيح';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSize.s20),
                      CustomElevatedButton(
                        buttonText: "ارسل الكود",
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            context
                                .read<ResetPasswordCubit>()
                                .sendResetCode(email);
                          } else {
                            setState(() {
                              autovalidateMode = AutovalidateMode.always;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
