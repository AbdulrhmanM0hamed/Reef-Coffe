import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';

class OutLineOfProducts extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeMorePressed;

  const OutLineOfProducts({
    super.key,
    required this.title,
    this.onSeeMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (onSeeMorePressed != null)
          InkWell(
            onTap: onSeeMorePressed,
            child: Text(
              ' المزيد',
              style: getSemiBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size16,
                  color: TColors.primary),
            ),
          ),
      ],
    );
  }
}
