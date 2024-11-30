
import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/common/custom_app_bar.dart';
import 'package:hyper_market/feature/auth/presentation/view/widgets/signin_view_body.dart';
import 'package:hyper_market/generated/l10n.dart';

class SigninView extends StatelessWidget {
  const SigninView({super.key});
  static const String routeName = "login";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(context, S.current!.login ,loginScreen: true),
        body: SigninViewBody());
  }
}
