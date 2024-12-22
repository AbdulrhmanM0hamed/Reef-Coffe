import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';

class QuantityDisplay extends StatelessWidget {
  final int quantity;
  final double fontSize;

  const QuantityDisplay({
    super.key,
    required this.quantity,
    this.fontSize = FontSize.size18,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        quantity.toString(),
        style: getBoldStyle(
          fontFamily: FontConstant.cairo,
          fontSize: fontSize,
          color: TColors.primary,
        ),
      ),
    );
  }
}
