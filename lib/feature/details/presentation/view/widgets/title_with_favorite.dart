import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/feature/products/domain/entities/product.dart';

class TitleWithFavorite extends StatelessWidget {
  final Product product;

  const TitleWithFavorite({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sizeWidth = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Text(
          product.name,
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: sizeWidth * 0.05,
          ),
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
