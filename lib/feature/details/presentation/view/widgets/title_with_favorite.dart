
import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';

class TitleWithFavorite extends StatelessWidget {
  const TitleWithFavorite({
    super.key,
    required this.sizeWidth,
  });

  final double sizeWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'تفاح أحمر',
          style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: sizeWidth * 0.05),
        ),
        const Spacer(),
        const Icon(
          Icons.favorite_border,
          color: TColors.darkGrey,
        ),
      ],
    );
  }
}
