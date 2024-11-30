import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';

class OutlineWidget extends StatelessWidget {
  const OutlineWidget({
    super.key,
    required this.image,
    required this.title,
  });

  final String image;
  final String title;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Row(
      children: [
        SvgPicture.asset(image, height: size.height * 0.04, width: size.height * 0.04),
        SizedBox(
          width: size.width * 0.04,
        ),
        Text(
          title,
          style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              color: TColors.darkGrey,
              fontSize: size.height * 0.02),
        ),
      ],
    );
  }
}
