
import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/common/custom_app_bar.dart';
import 'package:hyper_market/feature/auth/presentation/view/widgets/forget_password_view_body.dart';


class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});
  static const String routeName = "forgotPassword";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context , "نسيان كلمة المرور"),
      body: const ForgetPasswordViewBody(),
    );
  }
}

