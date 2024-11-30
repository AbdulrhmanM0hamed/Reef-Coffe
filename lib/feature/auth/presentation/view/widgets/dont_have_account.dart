
import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/auth/presentation/view/signup_view.dart';

class DontHaveAccount extends StatelessWidget {
  const DontHaveAccount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          textAlign: TextAlign.center,
          "لا تمتلك حساب ؟",
          style: getSemiBoldStyle(fontFamily: FontConstant.cairo, fontSize: FontSize.size16, color: TColors.textSecondary),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, SignupView.routeName);
          },
          child: Text(
            textAlign: TextAlign.center,
            "سجل الان",
            style: getSemiBoldStyle(fontFamily: FontConstant.cairo, fontSize: FontSize.size17, color: TColors.primary),
          ),
        ),
      ],
    );
  }
}



