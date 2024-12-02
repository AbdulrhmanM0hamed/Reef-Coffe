import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/core/widgets/add_and_del.dart';

class PriceWithButton_add_min extends StatelessWidget {
  const PriceWithButton_add_min({
    super.key,
    required this.sizeWidth,
  });

  final double sizeWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '100 جنيه/ كيلو',
          style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: sizeWidth * 0.04,
              color: TColors.secondary),
        ),
        AddAndDeleteItem(sizeWidth: sizeWidth , number: 1, onPressedAdd: (){}, onPressedDel: (){},),
      ],
    );
  }
}

