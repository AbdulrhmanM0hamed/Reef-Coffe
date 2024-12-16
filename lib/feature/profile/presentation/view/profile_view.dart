import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/services/service_locator.dart';
import 'package:hyper_market/feature/auth/presentation/controller/signin/signin_cubit.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/profile/presentation/view/widgets/profile_view_body.dart';

class ProfileView extends StatelessWidget {
  static const String routeName = '/profile';

  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SignInCubit>(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'الملف الشخصي',
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: 20,
                color: Theme.of(context).brightness == Brightness.dark
                    ? TColors.white
                    : TColors.black,
              ),
            ),
            centerTitle: true,
          ),
          body: const ProfileViewBody(),
        ),
      ),
    );
  }
}
