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
    return Row(
      children: [
        SvgPicture.asset(image ,  ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 25,
        ),
        Text(
          title,
          style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              color: TColors.darkGrey,
              fontSize: FontSize.size16),
        ),
      ],
    );
  }
}
