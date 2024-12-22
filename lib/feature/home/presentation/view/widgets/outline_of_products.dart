import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';

class OutLineOfProducts extends StatelessWidget {
  const OutLineOfProducts({
    super.key,
    required this.title,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: getBoldStyle(
                fontFamily: FontConstant.cairo, fontSize: FontSize.size20)),
        TextButton(
          onPressed: () {},
          child: Text(" المزيد",
              style: getSemiBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size18,
                  color: TColors.primary)),
        ),
      ],
    );
  }
}
