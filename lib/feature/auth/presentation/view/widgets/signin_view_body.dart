
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/services/shared_preferences.dart';
import 'package:hyper_market/core/utils/common/custom_text_form_field.dart';
import 'package:hyper_market/core/utils/common/elvated_button.dart';
import 'package:hyper_market/core/utils/common/password_field.dart';
import 'package:hyper_market/core/utils/constants/assets.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/constants.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/auth/presentation/controller/signin/signin_cubit.dart';
import 'package:hyper_market/feature/auth/presentation/view/forget_password.dart';
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
    Future.delayed(const Duration(milliseconds: 100), () {
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
                duration: const Duration(milliseconds: 800),
                child: CustomTextFormField(
                  onSaved: (value) => email = value!,
                  hintText: S.current!.email,
                  suffixIcon: const Icon(Icons.email),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              CustomAnimations.slideFromTop(
                duration:const Duration(milliseconds: 900),
                child: PasswordField(
                  hintText: S.current!.password,
                  onSaved: (value) => password = value!,
                ),
              ),
              SizedBox(height: size.height * 0.01),
              CustomAnimations.fadeIn(
                duration:const Duration(milliseconds: 1000),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      ForgotPasswordView.routeName,
                    );
                  },
                  child: Text(
                    "نسيت كلمة المرور؟",
                    style: getSemiBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: size.height * 0.016,
                      color: TColors.primary,
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              CustomAnimations.fadeIn(
                duration: const Duration(milliseconds: 1100),
                child: CustomElevatedButton(

                  buttonText: S.current!.login,
                  onPressed: () {
                 //   Prefs.setBool(KIsloginSuccess, true);
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
                duration: const Duration(milliseconds: 1200),
                child: const CustomDivider(),
              ),
              SizedBox(height: size.height * 0.02),
              CustomAnimations.slideFromBottom(
                duration: const Duration(milliseconds: 1300),
                child: Column(
                  children: [
                    SocialButton(
                      onPressed: () {
                        context.read<SignInCubit>().signInWithGoogle().then((_) {
                          Prefs.setBool(KIsloginSuccess, true);
                        });
                      },
                      iconPath: AssetsManager.googleIcon,
                      buttonText: "تسجيل بواسطة Google",
                    ),
                   
                  //   SocialButton(
                  //     onPressed: () {
                  // //      context.read<SignInCubit>().signInWithFacebook();
                  //     },
                  //     iconPath: AssetsManager.facebookIcon,
                  //     buttonText: "تسجيل بواسطة Facebook",
                  //   ),
                    SizedBox(height: size.height * 0.015),

                    // Platform.isIOS  ?
                    //   SocialButton(
                    //     onPressed: () {
                    //       context.read<SignInCubit>().signInWithApple();
                    //     },
                    //     iconPath: AssetsManager.appleIcon,
                    //     buttonText: "تسجيل بواسطة Apple",
                    //   ) : 
                    //   Tooltip(
                    //     message: 'متوفر فقط على أجهزة iOS',
                    //     child: Opacity(
                    //       opacity: 0.5,
                    //       child: SocialButton(
                    //         onPressed: () {},
                    //         iconPath: AssetsManager.appleIcon,
                    //         buttonText: "تسجيل بواسطة Apple ",
                    //       ),
                    //     ),
                    //   ),
                   
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.01),
              CustomAnimations.fadeIn(
                duration: const Duration(milliseconds: 1400),
                child: const DontHaveAccount(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
