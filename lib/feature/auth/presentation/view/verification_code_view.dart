import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/services/service_locator.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/auth/presentation/controller/reset_password/reset_password_cubit.dart';
import 'package:hyper_market/feature/auth/presentation/view/widgets/verification_code_view_body.dart';

class VerificationCodeView extends StatelessWidget {
  final String email;
  const VerificationCodeView({super.key, required this.email});
  static const String routeName = "verificationCode";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = ResetPasswordCubit(
          authRepository: getIt(),
          email: email,
        );
        return cubit;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(onPressed: () {
            Navigator.pop(context);
            
          }, icon: Icon(Icons.arrow_back_ios_new_outlined)),
          title:  Text( 'التحقق من البريد الإلكتروني' , style: getBoldStyle(fontFamily: FontConstant.cairo , fontSize: FontSize.size20),),
        ),
        body: VerificationCodeViewBody(email: email),
      ),
    );
  }
}