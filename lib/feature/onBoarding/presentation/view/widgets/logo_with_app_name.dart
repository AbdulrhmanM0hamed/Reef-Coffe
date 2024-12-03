import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hyper_market/core/utils/constants/assets.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/strings_manager.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';

class LogoWithAppName extends StatelessWidget {
  const LogoWithAppName({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.asset(AssetsManager.logo, height: size.height * 0.1, width: size.height * 0.1),
        SizedBox(
          width: size.width * 0.05,
        ),
        Column(
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: StringManager.hyper, // النص الأول
                    style: getBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: size.height * 0.035,
                        color: TColors.primary),
                  ),
                  TextSpan(
                    text: StringManager.market, // النص الثاني
                    style: getBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: size.height * 0.035,
                        color: TColors.secondary),
                  ),
                ],
              ),
            ),
            Text(
              StringManager.startShopping,
              style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  color: TColors.darkGrey,
                  fontSize: size.height * 0.02),
            ),
          ],
        )
      ],
    );
  }
}
