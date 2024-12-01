import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';

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
        Row(
          children: [
            Container(
              width: sizeWidth * 0.1,
              height: sizeWidth * 0.1,
              decoration: BoxDecoration(
                color: TColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.add,
                color: Theme.of(context).brightness == Brightness.dark
                    ? TColors.black
                    : TColors.white,
                size: sizeWidth * 0.05,
              ),
            ),
            SizedBox(
                width: sizeWidth * 0.03),
            Text(
              '4',
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: sizeWidth * 0.045,
              ),
            ),
            SizedBox(
                width: sizeWidth * 0.03), // استخدام 3% من عرض الشاشة
            Icon(
              Icons.remove,
              color: Theme.of(context).brightness == Brightness.dark
                  ? TColors.grey
                  : TColors.black,
              size: sizeWidth * 0.055,
            ),
          ],
        ),
      ],
    );
  }
}