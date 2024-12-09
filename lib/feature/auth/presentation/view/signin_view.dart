import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/services/service_locator.dart';
import 'package:hyper_market/core/utils/common/custom_app_bar.dart';
import 'package:hyper_market/feature/auth/presentation/view/controller/cubit/auth_cubit.dart';
import 'package:hyper_market/feature/auth/presentation/view/controller/signin/signin_cubit.dart';
import 'package:hyper_market/feature/auth/presentation/view/widgets/signin_view_body_bloc_consumer.dart';

import 'package:hyper_market/generated/l10n.dart';

class SigninView extends StatelessWidget {
  const SigninView({super.key});
  static const String routeName = "login";
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInCubit(authRepository: getIt()),
      child: Scaffold(
        appBar: customAppBar(context, S.current!.login),
        body: const SiginViewBodyBlocConsmer(),
      ),
    );
  }
}
