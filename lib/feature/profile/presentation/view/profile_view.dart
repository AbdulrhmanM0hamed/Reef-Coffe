import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';

import 'widgets/profile_view_body.dart';

class ProfileView extends StatelessWidget {
  static const String routeName = '/profile';

  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
