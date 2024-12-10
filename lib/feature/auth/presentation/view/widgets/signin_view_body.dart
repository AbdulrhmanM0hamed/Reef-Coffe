import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/utils/common/custom_text_form_field.dart';
import 'package:hyper_market/core/utils/common/elvated_button.dart';
import 'package:hyper_market/core/utils/common/password_field.dart';
import 'package:hyper_market/core/utils/constants/assets.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/auth/presentation/controller/signin/signin_cubit.dart';
import 'package:hyper_market/feature/auth/presentation/view/widgets/custom_divider.dart';
import 'package:hyper_market/feature/auth/presentation/view/widgets/dont_have_account.dart';
import 'package:hyper_market/feature/auth/presentation/view/widgets/socail_button.dart';
import 'package:hyper_market/core/utils/animations/custom_animations.dart';
import '../../../../../generated/l10n.dart';

class SigninViewBody extends StatefulWidget {
  const SigninViewBody({super.key});

  @override
  State<SigninViewBody> createState() => _SigninViewBodyState();
}

class _SigninViewBodyState extends State<SigninViewBody> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  bool _isVisible = false;

  late String email, password;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: size.height * 0.04,
          horizontal: size.width * 0.05,
        ),
        child: Form(
          key: formKey,
          autovalidateMode: autovalidateMode,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomAnimations.slideFromTop(
                duration: Duration(milliseconds: 800),
                child: CustomTextFormField(
                  onSaved: (value) => email = value!,
                  hintText: S.current!.email,
                  suffixIcon: const Icon(Icons.email),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              CustomAnimations.slideFromTop(
                duration: Duration(milliseconds: 900),
                child: PasswordField(
                  onSaved: (value) => password = value!,
                ),
              ),
              SizedBox(height: size.height * 0.01),
              CustomAnimations.fadeIn(
                duration: Duration(milliseconds: 1000),
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "نسيت كلمة المرور؟",
                    style: getMediumStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: size.height * 0.016,
                      color: TColors.primary,
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              CustomAnimations.fadeIn(
                duration: Duration(milliseconds: 1100),
                child: CustomElevatedButton(
                  buttonText: S.current!.login,
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      context.read<SignInCubit>().signInWithEmail(
                            email,
                            password,
                          );
                    } else {
                      autovalidateMode = AutovalidateMode.always;
                      setState(() {});
                    }
                  },
                ),
              ),
              SizedBox(height: size.height * 0.02),
              CustomAnimations.fadeIn(
                duration: Duration(milliseconds: 1200),
                child: const CustomDivider(),
              ),
              SizedBox(height: size.height * 0.02),
              CustomAnimations.slideFromBottom(
                duration: Duration(milliseconds: 1300),
                child: Column(
                  children: [
                    SocialButton(
                      onPressed: () {
                        context.read<SignInCubit>().signInWithGoogle();
                      },
                      iconPath: AssetsManager.googleIcon,
                      buttonText: "تسجيل بواسطة Google",
                    ),
                    SizedBox(height: size.height * 0.015),
                    SocialButton(
                      onPressed: () {
                        context.read<SignInCubit>().signInWithFacebook();
                      },
                      iconPath: AssetsManager.facebookIcon,
                      buttonText: "تسجيل بواسطة Facebook",
                    ),
                    SizedBox(height: size.height * 0.015),
                    SocialButton(
                      onPressed: () {},
                      iconPath: AssetsManager.appleIcon,
                      buttonText: "تسجيل بواسطة Apple",
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.02),
              CustomAnimations.fadeIn(
                duration: Duration(milliseconds: 1400),
                child: const DontHaveAccount(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
