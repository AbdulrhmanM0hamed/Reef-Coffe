
import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/auth/presentation/view/signin_view.dart';

class HavaAnAccount extends StatelessWidget {
  const HavaAnAccount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "لديك حساب بالفعل؟",
          style: getSemiBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size16,
            color: TColors.textSecondary,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, SigninView.routeName);
          },
          child: Text(
            "تسجيل الدخول",
            style: getSemiBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size16,
              color: TColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
