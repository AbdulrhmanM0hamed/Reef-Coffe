import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';

class PriceDisplay extends StatelessWidget {
  final double price;
  final double fontSize;

  const PriceDisplay({
    super.key,
    required this.price,
    this.fontSize = FontSize.size20,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'السعر',
          style: getMediumStyle(
            fontFamily: FontConstant.cairo,
            fontSize: fontSize - 4,
            color: TColors.darkGrey,
          ),
        ),
        Text(
          '$price جنيه',
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: fontSize,
            color: TColors.primary,
          ),
        ),
      ],
    );
  }
}
