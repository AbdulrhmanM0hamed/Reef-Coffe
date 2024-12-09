import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/products/domain/entities/product.dart';

class ReviewsWidget extends StatelessWidget {
  final Product product;

  const ReviewsWidget({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final sizeWidth = MediaQuery.of(context).size.width;
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
          product.rating.toString(),
          style: getSemiBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: sizeWidth * 0.04),
        ),
        SizedBox(
            width: sizeWidth * 0.025), // استخدام 2.5% من عرض الشاشة
        Text(
          "(${product.ratingCount})",
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
