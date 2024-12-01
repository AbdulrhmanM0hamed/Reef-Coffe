import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';

class ReviewsWidget extends StatelessWidget {
  const ReviewsWidget({
    super.key,
    required this.sizeWidth,
  });

  final double sizeWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.star,
          color: TColors.pound,
          size: sizeWidth * 0.06,
        ),
        SizedBox(
            width: sizeWidth * 0.025), // استخدام 2.5% من عرض الشاشة
        Text(
          "4.5",
          style: getSemiBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: sizeWidth * 0.04),
        ),
        SizedBox(
            width: sizeWidth * 0.025), // استخدام 2.5% من عرض الشاشة
        Text(
          "(+30)",
          style: getRegularStyle(
              fontFamily: FontConstant.cairo,
              fontSize: sizeWidth * 0.04,
              color: TColors.darkGrey),
        ),
        SizedBox(
            width: sizeWidth * 0.025), // استخدام 2.5% من عرض الشاشة
        Text(
          "المراجعة",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: sizeWidth * 0.041,
            color: TColors.primary,
            decoration: TextDecoration.underline,
          ),
        ),
      ],
    );
  }
}
