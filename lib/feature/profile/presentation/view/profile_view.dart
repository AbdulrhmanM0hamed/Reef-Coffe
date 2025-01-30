import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/services/service_locator.dart';
import 'package:hyper_market/feature/auth/presentation/controller/signin/signin_cubit.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/cart/presentation/cubit/cart_cubit.dart';
import 'package:hyper_market/feature/orders/presentation/cubit/orders_cubit.dart';
import 'package:hyper_market/feature/profile/presentation/view/widgets/profile_view_body.dart';

class ProfileView extends StatelessWidget {
  static const String routeName = '/profile';
  final String userName;
  final String userEmail;
  const ProfileView(
      {super.key, required this.userName, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<SignInCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<CartCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<OrdersCubit>(),
        ),
      ],
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
          body: ProfileViewBody(userName: userName, userEmail: userEmail),
        ),
      ),
    );
  }
}
