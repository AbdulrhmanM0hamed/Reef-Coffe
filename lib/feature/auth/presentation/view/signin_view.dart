import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/services/service_locator.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/auth/presentation/controller/signin/signin_cubit.dart';
import 'package:hyper_market/feature/auth/presentation/view/widgets/signin_view_body_bloc_consumer.dart';
import 'package:hyper_market/feature/home/presentation/cubit/user_cubit.dart';

class SigninView extends StatelessWidget {
  const SigninView({super.key});
  static const String routeName = "login";
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SignInCubit(authRepository: getIt()),
        ),
        BlocProvider(create: (context) => UserCubit(authRepository: getIt())),
      ],
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "تسجيل الدخول ",
            style: getBoldStyle(fontFamily: FontConstant.cairo, fontSize: 20.0),
          ),
        ),
        body: const SiginViewBodyBlocConsmer(),
      ),
    );
  }
}