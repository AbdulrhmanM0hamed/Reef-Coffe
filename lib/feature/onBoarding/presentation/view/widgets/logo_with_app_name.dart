
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hyper_market/core/utils/constants/assets.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';

class LogoWithAppName extends StatelessWidget {
  const LogoWithAppName({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    var sizeWidth = MediaQuery.of(context).size.width;
    var sizeheight = MediaQuery.of(context).size.height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.asset(AssetsManager.logo , height: sizeheight/10, width: sizeheight/10,),
        SizedBox(
          width: MediaQuery.of(context).size.width / 20,
        ),
        Column(
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "هايير ", // النص الأول
                    style: getBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size30,
                        color: TColors.primary),
                  ),
                  TextSpan(
                    text: "ماركت", // النص الثاني
                    style: getBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size30,
                        color: TColors.secondary),
                  ),
                ],
              ),
            ),
            Text(
              "ابحث وتسوق",
              style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  color: TColors.darkGrey,
                  fontSize: FontSize.size16),
            ),
          ],
        )
      ],
    );
  }
}