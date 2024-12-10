import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/services/service_locator.dart';
import 'package:hyper_market/core/utils/common/custom_app_bar.dart';
import 'package:hyper_market/feature/auth/presentation/controller/signup/signup_cubit.dart';
import 'package:hyper_market/feature/auth/presentation/view/widgets/signup_view_body_bloc_consumer.dart';
import 'package:hyper_market/generated/l10n.dart';

class SignupView extends StatelessWidget {
  static const routeName = 'SignupView';
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(authRepository: getIt()),
      child: Scaffold(
        appBar: customAppBar(context, S.current!.signup),
        body: const SignUpViewBodyBlocConsumer(),
      ),
    );
  }
}
