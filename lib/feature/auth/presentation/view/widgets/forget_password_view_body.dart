import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/services/service_locator.dart';
import 'package:hyper_market/core/utils/common/cusom_progress_hud.dart';
import 'package:hyper_market/core/utils/common/elvated_button.dart';
import 'package:hyper_market/core/utils/constants/values_manger.dart';
import 'package:hyper_market/core/utils/helper/error_message_helper.dart';
import 'package:hyper_market/feature/auth/presentation/controller/reset_password/reset_password_cubit.dart';
import 'package:hyper_market/feature/auth/presentation/view/verification_code_view.dart';
import 'package:hyper_market/feature/auth/presentation/view/widgets/custom_Text_field_email.dart';
import 'package:hyper_market/feature/auth/presentation/view/widgets/custom_phone_field.dart';

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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetPasswordCubit(authRepository: getIt()),
      child: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, state) {
          if (state is ResetPasswordPhoneRequiredState) {
            setState(() {
              showPhoneField = true;
            });
          }
          if (state is ResetPasswordSuccessState) {
            Navigator.pushNamed(context, VerificationCodeView.routeName);
            showSuccessSnackBar(
              context,
              'سيتم إرسال رمز التحقق إلى رقم هاتفك',
            );
          }
          if (state is ResetPasswordErrorState) {
            showErrorSnackBar(context, state.message);
          }
        },
        builder: (context, state) {
          return CustomProgressHud(
            inLoading: state is ResetPasswordLoadingState ? true : false,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: Form(
                key: _formKey,
                autovalidateMode: autovalidateMode,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      showPhoneField
                          ? 'أدخل رقم هاتفك للتحقق'
                          : 'أدخل بريدك الإلكتروني المسجل',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSize.s20),
                    if (!showPhoneField) ...[
                      CustomTextFieldEmail(
                        hintText: "البريد الإلكتروني",
                        suffixIcon: const Icon(Icons.email),
                        onSaved: (value) => email = value!,
                      ),
                    ] else ...[
                      CustomPhoneField(
                        onSaved: (value) => phoneNumber = value!,
                      ),
                    ],
                    const SizedBox(height: AppSize.s20),
                    CustomElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          if (!showPhoneField) {
                            context
                                .read<ResetPasswordCubit>()
                                .checkEmailAndGetPhone(email);
                          } else {
                            context
                                .read<ResetPasswordCubit>()
                                .verifyPhoneNumber(phoneNumber);
                          }
                        } else {
                          setState(() {
                            autovalidateMode = AutovalidateMode.always;
                          });
                        }
                      },
                      buttonText:
                          showPhoneField ? "تحقق من رقم الهاتف" : "متابعة",
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
