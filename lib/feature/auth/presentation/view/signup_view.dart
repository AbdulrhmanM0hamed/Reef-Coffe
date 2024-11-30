
import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/common/custom_app_bar.dart';
import 'package:hyper_market/feature/auth/presentation/view/widgets/signup_view_body.dart';
import 'package:hyper_market/generated/l10n.dart';

class SignupView extends StatelessWidget {
  static const routeName = 'SignupView';
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: customAppBar(context, S.current!.signup),
          body: const  SignupViewBody(), 
          
    );
  }
}
