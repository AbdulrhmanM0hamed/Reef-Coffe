import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';

import 'package:hyper_market/core/widgets/add_and_del.dart';
import 'package:hyper_market/feature/products/domain/entities/product.dart';

class PriceWithButton_add_min extends StatelessWidget {
  final Product product;

  const PriceWithButton_add_min({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sizeWidth = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (product.hasDiscount)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${product.discountPrice?.toStringAsFixed(2)} جنيه',
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: sizeWidth * 0.04,
                  color: Colors.green.shade700,
                ),
              ),
              Text(
                '${product.price.toStringAsFixed(2)} جنيه',
                style: TextStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: sizeWidth * 0.035,
                  color: Colors.grey.shade700,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: Colors.grey.shade600,
                  decorationThickness: 1,
                ),
              ),
            ],
          )
        else
          Text(
            '${product.price.toStringAsFixed(2)} جنيه',
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: sizeWidth * 0.04,
              color: TColors.secondary,
            ),
          ),
        AddAndDeleteItem(
          sizeWidth: sizeWidth,
          number: 1,
          onPressedAdd: () {},
          onPressedDel: () {},
        ),
      ],
    );
  }
}
